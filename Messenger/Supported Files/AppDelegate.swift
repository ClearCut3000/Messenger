//
//  AppDelegate.swift
//  Messenger
//
//  Created by Николай Никитин on 28.04.2022.
//
import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    guard error == nil else {
      if let error = error {
        print("Fialed to log in with Google wuth error - \(error)")
      }
      return
    }

    print("Did sign in with Google")
    guard let email = user.profile.email,
          let firstName = user.profile.givenName,
          let lastName = user.profile.familyName else { return }

    DatabaseManager.shared.userExists(with: email) { exists in
      if !exists {
        //Insert to database
        let chatUser = ChatAppUser(firstName: firstName,
                                   lastName: lastName,
                                   emailAddress: email)
        DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
          if success {
            //upload image
          }
        })
      }
    }

    guard let authentication = user.authentication else {
      print("Missint auth object off Google user")
      return
    }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                   accessToken: authentication.accessToken)
    FirebaseAuth.Auth.auth().signIn(with: credential) { authResult, error in
      guard authResult != nil, error == nil else {
        print("Failde to log in with google credential")
        return
      }
      print("Successfully signed in with Google ")
      NotificationCenter.default.post(name: .didLogInNotification, object: nil)
    }
  }

  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    print("Google user was disconnected")
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.delegate = self

    return true
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ApplicationDelegate.shared.application(app,
                                           open: url,
                                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                           annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    return GIDSignIn.sharedInstance().handle(url)
  }
}

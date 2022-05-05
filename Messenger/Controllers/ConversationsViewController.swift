//
//  ConversationsViewController.swift
//  Messenger
//
//  Created by Николай Никитин on 28.04.2022.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {


  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    validateAuth()
  }

  //MARK: - Methods
  private func validateAuth() {
    if FirebaseAuth.Auth.auth().currentUser == nil {
      let vc = LoginViewController()
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .fullScreen
      present(nav, animated: false)
    }
  }

}


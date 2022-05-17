//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Николай Никитин on 04.05.2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {

  //MARK: - Properties
  static let shared = DatabaseManager()
  private let database = Database.database().reference()

  //MARK: - Methods
  static func safeEmail(emailAddress: String) -> String {
    return emailAddress.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
  }
}

//MARK: - Account Management
extension DatabaseManager {
  public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
    var safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
      guard snapshot.value as? String != nil else {
        completion(false)
        return
      }
      completion(true)
    }
  }

  /// Inserts new user in to database
  public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
    database.child(user.safeEmail).setValue([
      "first_name": user.firstName,
      "last_name": user.lastName
    ]) { error, _ in
      guard error == nil else {
        print("Failed to write to database.")
        completion(false)
        return
      }
      completion(true)
    }
  }
}

struct ChatAppUser {
  let firstName: String
  let lastName: String
  let emailAddress: String
  var safeEmail: String {
    return emailAddress.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
  }
  var profilePictureFileName: String {
    return "\(safeEmail)_rofile_pictire.png"
  }
}

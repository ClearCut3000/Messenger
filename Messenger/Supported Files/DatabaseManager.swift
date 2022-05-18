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
  public enum DatabaseError: Error {
    case failedToFetch
  }

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
      self.database.child("users").observeSingleEvent(of: .value) { snapshot in
        if var usersCollection = snapshot.value as? [[String: String]] {
          //append to user dictionary
          let newElement = ["name": user.firstName + " " + user.lastName, "email": user.safeEmail]
          usersCollection.append(newElement)
          self.database.child("users").setValue(usersCollection) { error, _ in
            guard error == nil else {
              completion(false)
              return
            }
            completion(true)
          }
        } else {
          //create that array
          let newCollection: [[String: String]] = [["name": user.firstName + " " + user.lastName, "email": user.safeEmail]]
          self.database.child("users").setValue(newCollection) { error, _ in
            guard error == nil else {
              completion(false)
              return
            }
            completion(true)
          }
        }
      }
    }
  }

  public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
    database.child("users").observeSingleEvent(of: .value) { snapshot in
      guard let value = snapshot.value as? [[String: String]] else {
        completion(.failure(DatabaseError.failedToFetch))
        return
      }
      completion(.success(value))
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

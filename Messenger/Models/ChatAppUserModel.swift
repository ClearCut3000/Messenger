//
//  ChatAppUserModel.swift
//  Messenger
//
//  Created by Николай Никитин on 18.06.2022.
//

import Foundation

struct ChatAppUser {
  let firstName: String
  let lastName: String
  let emailAddress: String
  var safeEmail: String {
    return emailAddress.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
  }
  var profilePictureFileName: String {
    return "\(safeEmail)_profile_picture.png"
  }
}

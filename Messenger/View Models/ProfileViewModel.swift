//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Николай Никитин on 15.06.2022.
//

import Foundation

enum ProfileViewModelType {
  case info, logout
}

struct ProfileViewModel {
  let viewModelType: ProfileViewModelType
  let title: String
  let hendler: (() -> Void)?
}

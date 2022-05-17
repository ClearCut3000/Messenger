//
//  StorageManager.swift
//  Messenger
//
//  Created by Николай Никитин on 13.05.2022.
//

import Foundation
import FirebaseStorage

final class StorageManager {

  //MARK: - Properties
  static let shared = StorageManager()
  private let storage = Storage.storage().reference()
  public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
  public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloaderUrl
  }

  //MARK: - Methods
  /// Uploads picture to firebase storage and returns completion with url string to download
  public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
    storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
      guard error == nil else {
        //failed
        print("Failed to upload data to firebase for picture")
        completion(.failure(StorageErrors.failedToUpload))
        return
      }
      self.storage.child("images/\(fileName)").downloadURL { url, error in
        guard let url = url else {
          print("Failed to get download URL.")
          completion(.failure(StorageErrors.failedToGetDownloaderUrl))
          return
        }
        let urlString = url.absoluteString
        print("Download URL returned: \(urlString)")
        completion(.success(urlString))
      }
    }
  }

  public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
    let reference = storage.child(path)
    reference.downloadURL { url, error in
      guard let url = url, error == nil else {
        completion(.failure(StorageErrors.failedToGetDownloaderUrl))
        return
      }
      completion(.success(url))
    }
  }
}

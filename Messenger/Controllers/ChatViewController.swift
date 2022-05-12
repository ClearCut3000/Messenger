//
//  ChatViewController.swift
//  Messenger
//
//  Created by Николай Никитин on 11.05.2022.
//

import UIKit
import MessageKit

struct Message: MessageType {
  var sender: SenderType
  var messageId: String
  var sentDate: Date
  var kind: MessageKind
}

struct Sender: SenderType {
  var photoURL: String
  var senderId: String
  var displayName: String
}

class ChatViewController: MessagesViewController {

  //MARK: - Properties
  private var messages = [Message]()
  private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Doe")

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    messages.append(Message(sender: selfSender,
                            messageId: "1",
                            sentDate: Date(),
                            kind: .text("Hello World Message!")))
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
  }

}

//MARK: - Messages DataSource & LayoutDelegate & DisplayDelegate
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
  func currentSender() -> SenderType {
    return selfSender
  }

  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
  }

  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }


}

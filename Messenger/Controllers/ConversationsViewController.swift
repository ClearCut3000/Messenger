//
//  ConversationsViewController.swift
//  Messenger
//
//  Created by Николай Никитин on 28.04.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {

  //MARK: - Subview's
  private let spinner = JGProgressHUD(style: .dark)

  private let tableView: UITableView = {
    let table = UITableView()
    table.isHidden = true
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()

  private let noConversationsLabel: UILabel = {
    let label = UILabel()
    label.text = "No conversations!"
    label.textAlignment = .center
    label.textColor = .gray
    label.font = .systemFont(ofSize: 21, weight: .medium)
    label.isHidden = true
    return label
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    view.addSubview(noConversationsLabel)
    setupTableView()
    fetchConversations()
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

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }

  private func fetchConversations() {

  }
}

//MARK: - UITableView Delegate & DataSource Protocols
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let vc = ChatViewController()
    vc.title = "Some Chat"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
}

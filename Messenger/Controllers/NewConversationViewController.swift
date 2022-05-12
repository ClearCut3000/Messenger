//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Николай Никитин on 28.04.2022.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {

  //MARK: - Subview's
  private let spinner = JGProgressHUD()

  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search for users..."
    return searchBar
  }()

  private let tableView: UITableView = {
    let table = UITableView()
    table.isHidden = true
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()

  private let noResultsLabel: UILabel = {
    let label = UILabel()
    label.isHidden = true
    label.text = "No Results"
    label.textAlignment = .center
    label.textColor = .green
    label.font = .systemFont(ofSize: 21, weight: .medium)
    return label
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.topItem?.titleView = searchBar
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(dismissSelf))
    searchBar.becomeFirstResponder()
  }

  //MARK: - Action's
  @objc private func dismissSelf() {
    dismiss(animated: true, completion: nil)
  }

}

//MARK: - UISearchBarDelegate
extension NewConversationViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    <#code#>
  }
}

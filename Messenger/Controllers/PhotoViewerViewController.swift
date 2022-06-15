//
//  PhotoViewerViewController.swift
//  Messenger
//
//  Created by Николай Никитин on 28.04.2022.
//

import UIKit

final class PhotoViewerViewController: UIViewController {

  //MARK: - Properties
  private let url: URL

  //MARK: - Subview's
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  //MARK: - Init's
  init(with url: URL) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Photo"
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .black
    view.addSubview(imageView)
    imageView.sd_setImage(with: url, completed: nil)
  }
  
  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    imageView.frame = view.bounds
  }
}

//
//  LocationPickerViewController.swift
//  Messenger
//
//  Created by Николай Никитин on 08.06.2022.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {

  //MARK: - Properties
  public var completion: ((CLLocationCoordinate2D) -> Void)?
  private var isPickable = true
  private var coordinates: CLLocationCoordinate2D?

  //MARK: - Subview's
  private let map: MKMapView = {
    let map = MKMapView()
    return map
  }()

  //MARK: - Init's
  init(coordinates: CLLocationCoordinate2D?) {
    self.coordinates = coordinates
    self.isPickable = coordinates == nil
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    if isPickable {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                          style: .done,
                                                          target: self,
                                                          action: #selector(sendButtonTapped))
      map.isUserInteractionEnabled = true
      let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapMap(_:)))
      gesture.numberOfTapsRequired = 1
      gesture.numberOfTouchesRequired = 1
      map.addGestureRecognizer(gesture)
    } else {
      //Just showing location
      guard let coordinates = self.coordinates else { return }
      //drop pin in presented location
      let pin = MKPointAnnotation()
      pin.coordinate = coordinates
      map.addAnnotation(pin)
    }
    view.addSubview(map)
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    map.frame = view.bounds
  }

  //MARK: - Action's
  @objc func sendButtonTapped() {
    guard let coordinates = coordinates else { return }
    navigationController?.popViewController(animated: true)
    completion?(coordinates)
  }

  @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
    let locationInView = gesture.location(in: map)
    let coordinates = map.convert(locationInView, toCoordinateFrom: map)
    self.coordinates = coordinates
    for annotation in map.annotations {
      map.removeAnnotation(annotation)
    }
    //drop pin in that location
    let pin = MKPointAnnotation()
    pin.coordinate = coordinates
    map.addAnnotation(pin)
  }

}

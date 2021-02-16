//
//  FinalizeCreatePinVC.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/21/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit
import MapKit

protocol FinalizeCreatePinVCDelegate: class {
    func dismissFinalizeCreatePinVC()
}

class FinalizeCreatePinVC: UIViewController {
    
    //MARK: - Properties
    let createNewPinButton: CustomButton = {
        let button = CustomButton(title: "Create a new Pin")
        button.addTarget(self, action: #selector(handleCreatePin), for: .touchUpInside)
        return button
    }()
    var mapView = MKMapView()
    var student: StudentInformation!
    var delegate: FinalizeCreatePinVCDelegate?
    

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        showLocation(of: student)
        
    }
    
    
    //MARK: - Helpers
    
    func configure() {
        view = mapView
        view.addSubview(createNewPinButton)
        createNewPinButton.translatesAutoresizingMaskIntoConstraints = false
        createNewPinButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        NSLayoutConstraint.activate([
            createNewPinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createNewPinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            createNewPinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            createNewPinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func finishAddingLocation() {
        NetworkManager.shared.sendStudentLocation(with: student) { (success, error) in
            if error != nil {
                self.presentCustomAlertOnMainThread(title: "Unable to upload location", message: "please try again", buttonTitle: "Ok")
            }
            DispatchQueue.main.async {
                self.delegate?.dismissFinalizeCreatePinVC()
            }
        }
    }
    
    func showLocation(of: StudentInformation) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: of) {
            let annotation = MKPointAnnotation()
            annotation.title = of.firstName! + " " + of.lastName!
            annotation.subtitle = of.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func extractCoordinate(location: StudentInformation) -> CLLocationCoordinate2D? {
        if let latitude = location.latitude, let longitude = location.longitude {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return nil
    }
    
 
    //MARK: - Methods
    @objc func handleCreatePin() {
        finishAddingLocation()
    }
}


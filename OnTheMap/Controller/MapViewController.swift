//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit
import MapKit

protocol LogoutFromMapVCDelegate: class {
    func logOutFromMapVC()
}

class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    var mapView = MKMapView()
    var locations: [StudentInformation] = []
    var delegate: LogoutFromMapVCDelegate?
    
    let refreshMapButton: CustomButton = {
        let button = CustomButton(title: nil)
        let icon = UIImage(systemName: "arrow.clockwise")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        button.setImage(icon, for: .normal)
        button.backgroundColor = nil
        button.addTarget(self, action: #selector(refreshMapData), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocationData()
        mapView.delegate = self
    }
    
    
    //MARK: - Helpers
    
    func loadLocationData() {
        NetworkManager.shared.getStudentLocations { [weak self] (studentLocations, error) in
            guard let self = self else { return }
    
            if error != nil {
                self.presentCustomAlertOnMainThread(title: "Unable to retrieve data", message: "There was an error downloading locations.", buttonTitle: "Ok")
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = nil
                }
            }
    
            guard let studentLocations = studentLocations else {return}
            DispatchQueue.main.async {
                self.locations = studentLocations.results
                self.configurePins()
            }
        }
    }
    
    func refreshPinsOnMap() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        loadLocationData()
        presentCustomAlertOnMainThread(title: "Pins Refreshed", message: "Map data has been updated.", buttonTitle: "Ok")
    }

    func configurePins() {
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            let lat = CLLocationDegrees(dictionary.latitude!)
            let long = CLLocationDegrees(dictionary.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName!
            let last = dictionary.lastName!
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        
    }

    
    //MARK: - Methods
    
    @objc func refreshMapData() {
        refreshPinsOnMap()
    }
    
    @objc func handleCreatePinVCinMapVC() {
        let createPinVC = CreatePinVC()
        createPinVC.delegate = self
        let navController = UINavigationController(rootViewController: createPinVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    @objc func logoutFromMap() {
        NetworkAuthenticationManager.shared.endSession { (error) in
            if error != nil {
                self.presentCustomAlertOnMainThread(title: "Unable to logout", message: "Unable to process your request, please try again.", buttonTitle: "Ok")
            }
        }
        delegate?.logOutFromMapVC()
    }
    
    func configure() {
        view = mapView
        view.backgroundColor = .systemBackground
        configureMapVCNavigation()
    }
    
    func configureMapVCNavigation() {
        let createPinButton = UIBarButtonItem(image: SFSymbols.updateLocation, style: .plain, target: self, action: #selector(handleCreatePinVCinMapVC))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutFromMap))
        let refreshButton = UIBarButtonItem(image: SFSymbols.refresh, style: .plain, target: self, action: #selector(refreshMapData))
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [createPinButton, refreshButton]
    }
}


//MARK: - MapView Delegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .systemIndigo
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openMediaLink(with: toOpen)
            }
        }
    }
}


//MARK: - CreatePinVC Delegate

extension MapViewController: CreatePinVCDelegate {
    func dismissCreatePinVC() {
        dismiss(animated: true)
        refreshMapData()
    }
}

//
//  CreatePinVC.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/20/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit
import MapKit

protocol CreatePinVCDelegate: class {
    func dismissCreatePinVC()
}

class CreatePinVC: UIViewController {

    //MARK: - Properties
    let locationTextField = CustomTextField(placholder: "Ender a location")
    let linkTextField = CustomTextField(placholder: "Enter a link to share")
    var delegate: CreatePinVCDelegate?
    
    let activityIndicator = UIActivityIndicatorView()
    var objectId: String?
    var latitude : Double?
    var longitude : Double?
    var firstName: String!
    var lastName: String!
    
    
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        retreiveUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        retreiveUserInfo()
    }
    
    

    //MARK: - Configuration
    func configure() {
        view.backgroundColor = .systemBackground
        configureNavigationButtons()
        view.addSubviews(locationTextField, linkTextField, activityIndicator)
        NSLayoutConstraint.activate([
            
            locationTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            linkTextField.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20),
            
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
        
        configureUIElements(locationTextField, linkTextField)
        configureTextFields(locationTextField, linkTextField)
        
    }
    
    func configureNavigationButtons() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
        let findLoationButton = UIBarButtonItem(title: "Find my location", style: .plain, target: self, action: #selector(handleFindLocation))

        navigationItem.leftBarButtonItem = findLoationButton
        navigationItem.rightBarButtonItem = cancelButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemIndigo
    }
    
    func configureTextFields(_ textFields: UITextField...) {
        for textfield in textFields {
            textfield.backgroundColor = .systemIndigo
        }
    }
    
    @objc func handleFindLocation() {
        activityIndicator.startAnimating()
        let newLocation = locationTextField.text
        
        guard let url = URL(string: self.linkTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.presentCustomAlertOnMainThread(title: "Invalid link", message: "Please include 'https://' in the link", buttonTitle: "Ok")
            activityIndicator.stopAnimating()
            return
        }
        
        geocodePosition(newLocation: newLocation ?? "")
        
    }
    
    
    @objc func handleDismiss() {
        self.dismiss(animated: true)
    }
    //MARK: - Methods
    func retreiveUserInfo() {
        activityIndicator.startAnimating()
        NetworkAuthenticationManager.shared.retrieveUserInfo(withKey: TabBarVC.studentKey) { (response, error) in
            
            if error != nil {
                self.presentCustomAlertOnMainThread(title: "Unable to load User data", message: "Please try again", buttonTitle: "Ok")
            }
            guard let response = response else { return }
            print(response)
            DispatchQueue.main.async {
                self.firstName = response.firstName
                self.lastName = response.lastName
            }
        }
        activityIndicator.stopAnimating()
    }
    func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.presentCustomAlertOnMainThread(title: "Something went wrong..", message: error.localizedDescription, buttonTitle: "Ok")
                self.activityIndicator.startAnimating()
            } else {
                
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.presentFinalizeCreatePinVC(location.coordinate)
                } else {
                    self.presentCustomAlertOnMainThread(title: "Unable to find location", message: "Please try again.", buttonTitle: "Ok")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func presentFinalizeCreatePinVC(_ coordinate: CLLocationCoordinate2D) {
        let controller = FinalizeCreatePinVC()
        controller.student = prepareStudentInfo(coordinate)
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    func prepareStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        let student = StudentInformation(createdAt: "", firstName: firstName, lastName: lastName, latitude: coordinate.latitude, longitude: coordinate.longitude, mapString: locationTextField.text ?? "", mediaURL: linkTextField.text?.lowercased() ?? "", objectId: "", uniqueKey: TabBarVC.studentKey, updatedAt: "")
        print(student)
        return student
    }
}

//MARK: - FinalizePinVC Delegate
extension CreatePinVC: FinalizeCreatePinVCDelegate {
    func dismissFinalizeCreatePinVC() {
        self.navigationController?.popViewController(animated: false)
        delegate?.dismissCreatePinVC()
    }
}

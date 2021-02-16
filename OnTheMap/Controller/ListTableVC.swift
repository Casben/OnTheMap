//
//  ListTableVC.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

protocol LogoutFromListTableVCDelegate: class {
    func logOutFromListVC()
}

class ListTableVC: UITableViewController {
    
    //MARK: - Properties
    
    var locations: [StudentInformation] = []
    var delegate: LogoutFromListTableVCDelegate?
    

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadLocationData()
        
    }
    
    //MARK: - Methods
    
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
            self.locations = studentLocations.results
            self.reloadTableView()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func refreshCells() {
        locations.removeAll()
        reloadTableView()
        loadLocationData()
        presentCustomAlertOnMainThread(title: "Data Refreshed", message: "Location data has been updated.", buttonTitle: "Ok")
    }
    
    //MARK: - Helpers
    
    @objc func logoutFromList() {
        NetworkAuthenticationManager.shared.endSession { (error) in
            if error != nil {
                self.presentCustomAlertOnMainThread(title: "Unable to logout", message: "Unable to process your request, please try again.", buttonTitle: "Ok")
            }
        }
        delegate?.logOutFromListVC()
    }
    
    @objc func handleCreatePinVCinListVC() {
        let createPinVC = CreatePinVC()
        createPinVC.delegate = self
        let navController = UINavigationController(rootViewController: createPinVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    @objc func handleRefreshTable() {
        print("tapped")
        refreshCells()
    }
    
    //MARK: - Configuration
    
    func configure() {
        configureMapVCNavigation()
        tableView.register(MapListCell.self, forCellReuseIdentifier: MapListCell.reuseID)
        tableView.removeExcessCells()
    }
    
    func configureMapVCNavigation() {
        let createPinButton = UIBarButtonItem(image: SFSymbols.updateLocation, style: .plain, target: self, action: #selector(handleCreatePinVCinListVC))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutFromList))
        let refreshButton = UIBarButtonItem(image: SFSymbols.refresh, style: .plain, target: self, action: #selector(handleRefreshTable))
        navigationController?.navigationBar.tintColor = .systemIndigo
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [createPinButton, refreshButton]
    }
    
    
    // MARK: - TableView Configuration
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapListCell.reuseID) as! MapListCell
        let student = self.locations[indexPath.row]
        cell.configureCell(with: student)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        if let toOpen = location.mediaURL {
            openMediaLink(with: toOpen)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}


//MARK: - CreatePinVC Delegate
extension ListTableVC: CreatePinVCDelegate {
    func dismissCreatePinVC() {
        dismiss(animated: true)
        refreshCells()
    }
}

//
//  TabBarVC.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/19/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    //MARK: - Properties
    static var studentKey: String!
    
        
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Helpers
    
    func configure() {
        let mapVC = MapViewController()
        let listVC = ListTableVC()
        mapVC.delegate = self
        listVC.delegate = self
       
        self.modalPresentationStyle = .fullScreen
        setViewControllers([constructNavController(unselectedImage: SFSymbols.mapPin, selectedImage: SFSymbols.mapPin, tabBarItemTitle: "Map", rootViewController: mapVC), constructNavController(unselectedImage: SFSymbols.list, selectedImage: SFSymbols.list, tabBarItemTitle: "List", rootViewController: listVC)], animated: true)
        
    
    }
    
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, tabBarItemTitle: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.title = tabBarItemTitle
        tabBar.tintColor = .systemIndigo

        return navController
    }

}

//MARK: - LogoutFromMapVC Delegate

extension TabBarVC: LogoutFromMapVCDelegate {
    func logOutFromMapVC() {
        dismiss(animated: true)
    }
}

//MARK: - LogoutFromListVC Delegate
extension TabBarVC: LogoutFromListTableVCDelegate {
    func logOutFromListVC() {
        dismiss(animated: true)
    }
    
    
}

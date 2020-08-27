//
//  Extensions.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

//MARK: - UIView Helper Methods
extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

//MARK: - UIViewController Helper Methods

extension UIViewController {
    
    func presentCustomAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = CustomAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func validateUrl (urlString: String?) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
        
    }
    
    func openMediaLink(with Url: String) {
        let app = UIApplication.shared
        let confirmedURL = validateUrl(urlString: Url)
        if confirmedURL {
            app.openURL(URL(string: Url)!)
        } else {
            presentCustomAlertOnMainThread(title: "Bad Url", message: "The Url must contain 'http' or the provided Url is invalid", buttonTitle: "Ok")
        }
    }
    
    func configureUIElements(_ views: UIView...) {
        let padding: CGFloat = 50
        for view in views {
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
                view.heightAnchor.constraint(equalToConstant: padding)
            ])
        }
    }
    
    
}


//MARK: - UITableView Helper Methods
extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}


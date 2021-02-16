//
//  MapListCell.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

class MapListCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let reuseID = "MapListCell"
    let mapIcon = UIImageView()
    let studentName = UILabel()
    let mediaLabel = UILabel()
    
    
    //MARK: - Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - Helpers
    
    func configureCell(with location: StudentInformation) {
        let firstName = location.firstName ?? "First Name: N/A"
        let lastName = location.lastName ?? "Last Name: N/A"
        let mediaUrl = location.mediaURL ?? "No link provided.."
        
        studentName.text = firstName + " " + lastName
        mediaLabel.text = mediaUrl
    }
    
    func configure() {
        addSubviews(mapIcon, studentName, mediaLabel)
        setProperties()
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            mapIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mapIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            mapIcon.heightAnchor.constraint(equalToConstant: 25),
            mapIcon.widthAnchor.constraint(equalToConstant: 25),
            
            studentName.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            studentName.leadingAnchor.constraint(equalTo: mapIcon.trailingAnchor, constant: 16),
            studentName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            studentName.heightAnchor.constraint(equalToConstant: 40),
            
            mediaLabel.leadingAnchor.constraint(equalTo: mapIcon.trailingAnchor, constant: 16),
            mediaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16),
            mediaLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12),
            mediaLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        mediaLabel.font = .systemFont(ofSize: 16, weight: .thin)
    }
    
    func setProperties() {
        mapIcon.image = SFSymbols.pin
        mapIcon.tintColor = .systemIndigo
    }

}

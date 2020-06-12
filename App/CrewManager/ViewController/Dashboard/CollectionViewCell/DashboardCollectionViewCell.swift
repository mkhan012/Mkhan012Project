//
//  DashboardCollectionViewCell.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit

//set idenifer as class name
extension UICollectionViewCell {
    open override var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class DashboardCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlet
    @IBOutlet var imageMenu: UIImageView! // menu label
    @IBOutlet var lblTitle: UILabel! // title label
}

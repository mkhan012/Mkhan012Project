//
//  ListTableViewCell.swift
//  CrewManager
//
//  Created by Muhammad Khan
//

import UIKit

//set reuseIdentifier as a name of the class
extension ListTableViewCell {
    override var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

//Dashboard table view
class ListTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet var imageMenu: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

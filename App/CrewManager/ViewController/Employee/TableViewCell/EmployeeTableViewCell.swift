//
//  EmployeeTableViewCell.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  Copyright © 2020 MuhammadKhan. All rights reserved.
//

import UIKit

/*
 the purpose of name is that we can use in multiple places so thats a reason I did not write a proper name referece view variable 
 **/
class EmployeeTableViewCell: UITableViewCell {
    
    //MARK:- IBOutlet
    @IBOutlet weak var stackView1: UIStackView! //
    @IBOutlet weak var stackView2: UIStackView!//
    @IBOutlet weak var stackView3: UIStackView!//
    @IBOutlet weak var stackView4: UIStackView!//
    
    @IBOutlet weak var lblTitle1: UILabel! //
    @IBOutlet weak var lblDetail1: UILabel!//
    
    @IBOutlet weak var lblTitle2: UILabel!//
    @IBOutlet weak var lblDetail2: UILabel!//
    
    @IBOutlet weak var lblTitle3: UILabel!//
    @IBOutlet weak var lblDetail3: UILabel!//

    @IBOutlet weak var lblTitle4: UILabel!//
    @IBOutlet weak var lblDetail4: UILabel!//

}

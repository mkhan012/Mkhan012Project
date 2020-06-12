//
//  MenuItems.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import Foundation
import UIKit

//MARK:- Structures
// menu item for make menu and store references
struct  MenuItems {
    
    var title: String! // title of menu
    var imageIconName: String! // left image icon
    var imageIcon: UIImage! // image
    var viewControllerIdentifier: String? // view controller identifer
    var storyboard: UIStoryboard? // storyboard reference
    var navigationController: UINavigationController? // navigation controller reference
    var viewController: UIViewController? // view contrlller reference
    var isViewController: Bool! // check viewcontrller visablity
    
    // constructor initlizer
    init(title: String,
         imageIconName: String,
         vcId: String?,
         storyboard: UIStoryboard?,
         isViewController: Bool = false) {
        
        self.title = title
        self.imageIconName = imageIconName
        self.viewControllerIdentifier = vcId
        self.storyboard = storyboard
        self.imageIcon = UIImage(named: self.imageIconName)!
        
        if self.storyboard != nil && self.viewControllerIdentifier != nil {
            if isViewController {
                self.viewController = self.storyboard!.instantiateViewController(withIdentifier: self.viewControllerIdentifier!)
            } else {
                self.navigationController = self.storyboard!.instantiateViewController(withIdentifier: self.viewControllerIdentifier!) as? UINavigationController
            }
        }
    }
    
    // constructore initlizer 
    init(title: String, imageIconName: String, viewController: UIViewController) {
        
        self.title = title
        self.imageIconName = imageIconName
        self.viewControllerIdentifier = String(describing: type(of: viewController))
        self.imageIcon = UIImage(named: self.imageIconName)!
        self.navigationController = UINavigationController(rootViewController: viewController)
    }
}

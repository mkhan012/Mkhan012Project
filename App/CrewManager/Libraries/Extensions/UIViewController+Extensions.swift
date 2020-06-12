//
//This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit
import Foundation
import UserNotifications
//import ARSLineProgress

typealias HUD = SVProgressHUD
//typealias ALTHUProgress = ARSLineProgress

//MARK:- UIViewController Extension
extension UIViewController {
    func setGradientLayer(colorTop:UIColor = .purple , colorBottom: UIColor = .blue) {
        
        var gradient:CAGradientLayer!
        gradient = CAGradientLayer()
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at:0)
    }
    
    func showLoadingActivity(_ message: String = "Loading") {
        
        HUD.show(withStatus: message)
    }
    
    func hideLoadingActivity() {
        
        HUD.dismiss()
    }
//
    func addChildViewController(_ controller: UIViewController,
                                containerView: UIView,
                                preserverViewController: UIViewController? = nil) {
        
        self.removeAllChildViewControllers(preserverViewController)
        
        self.addChild(controller)
        controller.view.frame = containerView.bounds
        containerView.insertSubview(controller.view, at: 0)
        controller.didMove(toParent: self)
        
        controller.view.layoutIfNeeded()
    }
    
    func removeAllChildViewControllers(_ except: UIViewController? = nil) {
        
        func removeVCFromParent(_ childController: UIViewController) {
            childController.willMove(toParent: nil)
            childController.view.removeFromSuperview()
            childController.removeFromParent()
        }
        
        for childController in self.children {
            
            if except == nil {
                removeVCFromParent(childController)
            } else if except != nil && except != childController {
                removeVCFromParent(childController)
            }
        }
    }
    
    func showErrorAlertView(title: String = "Error", message: String = "", actionHandler:(() -> Void)? = nil) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction) in
            actionHandler?()
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showConfirmationAlertView(title: String = "Confirmation",
                                   message: String = "",
                                   cancelTitle: String = "No",
                                   confirmTitle: String = "Yes",
                                   rejectionHandler:(() -> Void)? = nil,
                                   confirmationHandler:@escaping (() -> Void)) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: confirmTitle,
                                          style: .default,
                                          handler: { (action: UIAlertAction) in
                                            confirmationHandler() }))
        
        alertView.addAction(UIAlertAction(title: cancelTitle,
                                          style: .cancel,
                                          handler: { (action: UIAlertAction) in
                                            
                                            rejectionHandler?()
        }))
        
        alertView.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertView, animated: true,
                     completion: nil)
    }
    
    func showActionSheetForImageInput(title: String? = nil,
                                      message: String = "Choose Image Source",
                                      cancelTitle: String = "Cancel",
                                      confirmationHandler:@escaping ((_ imageSource: UIImagePickerController.SourceType) -> Void)) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            alertView.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in confirmationHandler(.camera) }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            alertView.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in confirmationHandler(.photoLibrary) }))
        }
        
        alertView.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        
        self.presentAlertView(alertView)
    }
    
    
    func checkNotificationPermissions(permission: @escaping ((Bool) -> Void)) {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            permission(granted)
            
            if granted == false {
                
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Notification Alert", message: "Kindly enable push notifications for using this service.", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                })
            }
        }
    }
    
    func presentAlertView(_ alertView: UIViewController, completion: (() -> Void)? = nil) {
        
        alertView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertView, animated: true, completion: completion)
    }
    
    public func setRoot(for viewController: UIViewController,
                                       duration: TimeInterval = 0.3,
                                       options: UIView.AnimationOptions = .transitionCrossDissolve,
                                       completion: ((Bool) -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        guard let rootViewController = window.rootViewController else {
            return
        }
        
        viewController.view.frame = rootViewController.view.frame
        viewController.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: duration, options: options, animations: {
            window.rootViewController = viewController
        }, completion: completion)
    }
    
    func pop(_ backStep: Int = 1, animated: Bool = true) {
        
        guard let navController = self.navigationController else { return }
        
        if backStep > 1 {
            navController.popToViewController(navController.viewControllers[navController.viewControllers.count - (backStep+1)], animated: animated)
        } else {
            navController.popViewController(animated: animated)
        }
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):    return l >= r
    default:            return !(lhs < rhs)
    }
}

extension UIViewController {
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewController() as? UIAlertController else { return nil }
        return alert
    }
}

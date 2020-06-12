



import UIKit
import SwiftMessages


//MARK:- SwiftMessages
extension SwiftMessages {
    
    class func showToast(_ message: String, type: Theme = .warning, buttonTitle: String? = nil) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        if let buttonTitle = buttonTitle {
            
            view.configureContent(title: nil,
                                  body: message,
                                  iconImage: nil,
                                  iconText: nil,
                                  buttonImage: nil,
                                  buttonTitle: buttonTitle, buttonTapHandler: { _ in SwiftMessages.hide() })
        } else {
            view.configureContent(title: "", body: message)
            view.button?.isHidden = true
        }
        
        view.bodyLabel?.font = UIFont.robotoRegular(13.0)
        view.configureTheme(type, iconStyle: .default)
        view.configureDropShadow()
        view.titleLabel?.isHidden = true
        view.backgroundView.backgroundColor = R.ThemeColor.selectedColor
        
        var config = SwiftMessages.defaultConfig
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = .seconds(seconds: type == .warning ? 1.5:2.0)
        
        SwiftMessages.show(config: config, view: view)
    }
    
    
    class func showMessageToast(_ message: String, title: String) -> UIView {
        
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .messageView)
        
        view.button?.isHidden = true
        
        // Theme message elements with the warning style.
        view.configureTheme(.info)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        view.configureContent(title: title, body: message)
        
        return view
        // Show the message.
        //SwiftMessages.show(view: view)
        
    }
}

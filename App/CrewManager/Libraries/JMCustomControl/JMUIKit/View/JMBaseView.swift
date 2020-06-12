//
//  //This is not my code, i took this from git hub link below
//   https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit

class JMBaseView: UIView {
    
    private var containerStackView: JMStackView?
    
    convenience init(withBackgroundColor color: UIColor = .white, alpha opacity: CGFloat = 1.0, containerStackView container: JMStackView? = nil) {
        
        self.init(frame: .zero)
        
        self.backgroundColor = color
        self.alpha = opacity
        self.containerStackView = container
    }
    
    
    override func didMoveToSuperview() {
        
        if containerStackView != nil {
            
            setup()
        }
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if containerStackView != nil {
            
            addSubview(containerStackView!)
            containerStackView!.addConstraintsForContainerStackViewInScrollView()
        }
    }
}

//
//  This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit


class JMScrollView: UIScrollView {
    
    private var containerStackView: JMStackView!
    
    
    convenience init(withContainerStackView view: JMStackView) {
        
        self.init(frame: .zero)
        
        self.containerStackView = view
        self.keyboardDismissMode = .interactive
    }
    
    override func didMoveToSuperview() {
        
        setup()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endEditing(true)
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerStackView)
        containerStackView.addConstraintsForContainerStackViewInScrollView()
    }
}

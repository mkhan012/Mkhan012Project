//
//  //This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit

class JMBottomFormView: UIView {
    
    private var actionButtons: [UIView]!
    private lazy var stackView = JMStackView(subviews: actionButtons, axis: .horizontal, distribution: .fillEqually, alignment: .fill, spacing: 8.0, layoutMargin: NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
    
    
    convenience init(withButtons buttons: [JMBaseButton]) {
        
        self.init(frame: .zero)
        
        self.actionButtons = buttons
    }
    
    convenience init(withSimpleViews views: [UIView]) {
        
        self.init(frame: .zero)
        
        self.actionButtons = views
    }
    
    public func setActionButtons(buttons: [JMBaseButton]) {
        
        self.actionButtons = buttons
        
        self.stackView.removeAllArrangedViews()
        self.stackView.addArrangedSubviews(self.actionButtons)
    }
    
    public func setSimpleUIViews(views: [UIView]) {
        
        self.actionButtons = views
        
        self.stackView.removeAllArrangedViews()
        self.stackView.addArrangedSubviews(self.actionButtons)
    }
    
    private func setup() {
        
        backgroundColor = .white

        addSubview(stackView)

        addHeightConstraint(height: 55.0)
        stackView.addConstraintsWRTSuperViewEdges()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { self.addUpperShadow() }
    }
    
    override func didMoveToSuperview() {
        
        if superview != nil { setup() }
    }
}


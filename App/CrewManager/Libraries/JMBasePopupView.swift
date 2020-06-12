//
//  This is not my code, i took this from git hub link below
// https://github.com/muhammadrizwananjum/HelpingLibraries

import Foundation


import UIKit

protocol JMBasePopupViewDelegate: class { }

class JMBasePopupView: UIView {

    
    // MARK: - View Properties
    private lazy var backgroundView = JMBaseView(withBackgroundColor: .black, alpha: 0.5)
    private lazy var containerView = JMBaseView(withBackgroundColor: .white)
    private lazy var mainScrollView = JMScrollView(withContainerStackView: containerStackView)
    private lazy var containerStackView = JMStackView(subviews: [], alignment: .fill)
    private lazy var topTitleView = JMBaseView(withBackgroundColor: R.ThemeColor.selectedColor)
    private lazy var lblTitle = JMLabel(text: "", textColor: .white, fontSize: 15.0, textAlignment: .center)
    private lazy var bottomView = JMBottomFormView(withButtons: [btnCancel])
    private lazy var btnCancel = JMBaseButton(withTitle: "Cancel")
    
    
    // MARK: - Private Properties
    private let minHeight: CGFloat = 200.0
    private var heightConstant: CGFloat!
    private var heightConstraint: NSLayoutConstraint!
    private var superContainerView: UIView!
    
    
    // MARK: - Public Properties
    public var title: String! { didSet { lblTitle.text = title }}
    public var popupViews: [UIView] = [] { didSet { setupContainerViews() }}
    public var actionButtons: [JMBaseButton] = [] { didSet { bottomView.setActionButtons(buttons: actionButtons) }}
    public var adjustHeightAutomatically: Bool = true
    public var shouldAlignedToCenter: Bool = false
    public weak var basePopupViewDelegate: JMBasePopupViewDelegate?
    
    convenience init(withTitle titleStr: String,
                     withHeight height: CGFloat = 200.0,
                     shouldAlignedToCenter isCenter: Bool = true,
                     showInView view: UIView = UIApplication.topViewController()!.view) {
        
        self.init(frame: .zero)
        
        heightConstant = height
        title = titleStr
        superContainerView = view
        shouldAlignedToCenter = isCenter
        
        superContainerView.addSubview(self)
    }
    
    public func show(_ animated: Bool = true) {
        
        self.endEditing(true)
        
        if animated { UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: { self.isHidden = false }) }
        else { isHidden = false }
    }
    
    public func hide(_ animated: Bool = true) {
        
        if animated { UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: { self.isHidden = true }) }
        else { isHidden = true }
        
    }
    
    private func setupContainerViews() {
        
        containerStackView.removeAllArrangedViews()
        containerStackView.addArrangedSubviews(popupViews)
        
        adjustHeightIfNeeded()
        
    }
    
    public func adjustHeightIfNeeded() {
        
        if adjustHeightAutomatically {
            
            let maxHeight = superContainerView.height - (topTitleView.height + bottomView.height + 50.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                
                let contentHeight = self.mainScrollView.contentSize.height + self.topTitleView.height + self.bottomView.height
                self.heightConstraint.constant = max(self.minHeight, min(contentHeight, maxHeight))
                UIView.animate(withDuration: 0.1) { self.containerView.layoutIfNeeded() }
            }
        }
    }
    
    private func setup() {
        
        backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(containerView)
        
        containerView.addSubview(topTitleView)
        containerView.addSubview(mainScrollView)
        topTitleView.addSubview(lblTitle)
        containerView.addSubview(bottomView)
        
        addConstraintsWRTSuperViewEdges()
        backgroundView.addConstraintsWRTSuperViewEdges()
        if shouldAlignedToCenter { containerView.addConstraintsWRTSuperViewCenters(); containerView.addWidthConstraint(width: superContainerView.width - 30.0) }
        else { containerView.addConstraintsWRTSuperViewTopRightLeftEdges(withPadding: 15.0) }
        heightConstraint = containerView.addHeightConstraint(height: heightConstant)
        topTitleView.addConstraintsWRTSuperViewTopRightLeftEdges()
        topTitleView.addHeightConstraint(height: 45.0)
        lblTitle.addConstraintsWRTSuperViewCenters()
        bottomView.addConstraintsWRTSuperViewRightLeftBottomEdges()
        mainScrollView.addConstraintsForScrollViewWRTSuperView(withTopView: topTitleView, bottomView: bottomView)
        
        
        containerView.roundCorner(4.0)
        
        
        btnCancel.clickHandler = { [unowned self] (sender: JMBaseButton) in self.hide() }
        
        lblTitle.text = title
        
        isHidden = true
    }
    
    override func didMoveToSuperview() {
        
        if self.superview != nil {
            
            setup()
        }
    }
}




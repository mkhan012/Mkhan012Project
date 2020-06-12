//
//  This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries

import UIKit


@IBDesignable public class JMLabel: UILabel {
    
    lazy private var tapGesture = UITapGestureRecognizer(target: self, action: #selector(JMLabel.tapGestureRecognized(_:)))
    
    
    public var clickHandler : ((JMLabel) -> Void)? {
        didSet {
            isUserInteractionEnabled = true
            tapGesture.numberOfTouchesRequired = 1
            addGestureRecognizer(tapGesture)
        }
    }
    
//    #if !TARGET_INTERFACE_BUILDER
//    #endif
    
    @IBInspectable public var topInset: CGFloat = 0.0 { didSet { layoutIfNeeded(); invalidateIntrinsicContentSize() } }
    @IBInspectable public var bottomInset: CGFloat = 0.0 { didSet { layoutIfNeeded(); invalidateIntrinsicContentSize() } }
    @IBInspectable public var leftInset: CGFloat = 0.0 { didSet { layoutIfNeeded(); invalidateIntrinsicContentSize() } }
    @IBInspectable public var rightInset: CGFloat = 0.0 { didSet { layoutIfNeeded(); invalidateIntrinsicContentSize() } }
    
    
    
    // MARK: - Override Methods
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)))
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    
    convenience init(text: String, textColor color: UIColor = R.ThemeColor.DarkTextColor, fontSize size: CGFloat = 13.0, textAlignment aligment: NSTextAlignment = .natural, withBoldFont isBold: Bool = false, edgeInsets: UIEdgeInsets = .zero) {
        
        self.init(frame: .zero)
        
        
        self.font = isBold ? UIFont.robotoBold(size):UIFont.robotoRegular(size)
        self.textColor = color
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = aligment
        
        self.text = text
        
        if edgeInsets.bottom > 0 || edgeInsets.top > 0 || edgeInsets.right > 0 || edgeInsets.left > 0 {
            self.topInset = edgeInsets.top
            self.bottomInset = edgeInsets.bottom
            self.leftInset = edgeInsets.left
            self.rightInset = edgeInsets.right
        }
    }
    
    convenience init(text: NSAttributedString) {
        
        self.init(frame: .zero)
        
        
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .left
        attributedText = text
        
    }
    
    public override init(frame: CGRect) {

        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc private func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        clickHandler?(self)
    }
}

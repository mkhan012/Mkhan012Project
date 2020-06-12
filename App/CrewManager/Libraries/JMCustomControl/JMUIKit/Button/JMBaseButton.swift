//
//  //This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries

import UIKit

class JMBaseButton : UIButton {

    
    // MARK: - Public Properties
    public var clickHandler : ((JMBaseButton) -> Void)? {
        didSet {
            self.addTarget(self, action: #selector(JMBaseButton.handleClick(_:)), for: .touchUpInside)
        }
    }
    
    
    // MARK: - Init Methods
    convenience init(withImage name: String) {
        
        self.init(type: .custom)
        
        setImage(UIImage(named: name), for: .normal)
    }
    
    convenience init(withTitle title: String) {
        
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .disabled)
        titleLabel?.font = UIFont.robotoRegular(15.0)
        backgroundColor = R.ThemeColor.selectedColor
        
        roundCorner(2.5)
    }

    convenience init(withAttributedTitle title: NSAttributedString, textAlignment alignment: UIControl.ContentHorizontalAlignment  = .left) {
        
        self.init(type: .system)
                
        setAttributedTitle(title, for: .normal)
        setAttributedTitle(title, for: .selected)
        
        contentHorizontalAlignment = alignment
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
    }

    
    #if !TARGET_INTERFACE_BUILDER

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    #endif
    
    // MARK: - Setup view
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Events
    @objc fileprivate func handleClick(_ sender: UIButton) {
        if clickHandler != nil {
            clickHandler!(self)
        }
    }
}

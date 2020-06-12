
////This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries

//

import Foundation


@IBDesignable class JMCustomHeader: UIView {
    
    
    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var lblTitle: UILabel!
    @IBOutlet fileprivate weak var lblCompulsory: UILabel!
    @IBOutlet fileprivate weak var btnPrimary: JMBaseButton!
    @IBOutlet fileprivate weak var topBorder: UIImageView!
    @IBOutlet fileprivate weak var bottomBorder: UIImageView!
    @IBOutlet fileprivate weak var rightBorder: UIImageView!
    @IBOutlet fileprivate weak var leftBorder: UIImageView!
    
    
    // MARK: - Private Variables
    fileprivate var view: UIView!
    fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JMCustomHeader.tapGestureRecognized(_:)))
    
    
    // MARK: - Public Properties
    /// user can select borderStyles
    public var borderStyles: JMBorderStyles = JMBorderStyles.default { didSet { changeBorderStyle() } }
    public var viewTappedCallBack: (() -> Void)? { didSet { addTapGestureRecognizer() } }
    public var headerButtonCallBack: (() -> Void)?
    
    
    // MARK: - IBInspectable Properties
    /**
     The title of the `View` instance.
     User can set view  title
     
     */
    @IBInspectable var title: String {
        
        get {
            return lblTitle.text ?? ""
        } set(newText) {
            lblTitle.text = shouldCapitalizedText ? newText.uppercased() : newText.capitalized
        }
    }
    
    /**
     The isCompulsory of the `View` instance.
     User can set view as Compulsory
     
     */
    @IBInspectable var isCompulsory: Bool {
        
        get {
            return !(lblCompulsory.isHidden)
        } set(newVal) {
            lblCompulsory.isHidden = !newVal
        }
    }
    
    /**
     
     The parameter of the `isEnable` instance.
     User can set view as isEnable or disable.
     
     */
    @IBInspectable var isEnable: Bool {

        get {
            return isUserInteractionEnabled
        }
        set(enabled) {
            isUserInteractionEnabled = enabled
            btnPrimary.alpha = enabled ? 1.0:0.5
        }
    }
    
    /**
     
     The parameter of the `txtColor` instance.
     User can set Text Colour.
     
     */
    @IBInspectable var viewBackgroundColor: UIColor = JMControls.JMCustomHeaderBackgroundColor {
        
        didSet {
            view.backgroundColor = viewBackgroundColor
        }
    }
    
    /**
     
     The parameter of the `txtColor` instance.
     User can set Text Colour.
     
     */
    @IBInspectable var titleColor: UIColor = JMControls.JMCustomHeaderTextColor {
        
        didSet {
            lblTitle.textColor = titleColor
        }
    }
    
    /**
     
     The parameter of the `buttonImage` instance.
     User can set buttonImage Image.
     
     */
    
    @IBInspectable var headerButtonImageName: String! {
        
        didSet {
            btnPrimary.setImage(UIImage(named: headerButtonImageName), for: .normal)
        }
    }
    
    /**
     
     The parameter of the `buttonImage` instance.
     User can set buttonImage Image.
     
     */
    
    @IBInspectable var isHeaderButtonHidden: Bool {
        
        get {
            return btnPrimary.isHidden
        }
        set (newVal) {
            btnPrimary.isHidden = newVal
        }
    }
    
    /**
     
     The parameter to change the Font for header title.
     True :Normal
     Fasle : Font is Bold
     
     */
    
    @IBInspectable var shouldUseNormalFont: Bool = true {
        
        didSet { changeTitleFont() }
    }
    
    @IBInspectable var shouldCapitalizedText: Bool = true {
        
        didSet {
            title = title.lowercased()
        }
    }
    
    
    // MARK: - Public Initializer
    convenience init(withTitle titleStr: String, isCompulsory compulsory: Bool = false) {
        
        self.init(frame: .zero)
        
        title = titleStr
        isCompulsory = compulsory
    }
    
    
    // MARK: - Private Methods
    fileprivate func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
        btnPrimary.isHidden = true
        btnPrimary.clickHandler = { [unowned self] (button: JMBaseButton) in
            self.headerButtonCallBack?()
        }
        
        changeBorderStyle()
    }
    
    fileprivate func addTapGestureRecognizer() {
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: JMControls.JMCustomHeaderNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    fileprivate func changeBorderStyle() {
        
        rightBorder.isHidden = !borderStyles.contains(.right)
        bottomBorder.isHidden = !borderStyles.contains(.bottom)
        leftBorder.isHidden = !borderStyles.contains(.left)
        topBorder.isHidden = !borderStyles.contains(.top)
    }
    
    fileprivate func changeTitleFont() {

        self.lblTitle.font = self.shouldUseNormalFont ? UIFont.robotoRegular(K.IS_IPAD ? 14.0:12.0):UIFont.robotoBold(K.IS_IPAD ? 14.0:12.0)
    }
    
    
    // MARK: - Events
    @objc fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        
        viewTappedCallBack?()
    }
    
    
    // MARK: - Override Methods
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func resignFirstResponder() -> Bool {
        
        return super.resignFirstResponder()
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: view.width, height: JMControls.JMCustomHeaderDefaultHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.changeTitleFont()
    }
}

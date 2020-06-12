//
//This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit
import SwiftMessages

protocol JMTextFieldDelegate: class {
    
    func JMTextFieldDidBeginEditing(_ textField: JMTextField)
    func JMTextFieldDidEndEditing(_ textField: JMTextField)
}

extension JMTextFieldDelegate {
    
    func JMTextFieldDidBeginEditing(_ textField: JMTextField) {}
    func JMTextFieldDidEndEditing(_ textField: JMTextField) {}
}

@IBDesignable class JMTextField: UIView {
    
    
    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var lblTitle: UILabel!
    @IBOutlet fileprivate weak var lblCompulsory: UILabel!
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var topBorder: UIImageView!
    @IBOutlet fileprivate weak var bottomBorder: UIImageView!
    @IBOutlet fileprivate weak var rightBorder: UIImageView!
    @IBOutlet fileprivate weak var leftBorder: UIImageView!
    @IBOutlet fileprivate weak var btnInfo: JMBaseButton!
    
    // MARK: - Private Variables
    private var placeHolderString: String = "Add"
    fileprivate var view: UIView!
    fileprivate var allowedCharacters: String?
    fileprivate var charactersLimit = 500
    fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JMTextField.tapGestureRecognized(_:)))
    
    
    // MARK: - Public Properties
    public var textChangedCallback: (() -> Void)?
    
    ///  select JMTextFieldDelegate field for implimetation delegate method.
    public weak var textFieldDelegate: JMTextFieldDelegate?
    
    /// user can select borderStyles
    public var borderStyles: JMBorderStyles = JMBorderStyles.default { didSet { changeBorderStyle() } }
    
    /// user can select textFieldType
    public var textFieldType: JMTextFieldType = .alphaNumeric { didSet { self.setupTextFieldOnTypeChanges() } }
    
    public var infoButtonCallBack: (() -> Void)?
    
    public var afterDecimalCount = 5
    // MARK: - IBInspectable Properties
    /**
     The title of the `View` instance.
     User can set view  title
     
     */
    
    @IBInspectable var title: String? {
        
        get {
            
            return lblTitle.text
            
        } set(newText) {
            
            lblTitle.text = newText
        }
    }
    
    /**
     The instance of the `View`  has filed name TextField.
     User can set view  text to filed
     
     */
    
    @IBInspectable var text: String {
        
        get {
            
            return textField.text?.cleanedString() ?? ""
            
        } set(newText) {

            textField.text =  newText
            
            changeTitleLabelColorIfNeeded()
        }
    }
    
    /**
     The placeholder of the `View` instance.
     User can set  placeholder of textField
     
     
     */
    
    @IBInspectable var placeholder: String? {
        
        get {
            return placeHolderString
            
        } set(newText) {
            
            placeHolderString = newText ?? ""
            textField.placeholder = showPlaceholder ? placeHolderString:""
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
     The textLimit of the `View` instance filed of textfield.
     User can set  textLimit to textField
     
     */
    
    @IBInspectable var textLimit: Int {
        
        get {
            
            return charactersLimit
            
        } set(newVal) {
            
            charactersLimit = newVal
        }
    }
    
    /**
     
     The parameter of the `isEnable` instance of JMTextField.
     User can set view as isEnable or disable.
     
     */
    
    @IBInspectable var isEnable: Bool {
        
        get {
            return isUserInteractionEnabled
        }
        set(enabled) {
            isUserInteractionEnabled = enabled
            
            view.backgroundColor = enabled ? .white : JMControls.DisabledColor
            textField.textColor = enabled ? JMControls.NormalColor : .gray
            textField.clearButtonMode = enabled ? .always : .never
        }
    }
    
    /**
     The Show info of the `View` instance.
     User can set view as Compulsory
     
     
     */
    
    @IBInspectable var showInfoButton: Bool {
        
        get {
            
            return !(btnInfo.isHidden)
            
        } set(newVal) {
            
            btnInfo.isHidden = !newVal
        }
    }
    
  
    
    /// It will show or hide placeholder text
    @IBInspectable var showPlaceholder: Bool {
        
        get {
            return placeholder!.count > 0
        }
        set(show) {
            textField.placeholder = show ? placeHolderString:""
        }
    }
    
    /**
     
     This message will be displayed when validation failed.
     Default message will be shown if not set
     
     */
    @IBInspectable var validationMessage: String = ""
    
    /**
     The isSecureTextEntry of the `View` instance.
     User can set  bool value for SecureTextEntry
     
     
     */
    
    @IBInspectable var isSecureTextEntry: Bool {
        get {
            return textField.isSecureTextEntry
        }
        set(flag) {
            textField.isSecureTextEntry = flag
        }
    }
        
    // MARK: - Public Getters
    
    /**
     
     The perimeter of the `isValid` instance.
     
     - Returns: isCompulsory behaviour.
     
     */
    
    var isValid: Bool {
        
        let valid = isCompulsory && !isHidden ? (text.count > 0) : true
        
        if !valid {
            if validationMessage.count > 0 {
                SwiftMessages.showToast(validationMessage)
            } else {
                SwiftMessages.showToast("Please enter \(title?.capitalized ?? "Text").")
            }
        }
        
        return valid
    }
    
    
    // MARK: - Public Initializer
    convenience init(withTitle titleStr: String, isCompulsory compulsory: Bool = true, textFieldType type: JMTextFieldType = JMTextFieldType.alphaNumeric, textLimit limit: Int = Int.max) {
        
        self.init(frame: .zero)
        
        title = titleStr
        isCompulsory = compulsory
        textFieldType = type
        textLimit = limit
        
        setupTextFieldOnTypeChanges()
    }
    
    
    // MARK: - Private Methods
    fileprivate func setup() {
        
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
        textField.delegate = self
        
        showInfoButton = false
        
        textField.addTarget(self, action: #selector(JMTextField.textFieldTextDidChange(_:)), for: UIControl.Event.editingChanged)
        
        addGestureRecognizer(tapGestureRecognizer)
        
        btnInfo.clickHandler = { [unowned self] (button: JMBaseButton) in
            self.infoButtonCallBack?()
        }
        
        changeBorderStyle()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: JMControls.TextFieldNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    @objc fileprivate func textFieldTextDidChange(_ textField: UITextField) {
        
        checkTextLength(textField)
        textChangedCallback?()
    }
    
    fileprivate func checkTextLength(_ textField: UITextField) {
        
        guard let prospectiveText = textField.text, prospectiveText.count > textLimit else {
            return
        }
        
        let selection = textField.selectedTextRange
        text = String(prospectiveText[..<prospectiveText.index(prospectiveText.startIndex, offsetBy: textLimit)])
        textField.selectedTextRange = selection
    }
    
    fileprivate func setupTextFieldOnTypeChanges() {
        
        switch self.textFieldType {
            
        case .numbersOnly:
            allowedCharacters = JMControls.NumbersOnlyString
            textField.keyboardType = .numberPad
            
        case .faxNumber:
            allowedCharacters = JMControls.FaxAllowedChars
            textField.keyboardType = .numberPad
            
        case .email:
            textField.keyboardType = .emailAddress
        
        case .numbersWithDecimal:
            allowedCharacters = JMControls.DecimalsOnlyString
            textField.keyboardType = .decimalPad
            
        default:
            break
        }
    }
    
    fileprivate func changeTitleLabelColorIfNeeded() {
        
        lblTitle.textColor = text.count > 0 ? JMControls.LightColor : JMControls.NormalColor
    }
    
    @objc fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        
        textField.becomeFirstResponder()
    }
    
    fileprivate func changeBorderStyle() {
        
        rightBorder.isHidden = !borderStyles.contains(.right)
        bottomBorder.isHidden = !borderStyles.contains(.bottom)
        leftBorder.isHidden = !borderStyles.contains(.left)
        topBorder.isHidden = !borderStyles.contains(.top)
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        
        return textField.becomeFirstResponder()
    }

    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: view.width, height: JMControls.TextFieldHeight)
    }
}


extension JMTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textFieldType == .numbersWithDecimal {
            if let txt = textField.text, let floatAmount = Float(txt), floatAmount <= 0 { textField.text = "" }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textFieldType == .numbersWithDecimal {
            if let txt = textField.text, let floatAmount = Float(txt), floatAmount <= 0 { textField.text = "0.00" }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        changeTitleLabelColorIfNeeded()
        
        textFieldDelegate?.JMTextFieldDidEndEditing(self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        lblTitle.textColor = JMControls.LightColor
        
        textFieldDelegate?.JMTextFieldDidBeginEditing(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textFieldType == .numbersWithDecimal && string != "" && afterDecimalCount > 0 {
            let charcount = prospectiveText.components(separatedBy: ".")
            
            if charcount.count > 1 && (charcount.last!.count >= afterDecimalCount + 1) {
                return false
            }
            if let _ = Double(prospectiveText) { } else {
                if prospectiveText.count > 1 && string == "." { return false }
            }
        }
        
        guard let allowedChar = allowedCharacters, prospectiveText.count > 0 else {
            return true
        }
        
        if textFieldType == .numbersWithDecimal {
            
            let isNumeric = prospectiveText.isEmpty || (Double(prospectiveText) != nil)
            let numberOfDots = prospectiveText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = prospectiveText.firstIndex(of: ".") { numberOfDecimalDigits = prospectiveText.distance(from: dotIndex, to: prospectiveText.endIndex) - 1 }
            else { numberOfDecimalDigits = 0 }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }
        else { return prospectiveText.rangeOfCharacter(from: CharacterSet(charactersIn: allowedChar).inverted) == nil }
    }
}

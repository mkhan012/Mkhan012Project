//
//This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit
import SwiftMessages


/**
 A set of optional methods that you use to manage the editing and validation of text in a text View object.
 
 ## CCTextViewDelegate Methods
 - A text field calls the methods of its delegate in response to important changes. You use these methods to validate text that was typed by the user, to respond to specific interactions with the keyboard, and to control the overall editing process. Editing begins shortly before the text field becomes the first responder and displays the keyboard (or its assigned input view). The flow of the editing process is as follows:
 - Before becoming the first responder, the text field calls its delegate’s ccTextViewDidBeginEditing(_:) method. Use that method to allow or prevent the editing of the text field’s contents.
 The text field becomes the first responder.
 
 
 */
protocol JMTextViewDelegate: class {
    
    func ccTextViewDidChange(_ textView: JMTextView)
    func ccTextViewDidBeginEditing(_ textView: JMTextView)
    func ccTextViewDidEndEditing(_ textView: JMTextView)
}

extension JMTextViewDelegate {
    
    func ccTextViewDidChange(_ textView: JMTextView) {}
    func ccTextViewDidBeginEditing(_ textView: JMTextView) {}
    func ccTextViewDidEndEditing(_ textView: JMTextView) {}
}

/**
 and an object that manages a view hierarchy for your UIKit app.
 
 - Parameter recipient: The person being greeted.
 
 
 The CCTextView class defines the shared behavior that is common to all view controllers. You rarely create instances of the CCTextView class directly. Instead, you subclass CCTextView and add the methods and properties needed to manage the view controller's view hierarchy.
 A CCTextView main responsibilities include the following:
 
 Updating the contents of the views, usually in response to changes to the underlying data.
 Responding to user interactions with views.
 Resizing views and managing the layout of the overall interface.
 Coordinating with other objects—including other view controllers—in your app.
 
 
 ## Parameters
 - title: String  =  user can set title own his requirment.
 - isCompulsory:  Bool =  user can set  isCompulsory filed
 - isEnable:  Bool =  user can set isEnable own his requirment.
 - shouldBeCancelable: Bool = user can set shouldBeCancelable own his requirment.
 - borderStyles: CCBorderStyles =  user can set interface own his requirment.
 
 - Returns:
 - by default select date: Selected Data/ Autopopulate data.
 - valueChangedCallback
 
 */

@IBDesignable class JMTextView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var viewHeader: JMCustomHeader!
    @IBOutlet fileprivate weak var lblPlaceholder: UILabel!
    @IBOutlet fileprivate weak var textView: UITextView!
    @IBOutlet fileprivate weak var lblRemainingCount: UILabel!
    @IBOutlet fileprivate weak var bottomBorder: UIImageView!
    @IBOutlet fileprivate weak var rightBorder: UIImageView!
    @IBOutlet fileprivate weak var leftBorder: UIImageView!
    
    
    // MARK: - Private Variables
    fileprivate var charactersLimit = 500
    fileprivate var view: UIView!
    
    
    // MARK: - Public Variables
    public var textChangedCallback: (() -> Void)?
    
    /// user can select borderStyles
    public var borderStyles: JMBorderStyles = JMBorderStyles.default { didSet { changeBorderStyle() } }
    ///  select CCtextViewDelegate field for implimetation delegate method.
    weak var delegate: JMTextViewDelegate?
    
    
    // MARK: - Inspectable Properties
    
    @IBInspectable var shouldCapitalizedText: Bool = true {
        
        didSet {
            viewHeader.shouldCapitalizedText = shouldCapitalizedText
        }
    }
    
    /**
     The title of the `View` instance.
     User can set view  title
     
     
     */
    
    @IBInspectable var title: String {
        
        get {
            return viewHeader.title
        }
        set(text) {
            viewHeader.title = shouldCapitalizedText ? text.uppercased() : text
        }
    }
    
    /**
     The instance of the `View`  has filed name textView.
     User can set view  text to filed
     
     */
    
    @IBInspectable var text: String {
        
        get {
            return textView.text
        }
        set {
            if newValue.count <= charactersLimit {
                
                textView.text = newValue
                updateRemainingCount(remainingChars: charactersLimit - newValue.count)
                
            } else {
                
                let index = newValue.index(newValue.startIndex, offsetBy: charactersLimit)
                
                textView.text = String(newValue[ ..<index ])
                updateRemainingCount(remainingChars: 0)
            }
            
            lblPlaceholder.isHidden = text.count > 0
        }
    }
    
    /**
     The textLimit of the `View` instance filed of textView.
     User can set  textLimit to textView
     
     
     */
    
    @IBInspectable var textLimit: Int {
        
        get {
            return charactersLimit
        }
        set (newVal) {
            charactersLimit = newVal
            updateRemainingCount(remainingChars: newVal)
        }
    }
    
    /**
     The placeholder of the `View` instance.
     User can set  placeholder of textView
     
     
     */
    @IBInspectable var placeholder: String? {
        
        get {
            return lblPlaceholder.text
        }
        set(text) {
            lblPlaceholder.text = text
        }
    }
    
    /**
     The showCounterLabel of the `View` instance.
     User can get text as character count
     
     
     */
    @IBInspectable var showCounterLabel: Bool {
        
        get {
            return !lblRemainingCount.isHidden
        }
        set (newVal) {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lblRemainingCount.isHidden = !newVal
                self.invalidateIntrinsicContentSize()
                self.superview?.setNeedsLayout()
                self.superview?.layoutIfNeeded()
            })
        }
    }
    
    /**
     The isCompulsory of the `View` instance.
     User can set view as Compulsory
     
     
     */
    @IBInspectable var isCompulsory: Bool {
        
        get {
            return viewHeader.isCompulsory
        }
        set(newVal) {
            viewHeader.isCompulsory = newVal
        }
    }
    
    /**
     
     The parameter of the `isEnable` instance of CCtextView.
     User can set view as isEnable or disable.
     
     
     */
    @IBInspectable var isEnable: Bool {
        
        get {
            return textView.isEditable
        }
        set(enabled) {
            //            isUserInteractionEnabled = enabled
            textView.isEditable = enabled
            view.backgroundColor = enabled ? .white : JMControls.DisabledColor
            textView.textColor = enabled ? JMControls.NormalColor : .gray
        }
    }
    
    /**
     
     The parameter of the `showHeader` instance.
     User can set view as true or false.
     
     
     */
    @IBInspectable var showHeader: Bool {
        
        get {
            return !viewHeader.isHidden
        }
        set(show) {
            viewHeader?.isHidden = !show
            invalidateIntrinsicContentSize()
        }
    }
    
    /**
     
     This message will be displayed when validation failed.
     Default message will be shown if not set
     
     */
    @IBInspectable var validationMessage: String = ""
    
    /**
     
     The perimeter of the `isValid` instance.
     
     - Returns: isCompulsory behaviour.
     
     */
    
    var isValid: Bool {
        
        let valid = isCompulsory && !isHidden ? (text.cleanedString().count > 0) : true
        
        if !valid {
            if validationMessage.count > 0 {
                SwiftMessages.showToast(validationMessage)
            } else {
                SwiftMessages.showToast("Please enter \(title.capitalized).")
            }
        }
        
        return valid
    }
    
    /**
     The attributedText of the `View` instance filed of textView.
     User can set  attributedText to textView
     
     
     */
    var attributedText: NSAttributedString? {
        
        get {
            return textView.attributedText
        }
        set(text) {
            textView.attributedText = text
            lblPlaceholder.isHidden = ((text?.length) != nil)
        }
    }
    
    
    // MARK: - Public Initializer
    convenience init(withTitle titleStr: String, isCompulsory compulsory: Bool = true, textLimit limit: Int = 500) {
        
        self.init(frame: .zero)
        
        title = titleStr
        isCompulsory = compulsory
        textLimit = limit
    }
    
    
    // MARK: - Setup
    fileprivate func setup() {
        
        view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
        textView.delegate = self
        
        updateRemainingCount(remainingChars: charactersLimit)
        
        changeBorderStyle()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: JMControls.TextViewNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
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
    override func becomeFirstResponder() -> Bool {
        self.textView.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        
        self.textView.resignFirstResponder()
        
        return super.resignFirstResponder()
    }
    
    override var intrinsicContentSize: CGSize {
        
        let heightOffset: CGFloat = showHeader ? 0.0:-JMControls.JMCustomHeaderDefaultHeight
        return CGSize(width: view.width, height: showCounterLabel ? JMControls.TextViewHeight+heightOffset:JMControls.TextViewHeightWithoutCounter+heightOffset)
    }
    
    
    // MARK: - Private Methods
    fileprivate func updateRemainingCount(remainingChars remChar: Int) {
        
        self.lblRemainingCount.text = "\(remChar) " + JMControls.TextViewCharLeftString
    }
    
    fileprivate func changeBorderStyle() {
        
        rightBorder.isHidden = !borderStyles.contains(.right)
        bottomBorder.isHidden = !borderStyles.contains(.bottom)
        leftBorder.isHidden = !borderStyles.contains(.left)
        
        viewHeader.borderStyles = borderStyles
    }
    
    
    // MARK: - Public Methods
    public func updateCounterOnNuanceChanges() {
        
        if self.text.count <= self.charactersLimit {
            
            let leftCount = self.charactersLimit - self.text.count
            
            updateRemainingCount(remainingChars: leftCount)
            
        } else {
            
            if self.text.count > self.charactersLimit {
                self.text = String(self.text[..<self.text.index(self.text.startIndex, offsetBy: (self.charactersLimit-1))])
            }
        }
    }
}



// MARK: - UITextViewDelegate
extension JMTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count <= self.charactersLimit {
            
            let leftCount = self.charactersLimit - updatedText.count
            
            updateRemainingCount(remainingChars: leftCount)
            
            return true
            
        } else {
            return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        updateRemainingCount(remainingChars: charactersLimit - text.count)
        
        self.delegate?.ccTextViewDidChange(self)
        
        textChangedCallback?()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.lblPlaceholder.isHidden = true
        
        self.delegate?.ccTextViewDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.lblPlaceholder.isHidden = text.count > 0
        
        self.delegate?.ccTextViewDidEndEditing(self)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        self.lblPlaceholder.isHidden = text.count > 0
        
        return true
    }
}

//
//  //This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries



import UIKit
import SwiftMessages


@IBDesignable class JMDatePicker: UIView {

    
    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var lblTitle: UILabel!
    @IBOutlet fileprivate weak var lblCompulsory: UILabel!
    @IBOutlet fileprivate weak var lblSelectedDate: UILabel!
    @IBOutlet fileprivate weak var btnCross: UIButton!
    @IBOutlet fileprivate weak var topBorder: UIImageView!
    @IBOutlet fileprivate weak var bottomBorder: UIImageView!
    @IBOutlet fileprivate weak var rightBorder: UIImageView!
    @IBOutlet fileprivate weak var leftBorder: UIImageView!
    
    
    // MARK: - Private Variables
    fileprivate var view: UIView!
    fileprivate var showCancelButton: Bool = true
    fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JMDatePicker.tapGestureRecognized(_:)))
    
    
    // MARK: - Public Properties
    public var borderStyles: JMBorderStyles = JMBorderStyles.default { didSet { changeBorderStyle() } }
    public var valueChangedCallback: (() -> Void)?
    /// Date() = user can select minimumDate from picker
    public var minimumDate: Date?
    /// Date() = user can select maximumDate from picker
    public var maximumDate: Date?
    /// user can select pickerType for picker
    public var pickerType: UIDatePicker.Mode = .date { didSet { setPlaceHolderLabel() } }
    /// user can select date or auto select date
    public var date: Date? { didSet { updateDatePickerLabel() } }
    
    
    // MARK: - IBInspectable Properties
    /**
     
     The perimeter of the `title` instance.
     User can set title at View file
     
     */
    
    @IBInspectable var title: String {
        
        get {
            return lblTitle.text ?? ""
        } set(newText) {
            lblTitle.text = newText
        }
    }
    
    /**
     
     The perimeter of the `isCompulsory` instance.
     User can set view as Compulsory.

     */
    
    @IBInspectable var isCompulsory: Bool {
        
        get {
            return !(lblCompulsory.isHidden)
        } set(newVal) {
            lblCompulsory.isHidden = !newVal
            changeCalendarImageIfNeeded()
        }
    }
    
    /**
     
     The perimeter of the `isEnable` instance.
     User can set view as isEnable or disable.
     
     */
    
    @IBInspectable var isEnable: Bool {
        
        get {
            return isUserInteractionEnabled
        }
        set(enabled) {
            isUserInteractionEnabled = enabled
            
            view.backgroundColor = enabled ? .white : JMControls.DisabledColor
            btnCross.alpha =  enabled ? 1.0:0.5
            lblSelectedDate.textColor = enabled ? (date != nil ? JMControls.NormalColor : JMControls.LightColor) : .gray
        }
    }
    
    /**
     
     The perimeter of the `shouldBeCancelable` instance.
     User can set view as shouldBeCancelable.
     
     
     */
    
    @IBInspectable var shouldBeCancelable: Bool {
        
        get {
            return showCancelButton
        } set(newVal) {
            showCancelButton = newVal
        }
    }
    
    
    // MARK: - Public Getters
    /**
     
     The perimeter of the `isValid` instance.
     
     - Returns: isCompulsory behaviour.
     
     */
    var isValid: Bool {
        
        let valid = isCompulsory && !isHidden ? date != nil:true
        
        if !valid {
            if validationMessage.count > 0 {
                SwiftMessages.showToast(validationMessage)
            } else {
                SwiftMessages.showToast("Please select \(title.capitalized).")
            }
        }
        
        return valid
    }
    
    /**
     
     This message will be displayed when validation failed.
     Default message will be shown if not set
     
     */
    @IBInspectable var validationMessage: String = ""
    
    
    /// Returns Date string suitable for backend API
    ///
    /// For .date -> yyyy-MM-dd
    open var dateStringForBackend: String {
        
        if pickerType == .date {
            return date != nil ? DateHelper.stringFromDate(date!, dateFormat: K.ServerDateFormat)! : ""
        } else if pickerType == .dateAndTime {
            return date != nil ? DateHelper.stringFromDate(date!, dateFormat: K.ServerDateTimeFormat)! : ""
        } else if pickerType == .time {
            return date != nil ? DateHelper.stringFromDate(date!, dateFormat: K.TimeFormatShort)! : ""
        } else {
            return ""
        }
    }
    
    
    // MARK: - Public Initializer
    convenience init(withTitle titleStr: String, isCompulsory compulsory: Bool = true, pickerType type: UIDatePicker.Mode = .date) {
        
        self.init(frame: .zero)
        
        title = titleStr
        isCompulsory = compulsory
        pickerType = type
    }
    
    
    // MARK: - Private Methods
    fileprivate func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        addGestureRecognizer(tapGestureRecognizer)
        
        changeBorderStyle()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: JMControls.DatePickerNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

    fileprivate func updateDatePickerLabel() {
        
        if date != nil {
            if let dateString = DateHelper.stringFromDate(date!, dateFormat: self.pickerType == .date ? K.ClientDateFormat: self.pickerType == .time ?K.TimeFormatShort2:K.ClientDateTimeFormat) {
                self.lblSelectedDate.text = dateString
            }
        }
        
        setPlaceHolderLabel()
        changeLabelsColorIfNeeded()
        changeCalendarImageIfNeeded()
    }
    
    fileprivate func setPlaceHolderLabel() {
        
        if date == nil {
            
            self.lblSelectedDate.text = self.pickerType == .date ? K.ClientDateFormat.uppercased():self.pickerType == .time ?K.TimeFormatShort2.uppercased():K.DateTimeFormatStandard3.uppercased()
        }
    }
    
    fileprivate func changeLabelsColorIfNeeded() {
        
        lblTitle.textColor = date != nil ? JMControls.LightColor : JMControls.NormalColor
        lblSelectedDate.textColor = date != nil ? JMControls.NormalColor : JMControls.LightColor
    }
    
    fileprivate func changeCalendarImageIfNeeded() {
        
        if date != nil && !isCompulsory {
            btnCross.setImage(UIImage(named: JMControls.CrossIconName), for: .normal)
        } else {
            btnCross.setImage(UIImage(named: JMControls.CalendarIconName), for: .normal)
        }
    }
    
    fileprivate func changeBorderStyle() {
        
        rightBorder.isHidden = !borderStyles.contains(.right)
        bottomBorder.isHidden = !borderStyles.contains(.bottom)
        leftBorder.isHidden = !borderStyles.contains(.left)
        topBorder.isHidden = !borderStyles.contains(.top)
    }
    
    fileprivate func showDatePickerAlertView() {
        
        UIAlertController.showDatePicker(mode: self.pickerType, title: self.title, message: nil, date: date, minimumDate: minimumDate, maximumDate: maximumDate, callBackWhenValueChanged: !showCancelButton) { [unowned self] (date: Date) in
            
            let dateChanged = date != self.date
            
            if dateChanged {
                
                self.date = date
                self.valueChangedCallback?()
            }
        }
    }
    
    
    // MARK: - Events
    @objc fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        
        showDatePickerAlertView()
    }
    
    @IBAction fileprivate func btnCrossClicked(_ sender: UIButton) {
        
        if date != nil && !isCompulsory {
            date = nil
            valueChangedCallback?()
        } else {
            showDatePickerAlertView()
        }
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
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: view.width, height: JMControls.DatePickerHeight)
    }
}

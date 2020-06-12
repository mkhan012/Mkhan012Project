//
// This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit
import SwiftMessages


@IBDesignable class JMStringPicker: UIView {

    
    // MARK: - IBOutlet
    @IBOutlet fileprivate weak var viewHeader: JMCustomHeader!
    @IBOutlet fileprivate weak var stackSelectedItems: UIStackView!
    @IBOutlet fileprivate weak var lblPlaceholder: UILabel!
    @IBOutlet fileprivate weak var viewPlaceholder: UIView!
    @IBOutlet fileprivate weak var bottomBorder: UIImageView!
    @IBOutlet fileprivate weak var rightBorder: UIImageView!
    @IBOutlet fileprivate weak var leftBorder: UIImageView!

    
    // MARK: - Private Variables
    fileprivate var view: UIView!
    fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JMStringPicker.tapGestureRecognized(_:)))
    
    
    // MARK: - Public Properties
    /// user can select borderStyles
    public var borderStyles: JMBorderStyles = JMBorderStyles.default { didSet { changeBorderStyle() } }
    
    /// user can select selectionType
    public var selectionType: Picker.Selection = .single { didSet { showHideAddMoreButton() } }
    
    /// user can select data for data Array
    public var data: [JMGeneralModel] = []
    
    /// user selectedData
    public var selectedData: [JMGeneralModel] = [] { didSet { updateOnSelectedString() } }
    public var valueChangedCallback: (() -> Void)?
    
    /// maximum number of selection limit, only works in multi mode
    public var maximumSelectionLimit: Int = Int.max
    
    //Need to rename
    public var headerButtonCallBack: (() -> Void)? { didSet { viewHeader.isHeaderButtonHidden = false ; invalidateIntrinsicContentSize()} }
    
    /// This will be used when user wants to show custom alertview or to show some other view controller when user taps on picker
    /// Currently it will only work in case of single selection.
    public var userTapCallBack: (() -> Void)? = nil
    
    
    // MARK: - IBInspectable Properties
    /**
     The title of the `View` instance.
     User can set view  title
     
     */
    @IBInspectable var title: String {
        
        get {
            return viewHeader.title
        } set(newText) {
            viewHeader.title = shouldCapitalizedText ? newText.uppercased() : newText
        }
    }
    
    /**
     The isCompulsory of the `View` instance.
     User can set view as Compulsory
     
     */
    @IBInspectable var isCompulsory: Bool {
        
        get {
            return viewHeader.isCompulsory
        } set(newVal) {
            viewHeader.isCompulsory = newVal
        }
    }
    
    /**
     The fontPointSize of the `View` instance.
     User can set fontsize or default
     
     */
    @IBInspectable var fontPointSize: CGFloat = 14.0
    
    /**
     The placeholder of the `View` instance.
     User can set view placeholder
     
     */
    @IBInspectable var placeholder: String {
        
        get {
            return lblPlaceholder.text ?? ""
        } set(newText) {
            lblPlaceholder.text = newText
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
            view.backgroundColor = enabled ? .white : JMControls.DisabledColor
            viewPlaceholder.backgroundColor = enabled ? .white : JMControls.DisabledColor
            viewHeader.isEnable = enabled
            
            stackSelectedItems.arrangedSubviews.forEach({ ($0 as? JMGeneralView)?.isEnable = enabled })
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
     
     The parameter of the `buttonImage` instance.
     User can set buttonImage Image.
     
     */
    
    @IBInspectable var shouldCapitalizedText: Bool = true {
        
        didSet {
            viewHeader.shouldCapitalizedText = shouldCapitalizedText
        }
    }
    
    
    // MARK: - Public Getters
    /// Get is picker data valid
    var isValid: Bool {
        
        let valid = isCompulsory && !isHidden ? selectedId.count > 0:true
        
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
    
    
     /// Get selected Items Ids Array
    open var selectedIds: [String] {
        
        if selectedData.count > 0 {
            return selectedData.map({ $0.id })
        } else {
            return [""]
        }
    }
    
    /// Get selected Items Titles Array
    open var selectedTitles: [String] {
        
        if selectedData.count > 0 {
            return selectedData.map({ $0.title })
        } else {
            return [""]
        }
    }
    
    //comma-separated ids to comma-separated values
    open var commaSeparatedIds :String {
        return selectedIds.joined(separator:",")
    }
    
    /// Get selected Item Id
    open var selectedId: String {
        
        return selectedIds.first ?? ""
    }
    
    /// Get selected Item Title
    open var selectedTitle: String {
        
        return selectedTitles.first ?? ""
    }
    
    open var sectionIndexEnable:Bool = false
    
    
    // MARK: - Public Initializer
    convenience init(withTitle titleStr: String, isCompulsory compulsory: Bool = true, selectionType type: Picker.Selection = .single, maximumSelectionLimit limit: Int = Int.max) {
        
        self.init(frame: .zero)
        
        title = titleStr
        isCompulsory = compulsory
        selectionType = type
        maximumSelectionLimit = limit
    }
    
    public func selectFirst() {
        if self.data.count > 0 {
            self.selectedData = [(self.data.first!)]
        }
    }
    
    
    
    // MARK: - Private Methods
    fileprivate func changeBorderStyle() {
        
        rightBorder.isHidden = !borderStyles.contains(.right)
        bottomBorder.isHidden = !borderStyles.contains(.bottom)
        leftBorder.isHidden = !borderStyles.contains(.left)
        
        viewHeader.borderStyles = borderStyles
    }
    
    /**
     show  showHideAddMoreButton at current View.
     */
    fileprivate func showHideAddMoreButton() {
        
        if self.headerButtonCallBack != nil && selectionType == .single {
            viewHeader.isHeaderButtonHidden = false
        } else {
            viewHeader.isHeaderButtonHidden = !(selectionType == .multi && selectedData.count > 0)
        }
    }
    
    fileprivate func updateOnSelectedString() {
        
        stackSelectedItems.removeAllArrangedViews()
        
        for  data in selectedData {
            
            let viewSelected = JMGeneralView.setupView(forItem: data, hideSeparator: selectedData.last == data)
            viewSelected.lblTitle.font = UIFont.robotoRegular(K.IS_IPAD ? fontPointSize + 2.0 : fontPointSize)
            viewSelected.isEnable = isEnable
            viewSelected.deletedItemHandler = { [weak self] (item : JMGeneralModel) in
                self?.selectedData.removeAll{$0.id == item.id}
                self?.valueChangedCallback?()
            }
            
            stackSelectedItems.addArrangedSubview(viewSelected)
        }
        
        updateSubViewesAndTheirSizes()
        showHidePlaceholderView()
        showHideAddMoreButton()
    }
    
    fileprivate func showHidePlaceholderView() {
        
        viewPlaceholder.isHidden = selectedData.count != 0
        
        if viewPlaceholder.isHidden && (selectionType == .single || selectionType == .visitReason) {
            viewPlaceholder.removeGestureRecognizer(tapGestureRecognizer)
            stackSelectedItems.arrangedSubviews.first!.addGestureRecognizer(tapGestureRecognizer)
        } else {
            viewPlaceholder.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    fileprivate func updateSubViewesAndTheirSizes() {
        
        stackSelectedItems.layoutIfNeeded()
        
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func showAlertPickerView() {
        
        var editText = ""
        
        if let obj = selectedData.first {
            editText = obj.title
        }
        
        UIAlertController.showStringPicker(stringValues: data, selected: selectedData, editText: editText , sectionIndexEnable:sectionIndexEnable, type:self.selectionType, maximumSelectionLimit: self.maximumSelectionLimit, selection: { [unowned self] (items: [JMGeneralModel]) in
            self.selectedData = items
            self.valueChangedCallback?()
        })
    }
    
    fileprivate func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        
        stackSelectedItems.removeAllArrangedViews()
        
        viewPlaceholder.addGestureRecognizer(tapGestureRecognizer)
        
        viewHeader.headerButtonCallBack = { [unowned self] in
            
            if self.headerButtonCallBack != nil && self.selectionType == .single {
                self.headerButtonCallBack?()
            } else if self.selectionType == .multi {
                self.showAlertPickerView()
            }
        }
        
        changeBorderStyle()
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: JMControls.StringPickerNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    // MARK: - Events
    @objc fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        
        if userTapCallBack == nil { showAlertPickerView() }
        else { userTapCallBack?() }
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
        
        if let stackView = stackSelectedItems, stackView.arrangedSubviews.count > 0 {
            let height = CGFloat(stackSelectedItems.arrangedSubviews.map({$0.height}).reduce(0, +) + JMControls.JMCustomHeaderDefaultHeight)
            return CGSize(width: view.width, height: showHeader ? height:height - JMControls.JMCustomHeaderDefaultHeight)
        } else {
            return CGSize(width: view.width, height: showHeader ? JMControls.StringPickerDefaultHeight:JMControls.StringPickerDefaultHeight - JMControls.JMCustomHeaderDefaultHeight)
        }
    }
}

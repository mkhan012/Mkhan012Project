//
//This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries

import Foundation
import UIKit



class JMGeneralView: UIView {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgSeparator: UIImageView!
    
    
    // MARK: - Public Variables
    /// item is  JMGeneralModel for User information.
    public var item: JMGeneralModel!
    /**
     Callback deletedItemHandler for refresh view after any change.
     
     - Parameter item: The Provider instance for information
     
     - Returns: A delete information in the form  of item  instance of JMGeneralModel.
     */
    public var deletedItemHandler: ((_ item: JMGeneralModel) -> Void)?
    
    
    // MARK: - Action
    @IBAction func btnDeleteClicked(_ sender: UIButton) {
        
        deletedItemHandler?(item)
    }
    
    
    // MARK: - Public Methods
    
    /**
     Creates and setupView view for JMGeneralView information
     
     - Parameter item: JMGeneralModel .
     - Parameter hideSeparator: Bool .
     
     Get new View from Nib after Initializes assign to a view and set property of instance of view.
     
     - Returns: A new view of  `JMGeneralView`.
     */
    
    open class func setupView(forItem item: JMGeneralModel, hideSeparator: Bool = false) -> JMGeneralView {
        
        let view = Bundle.main.loadNibNamed(JMControls.JMGeneralViewNibName, owner: self, options: nil)!.last as! JMGeneralView
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.item = item
        view.lblTitle.text = item.title
        view.lblTitle.textColor = JMControls.NormalColor
        view.imgSeparator.isHidden = hideSeparator
        
        return view
    }
    
    /**
     setupHeightConstraint for Current view.
     
     Get  View and set heightAnchor constraint
     
     */
    open func setupHeightConstraint() {
        
        let heightConstant = self.lblTitle.text!.boundingRect(with: CGSize(width: self.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font : self.lblTitle.font!], context: nil).height
        
        self.heightAnchor.constraint(equalToConstant: heightConstant + 30 ).isActive = true
    }
    
    /**
     The isEnable of the `View` instance.
     
     Computation depends on the View of the instance, and is
     equivalent to:
     View is Enable and disable on the base of this param.
     ```
     */
    open var isEnable: Bool {
        
        get {
            return isUserInteractionEnabled
        }
        set(enabled) {
            isUserInteractionEnabled = enabled
            backgroundColor = enabled ? .white : JMControls.DisabledColor
            lblTitle.textColor = enabled ? JMControls.DarkTextColor : .gray
            btnDelete.alpha =  enabled ? 1.0:0.5
            btnDelete.isHidden = !enabled
        }
    }
    
    #if !TARGET_INTERFACE_BUILDER
    override func didMoveToSuperview() {
        
        setupHeightConstraint()
    }
    #endif
}

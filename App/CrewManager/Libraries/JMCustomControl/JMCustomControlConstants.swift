//
//  //This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit

/**

 JMControls is provider constans values to all pickerviews.

 */

class JMControls {
    
    /// Get PickerView TextView Nib Name.
    static let TextViewNibName: String = String(describing: JMTextView.self)
    
    /// Get PickerView TextView Hight.
    static let TextViewHeight: CGFloat = K.IS_IPAD ? 160.0:140.0
    
    /// Get PickerView TextView Hight WithoutCounter.
    static let TextViewHeightWithoutCounter: CGFloat  = K.IS_IPAD ? 136.0: 116.0
    
    /// Get PickerView TextView  CharLeftString.
    static let TextViewCharLeftString = "characters left"
    
    /// Get PickerView TextField Nib Name.
    static let TextFieldNibName = String(describing: JMTextField.self)
    
    /// Get PickerView TextField Nib Height.
    static let TextFieldHeight: CGFloat = K.IS_IPAD ? 90.0: 70.0
    
    /// Get PickerView NormalColor.
    static let NormalColor: UIColor = UIColor.init(hexString: "505050")
    
    /// Get PickerView LightColor.
    static let LightColor: UIColor = UIColor.init(hexString: "8F8E94")
    
    /// Get PickerView DisabledColor.
    static let DisabledColor: UIColor = UIColor.init(hexString: "E6E6E6")
    
    /// Get PickerView DarkTextColor.
    static let DarkTextColor: UIColor = UIColor.init(hexString: "030303")
    
    /// Get PickerView NumbersOnlyString for TextFields.
    static let NumbersOnlyString = "0123456789"
    
    /// Get PickerView DecimalOnlyString for TextFields.
    static let DecimalsOnlyString = "0123456789."
    
    /// Get PickerView FaxAllowedChars for TextFields.
    static let FaxAllowedChars = "0123456789-() "
    
    /// Get PickerView Date Picker Nib Name.
    static let DatePickerNibName = String(describing: JMDatePicker.self)
    
    /// Get PickerView Date Picker Nib Height.
    static let DatePickerHeight: CGFloat = K.IS_IPAD ? 90.0: 70.0
    
    /// Get PickerView Date Picker Calendar Icon Name.
    static let CalendarIconName: String = "calendar_icon"
    
    /// Get PickerView Date Picker Cross Icon Name.
    static let CrossIconName: String = "cross_icon"
    
    /// Get PickerView Date Picker Add Icon Name.
    static let AddIconName: String = "add_icon"
    
    /// Get PickerView Date Picker StringPickerNibName.
    static let StringPickerNibName = String(describing: JMStringPicker.self)
    
    /// Get PickerView Date Picker String Picker Nib Default Hight
    static let StringPickerDefaultHeight: CGFloat = K.IS_IPAD ? 86.0: 66.0
    
    /// Get PickerView Date Picker String Picker Header Hight.
    static let StringPickerHeaderHeight: CGFloat = K.IS_IPAD ? 32.0: 22.0
    
    /// Get PickerView JMGeneralView Nib Name.
    static let JMGeneralViewNibName = String(describing: JMGeneralView.self)
    
    static let JMCustomHeaderNibName = String(describing: JMCustomHeader.self)
    /// Get PickerView DarkTextColor.
    static let JMCustomHeaderBackgroundColor: UIColor = UIColor.init(hexString: "EFEFF5")
    static let JMCustomHeaderTextColor: UIColor = UIColor.init(hexString: "7C7C82")
    
    static let JMCustomHeaderButtonColor: UIColor = UIColor.init(hexString: "666666")
    
    /// Get PickerView  JMCustom Header Height
    static let JMCustomHeaderDefaultHeight: CGFloat = 22.0
    
    /// Get Expanded Icon Name.
    static let ExpandedIconName: String = "expanded_icon"
    
    /// Get Collapsed Icon Name.
    static let CollapsedIconName: String = "collapsed_icon"
    
    static let JMPickerViewInitialMessage = "Please enter minimum 3 characters to search"
    static let JMPickerViewNoDataMessage = "No results found against your search"
    
}

/// A Picker Boardeer stypes .
struct JMBorderStyles: OptionSet {
    
    /// Picker JMBorderStyles style rawValue.
    public let rawValue: Int
    
    /// Picker JMBorderStyles style top.
    static let top = JMBorderStyles(rawValue: 1 << 0)
    
    /// Picker JMBorderStyles style bottom.
    static let bottom = JMBorderStyles(rawValue: 1 << 1)
    
    /// Picker JMBorderStyles style right.
    static let right = JMBorderStyles(rawValue: 1 << 2)
    
    /// Picker JMBorderStyles style left.
    static let left = JMBorderStyles(rawValue: 1 << 3)
    
    /// Picker JMBorderStyles style [.bottom].
    static let `default`: JMBorderStyles = [.bottom]
    
    /// Picker JMBorderStyles style [].
    static let none: JMBorderStyles = []
    
    /// Picker JMBorderStyles style [.bottom, .right].
    static let rightBorder: JMBorderStyles = [.bottom, .right]
    
    /// Picker JMBorderStyles style allBorder = [.bottom, .right, .left, .top].
    static let allBorder: JMBorderStyles = [.bottom, .right, .left, .top]
}

///  A Picker Types for differnt kinds on functionalities.
public enum Picker {
    
    /// Picker and Selection style/Type.
    enum Selection {
        case none
        /// Picker and Selection Type is single.
        case single
       
        /// Picker and Selection Type is multi.
        case multi
        
        /// Picker and Selection Type is Visit reason.
        case visitReason
    }
    
    
     /// Picker and Selection style/Type for Provider.
    enum Provider {
        
        /// Picker and Selection Type for Provider is `default`.
        case `default`
        
        /// Picker and Selection Type for Provider is local.
        case local
        
        /// Picker and Selection Type for Provider is external.
        case external
        
        /// Picker and Selection Type for Provider is practice. This is also known as internal.
        case practice
        
        /// Picker and Selection Type for Nurse Role.
        case nurse
        
        /// Picker and Selection Type for Rendering Role.
        case rendering
    }
    
    
    /// Picker and Selection style/Type for Patient.
    enum Patient {
        
        /// Picker and Selection Type for Patient is `default`.
        case `default`
        
        /// Picker and Selection Type for Patient is `local`.
        case local
        
        /// Picker and Selection Type for Patient is `practice`.
        case practice
    }
    
    /// Picker and Selection style/Type for Location.
    enum Location {
        
        /// Picker and Selection Type for Location is `default`.
        case `default`
        
        /// Picker and Selection Type for Location is `local`.
        case local
        
        /// Picker and Selection Type for Location is `practice`.
        case practice
    }
}

///  A JMTextField Types for differnt kinds on functionalities.
public enum JMTextFieldType {
    
    ///  A JMTextField Types is numbersOnly for numerics
    case numbersOnly
    
    ///  A JMTextField Types is alphaNumeric for alphaNumeric Characters
    case alphaNumeric
    
    ///  A JMTextField Types is fax number
    case faxNumber
    
    ///  A JMTextField Types is email
    case email
    
    /// A JMTextField Types is Decimal
    case numbersWithDecimal
}


/**
 The  JMGeneralModel base class of most swift class hierarchies, from which subclasses inherit a basic interface to the runtime system and the ability to behave as Objective-C objects.
 
 - Parameters:
 - title: String = title
 - id: String = id
 */

public class JMGeneralModel: NSObject {
    
    /// The title of the JMGeneralModel.
    var title: String!
    
    /// The id of the JMGeneralModel.
    var id: String!
    
    /// This will be showing in red color, user can't select it.
    var isRed: Bool = false
    
    /**
     Initializes a new bicycle with the provided parts and specifications.
     
     - Parameters:
        - title : The title of the JMGeneralModel
        - id : The id of the JMGeneralModel
     
     - Returns: A beautiful, brand-new JMPatientModel, custom-built just for you.
     
     */
    public init(title: String, id: String? = nil) {
        
        self.title = title
        self.id = id != nil ? id:title
    }
    
    public init(title: String, id: String, isRed: Bool = false) {
        
        self.title = title
        self.id = id
        self.isRed = isRed
    }
    
    @objc public func getTitleForObjcPatch() -> String {
        return self.title
    }
    
    static func ==(lhs: JMGeneralModel, rhs: JMGeneralModel) -> Bool {
        return lhs.id == rhs.id
    }
}

//
//  //This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit

extension UIAlertController {
    
    /**
     Show string picker controller.
     
     User can search string and select from them
     
     - Parameters:
     - selectedValues: Show selected values with tick mark
     - isMultiSelect: Should select more than one value
     - selection: Return block and it's data type
     */
    class func showStringPicker(stringValues values: [JMGeneralModel], selected: [JMGeneralModel], editText: String = "", sectionIndexEnable: Bool = false, type: Picker.Selection = .single, maximumSelectionLimit limit: Int = Int.max, selection: @escaping StringPickerAlertViewController.Selection) {
        
        let alert = UIAlertController(style: .actionSheet)
        
        alert.addStringPicker(stringValues: values, selected: selected, editText:editText , sectionIndexEnable: sectionIndexEnable, type: type, maximumSelectionLimit: limit, selection: selection)
        alert.addAction(title: "Cancel", style: .cancel)
        
        alert.show()
    }
    
    
    
    // MARK: - Private Methods
    fileprivate func addStringPicker(stringValues values: [JMGeneralModel], selected: [JMGeneralModel], editText: String = "", sectionIndexEnable: Bool, type: Picker.Selection = .single, maximumSelectionLimit limit: Int, selection: @escaping StringPickerAlertViewController.Selection) {
        
        let vc = R.StoryboardRef.JMPickerStoryboard.instantiateViewController(withIdentifier: StringPickerAlertViewController.identifier) as! StringPickerAlertViewController
        
        vc.sectionIndexEnable = sectionIndexEnable
        vc.stringData = values
        vc.selectedStrings = selected
        vc.selectionType = type
        vc.maximumSelectionLimit = limit
        
        vc.selection = { [unowned self] (strings: [JMGeneralModel]) in
            
            self.dismiss(animated: true, completion: {
                selection(strings)
            })
        }
        
        if type == .visitReason {
            
            vc.selectionType = type
            vc.editText = editText
            
            var textString = ""
            
            vc.externalText = { (text:String) in
                textString = text
            }
            
            self.addAction(title: "Done", style: .default) { action in
                if textString.count > 0 {
                    selection([JMGeneralModel(title: textString)])
                }
            }
        }
        
        if type == .multi {
            
            addAction(title: "Done", style: .default) { action in selection(vc.selectedStrings) }
        }
        
        set(vc: vc)
    }
}

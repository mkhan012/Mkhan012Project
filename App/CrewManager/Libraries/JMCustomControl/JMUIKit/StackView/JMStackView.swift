//
//  //This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit

class JMStackView: UIStackView {

    convenience init(subviews views: [UIView] = [], axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .center, spacing: CGFloat = 0.0, layoutMargin: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets()) {
        
        self.init(arrangedSubviews: views)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        
        if layoutMargin.top > 0 || layoutMargin.bottom > 0 || layoutMargin.trailing > 0 || layoutMargin.leading > 0 {
            
            isLayoutMarginsRelativeArrangement = true
            directionalLayoutMargins = layoutMargin
        }
    }
    
    convenience init(forHorizontalControls views: [UIView], fillEqually: Bool = true, layoutMargin: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets()) {
        
        self.init(arrangedSubviews: views)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.axis = .horizontal
        self.distribution = fillEqually ? .fillEqually:.fill
        self.alignment = fillEqually ? .fill:.center
        self.spacing = 0.0
        
        if layoutMargin.top > 0 || layoutMargin.bottom > 0 || layoutMargin.trailing > 0 || layoutMargin.leading > 0 {
            
            isLayoutMarginsRelativeArrangement = true
            directionalLayoutMargins = layoutMargin
        }
        
        for view in views {
            
            if let txt = view as? JMTextView {
                txt.borderStyles = .rightBorder
            } else if let txt = view as? JMTextField {
                txt.borderStyles = .rightBorder
            } else if let picker = view as? JMStringPicker {
                picker.borderStyles = .rightBorder
            } else if let picker = view as? JMDatePicker {
                picker.borderStyles = .rightBorder
            }
        }
    }
    
    convenience init(forPaddedView view: UIView) {
        
        self.init(arrangedSubviews: [view])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.alignment = .fill
        self.spacing = 8.0
        
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0)
    }
    
    convenience init(forVerticalTitleAndControlViews views: [UIView], shouldAddTopLeftRightSpace shouldAddSpace: Bool = true) {
        
        self.init(subviews: views)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.alignment = .fill
        self.spacing = 8.0
        
        if shouldAddSpace {
            
            isLayoutMarginsRelativeArrangement = true
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        }
    }
}

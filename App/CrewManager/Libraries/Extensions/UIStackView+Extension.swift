//
//This is not my code, i took this from git hub link below
//  https://github.com/muhammadrizwananjum/HelpingLibraries
//


import UIKit


// MARK: - UIStackView
extension UIStackView {
    
    func removeAllArrangedViews(except v: UIView? = nil) {

        for view in self.arrangedSubviews {
            if v != nil {
                if view != v! {
                    view.removeFromSuperview()
                }
            } else {
                view.removeFromSuperview()
            }
        }
    }
    
    func addArrangedSubviews(_ views:[UIView]) {
        
        for view in views { self.addArrangedSubview(view) }
    }
    
    func addBackground(color: UIColor) {
        
        let subView = UIView(frame: bounds)
        
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        insertSubview(subView, at: 0)
    }
}

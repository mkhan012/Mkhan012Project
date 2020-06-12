
//This is not my code, i took this from git hub link below
//https://github.com/muhammadrizwananjum/HelpingLibraries


import UIKit
import Foundation

// MARK: - Designable Extension

@IBDesignable
extension UIView {
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}


// MARK: - Properties

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }
    
}


// MARK: - Methods

public extension UIView {
    
    typealias Configuration = (UIView) -> Swift.Void
    
    func config(configurate: Configuration?) {
        configurate?(self)
    }
    
    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIView {
    
    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }
    
    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

extension UIView {
    
    func addConstraint(attribute: NSLayoutConstraint.Attribute, equalTo view: UIView, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let myConstraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: toAttribute, multiplier: multiplier, constant: constant)
        return myConstraint
    }
    
    func addConstraints(withFormat format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addConstraints(withFormat format: String, arrayOf views: [UIView]) {
        
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func removeAllConstraints() {
        removeConstraints(constraints)
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    @discardableResult
    public func left(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func left(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func right(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func right(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: view.rightAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func top(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func top(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topLeft(toView view: UIView, top: CGFloat = 0, left: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let topConstraint = self.top(toView: view, space: top)
        let leftConstraint = self.left(toView: view, space: left)
        
        return [topConstraint, leftConstraint]
    }
    
    @discardableResult
    public func topRight(toView view: UIView, top: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let topConstraint = self.top(toView: view, space: top)
        let rightConstraint = self.right(toView: view, space: right)
        
        return [topConstraint, rightConstraint]
    }
    
    @discardableResult
    public func bottomRight(toView view: UIView, bottom: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottom(toView: view, space: bottom)
        let rightConstraint = self.right(toView: view, space: right)
        
        return [bottomConstraint, rightConstraint]
    }
    
    @discardableResult
    public func bottomLeft(toView view: UIView, bottom: CGFloat = 0, left: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottom(toView: view, space: bottom)
        let leftConstraint = self.left(toView: view, space: left)
        
        return [bottomConstraint, leftConstraint]
    }
    
    @discardableResult
    public func bottom(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottom(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func verticalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func horizontalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = rightAnchor.constraint(equalTo: view.leftAnchor, constant: -space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func leftHorizontalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = leftAnchor.constraint(equalTo: view.rightAnchor, constant: -space)
        constraint.isActive = true
        return constraint
    }
    
    
    
    public func size(_ size: CGSize) {
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
    }
    
    public func size(toView view: UIView, greater: CGFloat = 0) {
        widthAnchor.constraint(equalTo: view.widthAnchor, constant: greater).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, constant: greater).isActive = true
    }
    
    public func square(edge: CGFloat) {
        
        size(CGSize(width: edge, height: edge))
    }
    
    public func square() {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1, constant: 0).isActive = true
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func width(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    
    @discardableResult
    public func width(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    public func center(toView view: UIView, space: CGFloat = 0){
        centerX(toView: view, space: space)
        centerY(toView: view, space: space)
    }
    
    @discardableResult
    public func centerY(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerY(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    
    public func horizontal(toView view: UIView, space: CGFloat = 0) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: space).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -space).isActive = true
    }
    
    public func horizontal(toView view: UIView, leftPadding: CGFloat, rightPadding: CGFloat) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftPadding).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightPadding).isActive = true
    }
    
    public func vertical(toView view: UIView, space: CGFloat = 0) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space).isActive = true
    }
    
    public func vertical(toView view: UIView, topPadding: CGFloat, bottomPadding: CGFloat) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
    }
    
    
    public func fill(toView view: UIView, space: UIEdgeInsets = .zero) {
        
        left(toView: view, space: space.left)
        right(toView: view, space: -space.right)
        top(toView: view, space: space.top)
        bottom(toView: view, space: -space.bottom)
    }
    
    
    func lock() {
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(style: .white)
            activity.hidesWhenStopped = true
            activity.center = lockView.center
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 1.0
            })
        }
    }
    
    func unlock() {
        if let lockView = viewWithTag(10) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.0
            }, completion: { finished in
                lockView.removeFromSuperview()
            })
        }
    }
    
    func fadeOut(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    func fadeIn(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    class func viewFromNibName(_ name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views?.first as? UIView
    }
}

extension UIEdgeInsets {
    
    init(space: CGFloat) {
        self.init(top: space, left: space, bottom: space, right: space)
    }
}

public extension UIView {
    
    /// Size of view.
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    /// Width of view.
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// Height of view.
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

extension UIView {
    
    func addConstraintsWRTSuperViewEdges(withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: superView.topAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsWRTSuperViewCenters() {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
    }
    
    func addConstraintsWRTSuperViewBottomRigthEdges(withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsWRTSuperViewTopRightLeftEdges(withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: superView.topAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsWRTSuperViewTopLeftEdges(withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: superView.topAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
    }
    
    func addConstraintsWRTSuperViewRightLeftBottomEdges(withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsWRTSuperViewRightLeftEdges(withTopView top: UIView, withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: top.bottomAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsWRTSuperViewRightLeftBottomEdges(withTopView top: UIView, withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: top.bottomAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsWRTSuperViewRightLeftTopEdges(withBottomView bottom: UIView, withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: superView.topAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: bottom.topAnchor, constant: -space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
    }
    
    func addConstraint(withTopView topView: UIView, withPadding space: CGFloat = 0.0) {

        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: topView.bottomAnchor, constant: space).isActive = true
    }
    
    func addConstraint(withBottomView view: UIView, withPadding space: CGFloat = 0.0) {

        translatesAutoresizingMaskIntoConstraints = false
        
        bottomAnchor.constraint(equalTo: view.topAnchor, constant: -space).isActive = true
    }
    
    func addWidthConstraintWRTSuperView(withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalTo: superView.widthAnchor, multiplier: 1.0, constant: space).isActive = true
    }
    
    func addConstraintsForContainerStackViewInScrollView() {
        
        addConstraintsWRTSuperViewEdges()
        addWidthConstraintWRTSuperView()
    }
    
    func addConstraintsForScrollViewWRTSuperView(withTopView top: UIView, bottomView bottom: UIView, withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: top.bottomAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
        bottomAnchor.constraint(equalTo: bottom.topAnchor, constant: -space).isActive = true
        
        addWidthConstraintWRTSuperView()
    }
    
    func addConstraintsLeftRightWRTSuperView(withTopView top: UIView, bottomView bottom: UIView, withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: top.bottomAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
        bottomAnchor.constraint(equalTo: bottom.topAnchor, constant: -space).isActive = true
    }
    
    func addConstraintsForScrollViewWRTSuperView(withTopView top: UIView, withPadding space: CGFloat = 0.0) {
        
        guard let superView = superview else { print("\n\n\nError: Constraints can't apply due to super view is nill"); return; }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: top.bottomAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -space).isActive = true
        
        addWidthConstraintWRTSuperView()
    }
    
    func addConstraints(withTopView top: UIView, leftView left: UIView, rightView right: UIView, bottomView bottom: UIView, withPadding space: CGFloat = 0.0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        topAnchor.constraint(equalTo: top.bottomAnchor, constant: space).isActive = true
        leadingAnchor.constraint(equalTo: left.leadingAnchor, constant: space).isActive = true
        trailingAnchor.constraint(equalTo: right.trailingAnchor, constant: -space).isActive = true
        bottomAnchor.constraint(equalTo: bottom.topAnchor, constant: -space).isActive = true
    }
    
    @discardableResult
    func addWidthConstraint(width constant: CGFloat) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func addHeightConstraint(height constant: CGFloat) -> NSLayoutConstraint {

        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        
        return constraint
    }
}

public var screenWidth: CGFloat {
     return UIScreen.main.bounds.width
 }
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

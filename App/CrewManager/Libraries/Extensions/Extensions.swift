

//This is not my code, i took this from git hub link below
//http://git.addrenaline.nl/wouter/alerts-and-pickers/tree/master/Source/Extensions

import UIKit
import Foundation
import CoreFoundation
import SwiftMessages
import MobileCoreServices
import Material
import IQKeyboardManagerSwift


//MARK:- Int Extension
extension Int {
    var isEven:Bool     {return (self % 2 == 0)}
    var isOdd:Bool      {return (self % 2 != 0)}
    var isPositive:Bool {return (self >= 0)}
    var isNegative:Bool {return (self < 0)}
    var toDouble:Double {return Double(self)}
    var toFloat:Float   {return Float(self)}
    
    var digits:Int {
        if(self == 0) {
            return 1
        } else if(Int(fabs(Double(self))) <= LONG_MAX) {
            return Int(log10(fabs(Double(self)))) + 1
        }
    }
    
    func toRomanNumerals(_ number: Int) -> String? {
        guard number > 0 else {
            return nil
        }
        
        var remainder = number
        
        let values = [("M", 1000), ("CM", 900), ("D", 500), ("CD", 400), ("C",100), ("XC", 90), ("L",50), ("XL",40), ("X",10), ("IX", 9), ("V",5),("IV",4), ("I",1)]
        
        var result = ""
        
        for (romanChar, arabicValue) in values {
            let count = remainder / arabicValue
            
            if count == 0 { continue }
            
            for _ in 1...count
            {
                result += romanChar
                remainder -= arabicValue
            }
        }
        
        return result
    }
    
    func ccmMinutesLeftString() -> String {
        
        if self <= 0 {
            return "0 minutes"
        }
        
        let minutes: Int = self / 60
        let seconds: Int = self % 60
        
        return "\(minutes) min \(seconds) secs"
    }
    
    func ccmConsumedSecondProgress() -> CGFloat {
        
        if self <= 0 {
            return 0
        }
        
        let totalSeconds: CGFloat = 20 * 60
        
        return CGFloat(self)/totalSeconds
    }
    func numberOfDigits() -> Int {
        if abs(self) < 10 {
            return 1
        } else {
            return 1 + (self/10).numberOfDigits()
        }
    }
    
    func getDigits() -> [Int] {
        let num = self.numberOfDigits()
        var tempNumber = self
        var digitList = [Int]()
        
        for i in (0...num-1).reversed() {
            let divider = Int(pow(CGFloat(10), CGFloat(i)))
            let digit = tempNumber/divider
            digitList.append(digit)
            tempNumber -= digit*divider
        }
        return digitList
    }
}


//MARK:- Double Extension
extension Double {
    func roundToDecimalDigits(_ decimals:Int) -> Double {
        
        let format : NumberFormatter = NumberFormatter()
        format.numberStyle = NumberFormatter.Style.decimal
        format.roundingMode = NumberFormatter.RoundingMode.halfUp
        format.maximumFractionDigits = 2
        let string: NSString = format.string(from: NSNumber(value: self as Double))! as NSString
        //        print(string.doubleValue)
        return string.doubleValue
    }
}


//MARK:- Sequence Extension
extension Sequence {
    
    func splitBefore(
        
        separator isSeparator: (Iterator.Element) throws -> Bool
        ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            }
            else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}


//MARK:- Character Extension
extension Character {
    var isUpperCase: Bool { return String(self) == String(self).uppercased() }
}

enum BoolString: String {
    case TrueString = "1"
    case FalseString = "0"
}

extension Bool {
    
    func string() -> String {
        if self == true {
            return BoolString.TrueString.rawValue
        } else if self == false {
            return BoolString.FalseString.rawValue
        }
        
        return BoolString.FalseString.rawValue
    }
}


//MARK:- String Extension
extension String {
    
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameters:
     - length: Desired maximum lengths of a string
     - trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    
    func bool() -> Bool {
        if self == "0" {
            return false
        } else if self == "1" {
            return true
        }
        
        return false
    }
    
    func replace(_ target: String, withString: String) -> String {
        
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    static func getCurrentTimeZone() -> String {
        
        let timeZoneOffset = ((NSTimeZone.system.secondsFromGMT()) / 3600) * -60
        
        return "&tz=\(timeZoneOffset)"
    }
    
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    public var jsonToArrayOfDictionary: [[String : Any]]? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]]
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont =  UIFont.robotoRegular(16.0)) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func height(WithConstrainedWidth width: CGFloat, font: UIFont =  UIFont.robotoRegular(16.0)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.height
    }
    
    var linkAttributedString: NSAttributedString! {
        
        let underlined = NSAttributedString.underlinedString(self.capitalized)
        let hyperlink = NSMutableAttributedString.init(attributedString: underlined)
        hyperlink.addAttributes([.foregroundColor : UIColor.blue], range: NSRange.init(location: 0, length: underlined.length))
        
        return hyperlink
    }
    
    var first: String {
        return String(self.prefix(1))
    }
    
    var last: String {
        return String(self.suffix(1))
    }
    
    var uppercaseFirst: String {
        return first.uppercased() + self.dropFirst()
    }
    
    func splittedCamelCaseString() -> String {
        
        let splitted = self.splitBefore(separator: { $0.isUpperCase }).map{String($0)}
        let joinedString = splitted.joined(separator: " ")
        return joinedString
    }
    
    func isValidEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func stringWithoutSupHTML() -> String {
        
        return self.replace("", withString: "<sup>").replace("</sup>", withString: "")
    }
    
    func htmlAttributedString(_ font: UIFont = UIFont.robotoRegular(15.0), isDarkColor: Bool = false) -> NSAttributedString? {
        
        let aux = "<span style='font-family: \(font.fontName); font-size: \(font.pointSize)px; color:\(isDarkColor ? "black":"gray")'>\(self)</span>"
        
        guard let data = aux.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        
        return html
    }
    
    func htmlAttributedString(_ font: UIFont, customColor: UIColor) -> NSAttributedString? {
        
        let aux = "<span style='font-family: \(font.fontName); font-size: \(font.pointSize)px; color:\(customColor.htmlRGBColor)'>\(self)</span>"
        
        guard let data = aux.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        
        return html
    }
    
    var boolValue: Bool { return NSString(string: self).boolValue }
    
    func containsString(_ s:String) -> Bool {
        
        if self.range(of: s) != nil {
            return true
        } else {
            return false
        }
    }
    
    func containsString(_ s:String, compareOption: NSString.CompareOptions) -> Bool {
        
        if(self.range(of: s, options: compareOption)) != nil {
            return true
        } else {
            return false
        }
    }
    
    func cleanedString() ->  String {
        
        return self.removeLeadingAndTrailingSpaces()
    }
    
    func removeLeadingAndTrailingSpaces() ->  String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
}

//MARK:- NSAttributedString Extension
extension NSAttributedString {
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }
    
    var trimmedAttributedString: NSAttributedString {
    
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        
        guard let startLocation = startRange?.upperBound, let endLocation = endRange?.lowerBound else { return NSAttributedString(string: string) }
        
        let location = string.distance(from: string.startIndex, to: startLocation) - 1
        let length = string.distance(from: startLocation, to: endLocation) + 2
        let range = NSRange(location: location, length: length)
        
        return attributedSubstring(from: range)
    }
    /*
    Will be used but later
    internal convenience init?(html: String) {
        
        let font: UIFont = UIFont.robotoRegular(15.0)
        
        let aux = "<span style='font-family: \(font.fontName), ; font-size: \(font.pointSize)px; color:\("gray")'>\(html)</span>"
        
        guard let data = aux.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let attributedString = try?  NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString: attributedString)
    }
 */
    class func underlinedString(_ text: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: text)
        
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: NSMakeRange(0, text.count))
        
        return attributedText
    }
    
    convenience init(_ part1: String,
                      font1: UIFont = UIFont.robotoRegular(16.0),
                      color1: UIColor = UIColor.black,
                      part2: String? = nil,
                      font2: UIFont = UIFont.robotoRegular(14.0),
                      color2: UIColor = UIColor.gray) {
        
        let completeString = (part2 != nil ? part1 + " " + part2! : part1) as NSString
        
        let part1Range = completeString.range(of: part1)
        let part2Range = completeString.range(of: part2 ?? "")
        
        let attributedString = NSMutableAttributedString(string: completeString as String)
        attributedString.addAttributes([.foregroundColor: color1, .font: font1], range: part1Range)
        
        if part2 != nil && part2Range.location != NSNotFound {
            attributedString.addAttributes([.foregroundColor: color2, .font: font2], range: part2Range)
        }
        
        self.init(attributedString: attributedString)
    }
    
    convenience init(_ label: String, labelColor: UIColor = UIColor.black, value: String?, fontSize: CGFloat = 13.0, valueColor: UIColor = UIColor.darkGray) {
        
        let isIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        
        var defaultValue = "N/A"
        if value != nil && value!.count != 0 { defaultValue = value! }
        
        let completeString = (label + defaultValue) as NSString
        
        let part1Range = completeString.range(of: label)
        let part2Range = completeString.range(of: defaultValue)
        
        
        let attributedString = NSMutableAttributedString(string: completeString as String)
        
        attributedString.addAttributes([.foregroundColor: labelColor, .font: UIFont.robotoRegular(isIPad ? fontSize+2:fontSize)], range: part1Range)
        attributedString.addAttributes([.foregroundColor: valueColor, .font: UIFont.robotoRegular(isIPad ? fontSize+2:fontSize)], range: part2Range)
        
        
        self.init(attributedString: attributedString)
    }
}

extension UINavigationController
{
    /// Given the kind of a (UIViewController subclass),
    /// removes any matching instances from self's
    /// viewControllers array.
    
    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }
    
    /// Given the kind of a (UIViewController subclass),
    /// returns true if self's viewControllers array contains at
    /// least one matching instance.
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}


//MARK:- UIView Extension
@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}


extension UIView {
    
//    var width:      CGFloat { get { return self.frame.size.width } set { self.frame.size.width = newValue } }
//    var height:     CGFloat { get { return self.frame.size.height } set { self.frame.size.height = newValue } }
//    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setWidth(_ width:CGFloat)
    {
        self.frame.size.width = width
    }
    
    func setHeight(_ height:CGFloat)
    {
        self.frame.size.height = height
    }
    
    func setSize(_ size:CGSize)
    {
        self.frame.size = size
    }
    
    func setOrigin(_ point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func setX(_ x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    func setY(_ y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    func setCenterX(_ x:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    func setCenterY(_ y:CGFloat) //only change the origin x
    {
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    func roundCorner(_ radius:CGFloat)
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func roundedView(_ withBorder: Bool = false)
    {
        self.layer.layoutIfNeeded()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        if withBorder {
            self.addBorder()
        }
    }
    
    func addBorder(_ borderColor: UIColor = UIColor.gray,
                   borderWidth: CGFloat = 0.5) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    
    func setTop(_ top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(_ left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    func setRight(_ right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(_ bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func addShadow(_ radius: CGFloat, offset: CGSize) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.45
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addDropShadow(shadowRadius radius: CGFloat = 1.0) {
        self.addShadow(1, offset: CGSize(width: -1, height: 1))
    }
    
    func addUpperShadow() {
        
        self.layoutIfNeeded()
        self.addShadow(1, offset: CGSize(width: 1, height: -1))
    }
    
    enum ShakeDirection {
        case horizontal
        case vertical
    }
    
    func shake(_ times: Int = 10,
               direction: Int = 1,
               currentTimes: Int = 0,
               delta: CGFloat = 5.0,
               interval: TimeInterval = 0.03,
               shakeDirection: ShakeDirection = .horizontal) {
        
        UIView.animate(withDuration: interval, animations: {
            self.transform = shakeDirection == .horizontal ? CGAffineTransform(translationX: delta * CGFloat(direction), y: 0) : CGAffineTransform(translationX: 0, y: delta * CGFloat(direction))
        }, completion: { (completed) in
            
            if currentTimes >= times {
                
                UIView.animate(withDuration: interval, animations: {
                    self.transform = CGAffineTransform.identity
                })
                return
            }
            
            self.shake(times-1,
                       direction: (direction * -1),
                       currentTimes: currentTimes+1,
                       delta: delta,
                       interval: interval,
                       shakeDirection: shakeDirection)
        })
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}


//MARK:- HUD
extension HUD {
    
    class func showLoading(txt: String = "Loading") {
        
        HUD.show(withStatus: txt)
    }
}

//MARK:- UIImage Extension
extension UIImage {
    func croppedImage(_ bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * self.scale,
                                           y: bound.origin.y * self.scale,
                                           width: bound.size.width * self.scale,
                                           height: bound.size.height * self.scale)
        
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        
        let croppedImage : UIImage = UIImage(cgImage: imageRef!,
                                             scale: self.scale,
                                             orientation: UIImage.Orientation.up)
        return croppedImage
    }
    
    func compressImage() -> Data {
        let compressionQuality : CGFloat = 0.5
        
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: compressionQuality)
        UIGraphicsEndImageContext()
        
        return imageData!
    }
}


//MARK:- NSUserDefaults Extension
extension UserDefaults {
    public subscript(key: String) -> AnyObject? {
        get {
            return object(forKey: key) as AnyObject?
        }
        set {
            set(newValue, forKey: key)
        }
    }
}


//MARK:- UIFont Extension
extension UIFont {
    class func robotoBlack(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoBlack,
                      size: size)!
    }
    
    class func robotoBold(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoBold,
                      size: size)!
    }
    
    class func robotoItalic(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoItalic,
                      size: size)!
        
    }
    
    class func robotoLight(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoLight,
                      size: size)!
    }
    
    class func robotoMedium(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoMedium,
                      size: size)!
    }
    
    class func robotoRegular(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoRegular,
                      size: size)!
    }
    
    class func robotoThin(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoThin,
                      size: size)!
    }
    
    class func robotoCondensedBold(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoCondensedBold,
                      size: size)!
        
    }
    
    class func robotoCondensedRegular(_ size:CGFloat) -> UIFont {
        
        return UIFont(name: K.FontNameRobotoCondensedRegular,
                      size: size)!
    }
}

//MARK:- UITableViewCell -
extension UITableViewCell {
    
    func removeSeparatorInsets() {
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
}


public extension UITableView {
    
    func removeCellSeparatorOffset() {
        self.separatorInset = .zero
        
        self.preservesSuperviewLayoutMargins = false
        
        self.layoutMargins = .zero
        
    }
    
    func removeSeperateIndicatorsForEmptyCells() {
        self.tableFooterView = UIView()
    }
    
    /// Index path of last row in tableView.
    var indexPathForLastRow: IndexPath? {
        return indexPathForLastRow(inSection: self.lastSection)
    }
    
    /// Index of last section in tableView.
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    /// Number of all rows in all sections of tableView.
    var numberOfRows: Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    /// IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// Remove TableFooterView.
    func removeTableFooterView() {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    /// Remove TableHeaderView.
    func removeTableHeaderView() {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    /// Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
}


//MARK:- UIDevice Extension
private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
                          /* iPod 6 */          "iPod7,1": "iPod Touch 6",
                                                /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
                                                                      /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
                                                                                            /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
                                                                                                                  /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
                                                                                                                                        /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
                                                                                                                                                              /* iPhone 6 */        "iPhone7,2": "iPhone 6",
                                                                                                                                                                                    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
                                                                                                                                                                                                          /* iPhone 6S */       "iPhone8,1": "iPhone 6S",
                                                                                                                                                                                                                                /* iPhone 6S Plus */  "iPhone8,2": "iPhone 6S Plus",
                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                      /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
                                                                                                                                                                                                                                                                            /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
                                                                                                                                                                                                                                                                                                  /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
                                                                                                                                                                                                                                                                                                                        /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
                                                                                                                                                                                                                                                                                                                                              /* iPad Air 2 */      "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
                                                                                                                                                                                                                                                                                                                                                                    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
                                                                                                                                                                                                                                                                                                                                                                                          /* iPad Mini 2 */     "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
                                                                                                                                                                                                                                                                                                                                                                                                                /* iPad Mini 3 */     "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
                                                                                                                                                                                                                                                                                                                                                                                                                                      /* iPad Mini 4 */     "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
                                                                                                                                                                                                                                                                                                                                                                                                                                                            /* iPad Pro */        "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  /* AppleTV */         "AppleTV5,3": "AppleTV",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"]


extension UIDevice {
    
    public enum iPhoneType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case Unknown
    }
    
    public var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    public var iPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    
    public var isIPhone5: Bool! { return self.sizeType == .iPhone5 }
    public var isIPhone4: Bool! { return self.sizeType == .iPhone4 }
    public var isIPhoneX: Bool! { return self.sizeType == .iPhoneX }
    
    // Ref http://thinkdiff.net/mobile/iphone-x-and-other-ios-device-detection-by-swift-and-objective-c/
    public var sizeType: iPhoneType! {
        guard iPhone else { return .Unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneX
        default:
            return .Unknown
        }
    }
    
    public class func idForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    // Operating system name
    public class func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    // Operating system version
    public class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // Operating system version
    public class func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }
    
    public class func deviceName() -> String {
        return UIDevice.current.name
    }
    
    public class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    public class func deviceModelReadable() -> String {
        return DeviceList[deviceModel()] ?? deviceModel()
    }
    
    /// Returns true if the device is iPhone //TODO: Add to readme
    public class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    /// Returns true if the device is iPad //TODO: Add to readme
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    public class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)
        
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
    /// Device Version Checks
    public enum Versions: Float {
        case five = 5.0
        case six = 6.0
        case seven = 7.0
        case eight = 8.0
        case nine = 9.0
    }
    
    public class func isVersion(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue && systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    public class func isVersionOrLater(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue
    }
    
    public class func isVersionOrEarlier(_ version: Versions) -> Bool {
        return systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    public class var CURRENT_VERSION: String {
        return "\(systemFloatVersion())"
    }
    
    /// iOS 5 Checks
    public class func IS_OS_5() -> Bool {
        return isVersion(.five)
    }
    
    public class func IS_OS_5_OR_LATER() -> Bool {
        return isVersionOrLater(.five)
    }
    
    public class func IS_OS_5_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.five)
    }
    
    /// iOS 6 Checks
    public class func IS_OS_6() -> Bool {
        return isVersion(.six)
    }
    
    public class func IS_OS_6_OR_LATER() -> Bool {
        return isVersionOrLater(.six)
    }
    
    public class func IS_OS_6_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.six)
    }
    
    /// iOS 7 Checks
    public class func IS_OS_7() -> Bool {
        return isVersion(.seven)
    }
    
    public class func IS_OS_7_OR_LATER() -> Bool {
        return isVersionOrLater(.seven)
    }
    
    public class func IS_OS_7_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.seven)
    }
    
    /// iOS 8 Checks
    public class func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }
    
    public class func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }
    
    public class func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }
    
    /// iOS 9 Checks
    public class func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }
    
    public class func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }
    
    public class func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }
    
}


//MARK:- NSBundle Extension
extension Bundle {
    
    public var appVersion: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var appBuild: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}


//MARK:- AppDelegate
extension AppDelegate {
    
    func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        print("Current version: ", currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(currentVersion < version, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}


enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

extension UIPopoverPresentationController {
    var dimmingView: UIView? {
        return value(forKey: "_dimmingView") as? UIView
    }
}

// MARK: - UISegmentedControl
extension UISegmentedControl {
    
    var selectedIndexTitle: String {
        return self.titleForSegment(at: self.selectedSegmentIndex) ?? ""
    }
    
    var isLastIndexSelected: Bool {
        return self.selectedSegmentIndex == self.numberOfSegments-1
    }
    
    var isFirstIndexSelected: Bool {
        return self.selectedSegmentIndex == 0
    }
    
    var isAnyIndexSelected: Bool {
        return self.selectedSegmentIndex >= 0
    }
}


extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}


extension RangeReplaceableCollection where Indices: Equatable {
    
    mutating func rearrange(from: Index, to: Index) {
        if let _ = self.first , from != to {
            insert(remove(at: from), at: to)
        } else {
            return
        }
    }
}


#if DEBUG

/*
 // Usage
 //
 // po UIWindow.key.rootViewController!.printHierarchy
 //
 // po view.recursiveDescription
 */
extension UIWindow {
    
    class var key: UIWindow {
        let selector: Selector = NSSelectorFromString("keyWindow")
        let result = UIWindow.perform(selector)
        return result?.takeUnretainedValue() as! UIWindow
    }
}

extension UIView {
    
    var recursiveDescription: NSString {
        let selector: Selector = NSSelectorFromString("recursiveDescription")
        let result = perform(selector)
        return result?.takeUnretainedValue() as! NSString
    }
}


extension UIViewController {
    
    var printHierarchy: NSString {
        let selector: Selector = NSSelectorFromString("_printHierarchy")
        let result = perform(selector)
        return result?.takeUnretainedValue() as! NSString
    }
}

#endif

extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}

extension UIImage {
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}


extension SceneDelegate {
    
    func appleApplicationUITheme() {
        
        let titleTextAttribute: [NSAttributedString.Key : Any] = [.font: R.Fonts.AppBoldFont, .foregroundColor: R.ThemeColor.unSelectedColor]
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = R.ThemeColor.selectedColor
            
            appearance.titleTextAttributes = titleTextAttribute
            appearance.largeTitleTextAttributes = titleTextAttribute
        }
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)
        
        UINavigationBar.appearance().barTintColor = R.ThemeColor.selectedColor
        UINavigationBar.appearance().tintColor = R.ThemeColor.unSelectedColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: R.ThemeColor.unSelectedColor]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = titleTextAttribute
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = R.ThemeColor.unSelectedColor
        
        
        
        
        UIToolbar.appearance().tintColor = R.ThemeColor.unSelectedColor
        UIToolbar.appearance().barTintColor = R.ThemeColor.selectedColor
        
        
        UISwitch.appearance().onTintColor = R.ThemeColor.selectedColor
        
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttribute, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor:UIColor.gray], for: .disabled)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(titleTextAttribute, for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = R.Fonts.NormalTextFont
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.black
        
        UISegmentedControl.appearance().tintColor = R.ThemeColor.selectedColor
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: R.ThemeColor.selectedColor]

        
        SVProgressHUD.setDefaultMaskType(.clear)
        HUD.setForegroundColor(R.ThemeColor.selectedColor)
        HUD.setBackgroundColor(UIColor.clear)
        HUD.setRingThickness(4)
        HUD.setRingRadius(24)
        HUD.setRingNoTextRadius(28)
        
    }
}

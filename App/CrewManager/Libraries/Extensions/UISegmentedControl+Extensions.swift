//This is not my code, i took this from git hub link below
//http://git.addrenaline.nl/wouter/alerts-and-pickers/tree/master/Source/Extensions

import UIKit

public extension UISegmentedControl {
    
    /// Font of titles
    func title(font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        setTitleTextAttributes(attributes, for: UIControl.State())
        //setNeedsDisplay()
        //layoutIfNeeded()
    }
    
    /// Segments titles.
    public var segmentTitles: [String?] {
        get {
            var titles: [String?] = []
            var i = 0
            while i < numberOfSegments {
                titles.append(titleForSegment(at: i))
                i += 1
            }
            return titles
        }
        set {
            removeAllSegments()
            for (index, title) in newValue.enumerated() {
                insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
    
    /// Segments images.
    public var segmentImages: [UIImage?] {
        get {
            var images: [UIImage?] = []
            var i = 0
            while i < numberOfSegments {
                images.append(imageForSegment(at: i))
                i += 1
            }
            return images
        }
        set {
            removeAllSegments()
            for (index, image) in newValue.enumerated() {
                insertSegment(with: image, at: index, animated: false)
            }
        }
    }
}

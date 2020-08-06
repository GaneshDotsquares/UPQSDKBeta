

import UIKit

public extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var shadowColor:  UIColor? {
        set {
            layer.masksToBounds =  false
            layer.shadowColor = newValue?.cgColor
            layer.shadowRadius = 2
            layer.shadowOffset = CGSize.zero//CGSize(width: 2, height: 2)
            layer.shadowOpacity = 0.8
        }
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
     class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
     class func loadNib() -> Self {
        return loadNib(self)
    }
    
     func getSnapshot(_ view: UIView) -> UIImage {
        
        var captureImage: UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        captureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return captureImage
    }
    
    
   var width:      CGFloat { return self.frame.size.width }
   var height:     CGFloat { return self.frame.size.height }
   var size:       CGSize  { return self.frame.size}
   
   var origin:     CGPoint { return self.frame.origin }
   var x:          CGFloat { return self.frame.origin.x }
   var y:          CGFloat { return self.frame.origin.y }
   var centerX:    CGFloat { return self.center.x }
   var centerY:    CGFloat { return self.center.y }
   
   var left:       CGFloat { return self.frame.origin.x }
   var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
   var top:        CGFloat { return self.frame.origin.y }
   var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        self.layer.shouldRasterize = true
        //        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
	
    
    //  MARK:- Get view's parent view controller
     var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    //  MARK:- Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..)
    @available(iOS 9, *)  func addConstraints(withFormat: String, views: UIView...) {
        // https://videos.letsbuildthatapp.com/
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withFormat, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    //  MARK:- Anchor all sides of the view into it's superview.
    @available(iOS 9, *)  func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
}





extension UIView {
    
    func setGradient(colours: [UIColor]) -> Void {
        self.setGradient(colours: colours, locations: nil)
    }
    
    func setGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func linearGradient(with color1:UIColor, color2:UIColor, vertical:Bool = false, firstColorRatio:Double = 0.5) {
        
        let gradientLayer       = CAGradientLayer()
        gradientLayer.frame     = self.bounds
        gradientLayer.colors    = [color1.cgColor, color1.cgColor]
        
        if vertical {
            gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
            gradientLayer.endPoint  = CGPoint(x:0.5, y:1.0)
        }else {
            gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
            gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        }
        let value:Double  = 1.0 - firstColorRatio
        gradientLayer.locations = [1, 0]
        gradientLayer.locations = [0.0, NSNumber(floatLiteral: value)]
        self.layer.addSublayer(gradientLayer)
        
    }
}

public class RadialGradientLayer: CALayer {
    
    public var center:CGPoint = CGPoint.zero
    public var radius:CGFloat = 0
    public var colors = [UIColor]()
    
    required override public init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override public init(layer: Any) {
        super.init(layer: layer)
    }

    override public func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        var locations   = [CGFloat]()
        for i in 0...colors.count-1 {
            locations.append(CGFloat(i) / CGFloat(colors.count))
        }
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = min(bounds.width / 2.0, bounds.height / 2.0)
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}

//  MARK:- Add Gradient to UIView.
///
/// - Parameters:
/// - Make sure the UIView is of type GradientView in IB means class name
///   view.gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
///   view.gradientLayer.gradient = GradientPoint.rightLeft.draw()
typealias GradientType = (x: CGPoint, y: CGPoint)

enum GradientPoint {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
    func draw() -> GradientType {
        switch self {
        case .leftRight:
            return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
        }
    }
}

class GradientLayer : CAGradientLayer {
    var gradient: GradientType? {
        didSet {
            startPoint = gradient?.x ?? CGPoint.zero
            endPoint = gradient?.y ?? CGPoint.zero
        }
    }
}

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        get {
            return GradientLayer.self
        }
    }
}

protocol GradientViewProvider {
    associatedtype GradientViewType
}

extension GradientViewProvider where Self: UIView {
    var gradientLayer: GradientViewType {
        return layer as! GradientViewType
    }
}

extension UIView: GradientViewProvider {
    typealias GradientViewType = GradientLayer
}

/*extension MapSearchVC  {
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        NSLog("Animation stopped")
    }
}

NOTE: Call from your view controller when hide show

filterView?.hidden = hidden
//filterView.slideWithTransition(kCATransitionFromBottom)
filterView.slideWithTransition(kCATransitionFromLeft, duration: 1.0, completionDelegate: self)
}*/


extension UIView{
    func createCircularPath() {
        
        let circleLayer = CAShapeLayer()
        let progressLayer = CAShapeLayer()
        
        let center = self.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -.pi / 2, endAngle: 2 * .pi, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.lightGray.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0  //for thicker circle compared to progressLayer
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(circleLayer)
        self.layer.addSublayer(progressLayer) 
    
        
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.toValue = 1
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(progressAnimation, forKey: "progressAnim")
        
    }
}

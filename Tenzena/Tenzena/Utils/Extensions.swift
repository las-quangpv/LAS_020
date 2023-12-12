import Foundation
import AVFoundation
import UIKit
import Kingfisher
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderingMode)
    }
}
extension UIView {
  func addDashedBorder() {
      let color = UIColor.gray.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 2
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,3]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}
extension UIColor {
    static func setUpGradient(v: UIView, listColor: [UIColor]) -> UIColor {
        guard let color = UIColor.gradientColor(withSize: v.bounds.size, colors: listColor) else { return UIColor.clear }
        return color
    }
    static func gradientColor(withSize size: CGSize, colors: [UIColor]) -> UIColor? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            if let gradientImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return UIColor(patternImage: gradientImage)
            }
        }
        UIGraphicsEndImageContext()
        
        return nil
    }
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
    }
}
extension UILabel {
    func setText(_ text: String, animationDuration duration: TimeInterval) {
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {  self.text = text },
            completion: nil
        )
    }
}
extension UIView {
    func topRadius(radius: Int) {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    func bottomRadius(radius: Int) {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    func leftRadius(radius: Int) {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
extension UIViewController {
    func addOverlay(color: UIColor = UIColor(hex: 0x0A162D), opacity: CGFloat = 0.6) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ActivityEx.screenWidth(), height: ActivityEx.screenHeight()))
        view.backgroundColor = color.withAlphaComponent(opacity)
        view.tag = 3407
        self.view.addSubview(view)
    }
    
    
    func removeOverlay(contextVC: UIViewController!) {
        if let view = contextVC.view.viewWithTag(3407) {
            view.removeFromSuperview()
        }
    }
}
extension Dictionary {
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            var percentEscapedValue: String = "\(value)"
            if value is String {
                percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            }
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
extension UIImageView{
    func setImage(imageUrl: String){
        let url = imageHost+imageUrl
        self.kf.setImage(with: URL(string: url))
    }
}
extension String {
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    
    //"2023-09-26"
    //
    func dateToString(dateFormat: String)-> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd"

        if let inputDate = dateFormatterInput.date(from: self) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = dateFormat
            
            let outputDateString = dateFormatterOutput.string(from: inputDate)
            return outputDateString
        } else {
            return self
        }
    }
    func isTextEmpty() -> Bool {
        if(self == nil || self == "null" || self == "") {
            return true
        }
        return false
    }
    
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

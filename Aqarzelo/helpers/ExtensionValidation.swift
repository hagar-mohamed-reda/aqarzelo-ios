//
//  ExtensionValidation.swift
//  Aqarzeoo
//
//  Created by hosam on 2/10/20.
//  Copyright © 2020 hosam. All rights reserved.
//

import UIKit


extension UIView {
    
        private static let kRotationAnimationKey = "rotationanimationkey"
        
        func rotate(duration: Double = 1) {
            if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                
                rotationAnimation.fromValue = 0.0
                rotationAnimation.toValue = Float.pi * 2.0
                rotationAnimation.duration = duration
                rotationAnimation.repeatCount = Float.infinity
                
                layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
            }
        }
        
        func stopRotating() {
            if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
                layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
            }
        }
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
               let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
              rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)//M_PI
              rotateAnimation.duration = duration
    
               if let delegate: AnyObject = completionDelegate {
                rotateAnimation.delegate = delegate as? CAAnimationDelegate
                   }
        self.layer.add(rotateAnimation, forKey: nil)
           }
    
}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}


extension String {
    
    func toDates(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
    
    
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneNumberRegex = "^[0-0]\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    
    public func toDouble() -> Double?
    {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

extension UIImage
{
    //resize image
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func getFileName() -> String? {
        // First set accessibilityIdentifier of image before calling.
        let imgName = self.accessibilityIdentifier
        return imgName
    }
    
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
        convenience init?(url: URL?) {
            guard let url = url else { return nil }
            
            do {
                let data = try Data(contentsOf: url)
                self.init(data: data)
            } catch {
                print("Cannot load image from url: \(url) with error: \(error)")
                return nil
            }
        }
    
}


extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc
    fileprivate func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
    
    
}

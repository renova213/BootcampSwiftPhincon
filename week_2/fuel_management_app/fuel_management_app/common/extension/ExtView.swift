//
//  ExtView.swift
//  fuel_management_app
//
//  Created by Phincon on 31/10/23.
//

import Foundation
import UIKit

extension UIView {
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    func makeCircular() {
           self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) / 2
           self.clipsToBounds = true
       }
    
    func roundRadius(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
           let maskPath = UIBezierPath()
           maskPath.move(to: CGPoint(x: bounds.minX + topLeft, y: bounds.minY))
           maskPath.addLine(to: CGPoint(x: bounds.maxX - topRight, y: bounds.minY))
           maskPath.addArc(withCenter: CGPoint(x: bounds.maxX - topRight, y: bounds.minY + topRight), radius: topRight, startAngle: 3 * CGFloat.pi / 2, endAngle: 0, clockwise: true)
           maskPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bottomRight))
           maskPath.addArc(withCenter: CGPoint(x: bounds.maxX - bottomRight, y: bounds.maxY - bottomRight), radius: bottomRight, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
           maskPath.addLine(to: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY))
           maskPath.addArc(withCenter: CGPoint(x: bounds.minX + bottomLeft, y: bounds.maxY - bottomLeft), radius: bottomLeft, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
           maskPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + topLeft))
           maskPath.addArc(withCenter: CGPoint(x: bounds.minX + topLeft, y: bounds.minY + topLeft), radius: topLeft, startAngle: CGFloat.pi, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
           
           let maskLayer = CAShapeLayer()
           maskLayer.path = maskPath.cgPath
           layer.mask = maskLayer
       }
}

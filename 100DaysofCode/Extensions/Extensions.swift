//
//  Extensions.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/23/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {

    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}


extension CGPoint {
   static func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(CGFloat.pi / 180)
    }
}

extension CAShapeLayer {
    func addGradient(color1:UIColor, color2:UIColor, layer:CAShapeLayer ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 0.9]
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        layer.insertSublayer(gradientLayer, at: 0)
    }

  static func drawFullCircle(width:Int, fillColor:UIColor?, strokeColor:UIColor?, center:CGPoint) -> CAShapeLayer {
        let circle = CAShapeLayer()
        let trackPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:(CGFloat.pi * 2), clockwise: true)
    circle.fillColor = fillColor?.cgColor ?? UIColor.clear.cgColor
    circle.strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        circle.path = trackPath.cgPath
        circle.strokeEnd = 0
        circle.lineCap = CAShapeLayerLineCap.round
        return circle



    }

   static  func drawPartialCircle(streak:Int,width:Int, fillColor:UIColor?, strokeColor:UIColor?, center:CGPoint) -> CAShapeLayer {
        let circle = CAShapeLayer()
        let angle:Double = ((Double(streak)/100)*360)
        let degrees = CGFloat(angle)

        let percentageCirclePath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:CGPoint.degreesToRadians(degrees: degrees - 90), clockwise: true)
        circle.fillColor = fillColor?.cgColor ?? UIColor.clear.cgColor
        circle.strokeColor = strokeColor?.cgColor  ?? UIColor.black.cgColor
        circle.path = percentageCirclePath.cgPath
        circle.strokeEnd = 0
        circle.lineCap = CAShapeLayerLineCap.round
        return circle



    }
}
extension UIView {
     func addGradient(color1:UIColor, color2:UIColor ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 0.9]
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 1, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyMotion(toView view:UIView, magnitude:Float)  {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude

        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis )
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude

        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion, yMotion]
        view.addMotionEffect(group)

    }
}

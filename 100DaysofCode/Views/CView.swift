//
//  CView.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/15/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class CView: UIView {

    /*

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var viewCenter:CGPoint = CGPoint(x: 0, y: 0)
    lazy var mainView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))

        return view
    }()
    lazy var trackLayer:CAShapeLayer = {
        var layer = CAShapeLayer()
//        let center = CGPoint(x: self.viewCenter.x, y: self.viewCenter.y) //CGPoint(x: (counterView.frame.minX) + 40, y: (counterView.frame.minY) - 120)
        let trackPath = UIBezierPath(arcCenter: self.mainView.center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2), clockwise: true)
        layer.path = trackPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 3
        layer.fillColor = UIColor.black.cgColor

        return layer
    }()
    lazy var streakLayer:CAShapeLayer = {
//        let angle:Double = ((Double(streak)/100)*360)
//        let degrees = CGFloat(angle)
//        let center = view.center
//
//        let trackPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:(CGFloat.pi * 2), clockwise: true)
//        let percentageCirclePath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:CGPoint.degreesToRadians(degrees: degrees - 90), clockwise: true)
        var layer = CAShapeLayer()
        //        let center = CGPoint(x: self.viewCenter.x, y: self.viewCenter.y) //CGPoint(x: (counterView.frame.minX) + 40, y: (counterView.frame.minY) - 120)
        let trackPath = UIBezierPath(arcCenter: self.mainView.center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2), clockwise: true)
        layer.path = trackPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor(red: 40/255, green: 148/255, blue: 216/255, alpha: 1).cgColor
        layer.lineWidth = 10
        layer.fillColor = UIColor.black.cgColor
        layer.strokeEnd = 0
        layer.lineCap = CAShapeLayerLineCap.round

        return layer
    }()

    lazy var shadowLayer:CALayer = {
        var layer  = CALayer()
        let trackPath = UIBezierPath(arcCenter: self.mainView.center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2),clockwise: true)
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor(red: 81/255, green: 156/255, blue: 215/255, alpha: 1).cgColor
        layer.shadowRadius = 20
        layer.shadowOpacity = 1
        layer.shadowPath = trackPath.cgPath
        return layer
    }()
    lazy var counterLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: self.mainView.bounds.midX, y: self.mainView.bounds.midY, width: 100, height: 60))

        label.center = CGPoint(x: self.mainView.bounds.midX, y: self.mainView.bounds.midY)
        label.textColor = UIColor.white
        label.font = UIFont(name: "Marion", size: 60)
        label.textAlignment = .center
        return label
    }()
    func setup() {
        addSubview(mainView)

        mainView.layer.addSublayer(shadowLayer)
        mainView.layer.addSublayer(trackLayer)
        mainView.layer.addSublayer(streakLayer)
        mainView.addSubview(counterLabel)
    }
    
    override func awakeFromNib() {

    }
    func animatea() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        print(Double(3/10) )
        animation.fromValue = 0
        animation.toValue =  0.75

        animation.duration = 1
        animation.isRemovedOnCompletion = false
        //animation.autoreverses = true
        animation.fillMode = .forwards
        


        streakLayer.add(animation, forKey: "StrokeEnd")

    }

}

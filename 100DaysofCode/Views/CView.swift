//
//  CView.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 4/15/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit

class CView: UIView {

    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var streak:Int = {
        var number = Int()
        return number
    }()

    //MARK:- Views
    lazy var mainView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))

        return view
    }()

    lazy var counterLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: self.mainView.bounds.midX, y: self.mainView.bounds.midY, width: 100, height: 60))

        label.center = CGPoint(x: self.mainView.bounds.midX, y: self.mainView.bounds.midY)
        label.textColor = UIColor.white
        label.font = UIFont(name: "Marion", size: 60)
        label.textAlignment = .center
        return label
    }()

    //MARK:- Layers
    lazy var trackLayer:CAShapeLayer = {
        var layer = CAShapeLayer()
        layer.path = trackPath()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 3
        layer.fillColor = UIColor.black.cgColor

        return layer
    }()

    lazy var streakLayer:CAShapeLayer = {
        var layer = CAShapeLayer()

        layer.path = trackPath()
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

        layer.shadowOffset = .zero
        layer.shadowColor = UIColor(red: 81/255, green: 156/255, blue: 215/255, alpha: 1).cgColor
        layer.shadowRadius = 35
        layer.shadowOpacity = 1
        layer.shadowPath = trackPath()
        return layer
    }()



    //MARK:- View Setup
    func setup() {
        addSubview(mainView)

        mainView.layer.addSublayer(shadowLayer)
        mainView.layer.addSublayer(trackLayer)
        mainView.layer.addSublayer(streakLayer)
        mainView.addSubview(counterLabel)
    }
    //MARK:- data/view mode funcs
    func setStreak(_ number:Int) {
        self.streak = number
        self.counterLabel.text = String(number)
        triggerStreakLoadAnim()
    }

    //MARK:- Animations

    func triggerStreakLoadAnim() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.fromValue = 0
        animation.toValue =  1

        animation.duration = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction =  CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        if streak > 25 {
            shadowLayer.shadowPath = percentagePath()
        } else {
            shadowLayer.shadowPath = trackPath()
        }

        UIView.animate(withDuration: 1) {
            self.counterLabel.layer.opacity = 1
            self.shadowLayer.opacity = 1
        }
        streakLayer.opacity = 1
        streakLayer.path = percentagePath()
        streakLayer.add(animation, forKey: "StrokeEnd")

    }

    func triggerShadowLayerAnim() {
        let animation2  = CABasicAnimation(keyPath: "opacity")
        animation2.fromValue = 1
        animation2.toValue = 0

        animation2.duration = 0.55
        animation2.autoreverses = true

        shadowLayer.add(animation2, forKey: "shadow")

    }

    //MARK:- CGPaths
    private func percentagePath() -> CGPath {

        let angle:Double = ((Double(streak)/100)*360)
        let degrees = CGFloat(angle)
        let path = UIBezierPath(arcCenter:self.mainView.center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle:CGPoint.degreesToRadians(degrees: degrees - 90), clockwise: true).cgPath

        return path
    }
    private func trackPath() -> CGPath {
        let trackPath = UIBezierPath(arcCenter: self.mainView.center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2),clockwise: true)
        return trackPath.cgPath
    }

}

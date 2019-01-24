//
//  HomeViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController {


    @IBOutlet var counterActivtyIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var streakCounterImageView: UIImageView!

    var profilePictureURL:URLRequest!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer : CAShapeLayer!
    var streak = 0
    var hasCommited = false

    override func viewWillAppear(_ animated: Bool) {
        counterActivtyIndicator.startAnimating()
        imageViewActivityIndicator.startAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewSetup()
        dataRequest()
    }
    func commitSetup() {
        hasCommited = userDefaults.bool(forKey:"hasCommited")
        if hasCommited == true {

            pulsatingLayer.strokeColor = UIColor.green.cgColor
        } else {
            pulsatingLayer.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7).cgColor
        }
    }

    func imageViewSetup() {
    profilePictureImageView.layer.cornerRadius = 50
    profilePictureImageView.clipsToBounds = true
    profilePictureImageView.layer.borderWidth = 3
    profilePictureImageView.layer.borderColor = UIColor(red: 31/255, green: 67/255, blue: 140/255, alpha: 1).cgColor

    streakCounterImageView.layer.cornerRadius = streakCounterImageView.frame.width/2
    streakCounterImageView.layer.borderWidth = 3
    streakCounterImageView.layer.borderColor = UIColor(red: 31/255, green: 67/255, blue: 140/255, alpha: 1).cgColor
    }
    func dataRequest(){
        if let username = userDefaults.string(forKey: "username") {
            NetworkingProvider.getProfilePictureFor(username: username, completion: { url in
                if url != "" {
                    let urlRequest = URLRequest(url: URL(string: url)!)

                    self.downloader.download(urlRequest) { response in
                        if let image = response.result.value {
                            self.profilePictureImageView.image = image

                            self.imageViewActivityIndicator.isHidden = true
                        }
                    }
                }
            })
            NetworkingProvider.getCurrentStreakFor(username: username) { (streakCount) in

                self.counterLabel.text = String(streakCount)
                self.streak = streakCount
                self.drawCircles()
                self.animateCircleDrawing()
                self.animatePulsatingLayer()
                self.counterActivtyIndicator.isHidden = true
            }
            usernameLabel.text = username
        }

    }
    @objc func animateCircleDrawing() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "StrokeEnd")
    }
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(CGFloat.pi / 180)
    }
    func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.4
        animation.fromValue = 1.3
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    func drawCircles() {
        let angle:Double = ((Double(streak)/100)*360)
        let degrees = CGFloat(angle)
        let center = view.center

        let trackPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:(CGFloat.pi * 2), clockwise: true)
        let percentageCirclePath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:degreesToRadians(degrees: degrees - 90), clockwise: true)

        pulsatingLayer = CAShapeLayer()
        commitSetup()
    //    pulsatingLayer.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7).cgColor
        pulsatingLayer.lineWidth = 20
        pulsatingLayer.fillColor = UIColor.clear.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.path = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        pulsatingLayer.position = view.center

        let trackLayer = CAShapeLayer()

        trackLayer.path = trackPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10

        shapeLayer.path = percentageCirclePath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
            view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)


    }
}

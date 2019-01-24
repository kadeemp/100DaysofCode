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
    var profilePictureURL:URLRequest!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()
    let shapeLayer = CAShapeLayer()
    var streak = 0

    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }

    func drawcircle() {
        let center = view.center
        let angle = (streak/100) * 360
        let circlePath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:(CGFloat.pi * 2), clockwise: true)
        let trackLayer = CAShapeLayer()

        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10

        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(shapeLayer)

    }
    @IBOutlet var streakCounterImageView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        counterActivtyIndicator.startAnimating()
        imageViewActivityIndicator.startAnimating()
    }

    @objc func imageTapped() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "StrokeEnd")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector( imageTapped)))
        drawcircle()
        profilePictureImageView.layer.cornerRadius = 50
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.borderWidth = 3
        profilePictureImageView.layer.borderColor = UIColor(red: 31/255, green: 67/255, blue: 140/255, alpha: 1).cgColor


        streakCounterImageView.layer.cornerRadius = streakCounterImageView.frame.width/2
        streakCounterImageView.layer.borderWidth = 3
        streakCounterImageView.layer.borderColor = UIColor(red: 31/255, green: 67/255, blue: 140/255, alpha: 1).cgColor




        print(userDefaults.bool(forKey: "hasCommited"))
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
                self.imageTapped()
                self.counterActivtyIndicator.isHidden = true
            }

            usernameLabel.text = username
        }


        // Do any additional setup after loading the view.
    }

}

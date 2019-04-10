//
//  HomeViewController.swift
//  100DaysofCode
//
//  Created by Kadeem Palacios on 1/21/19.
//  Copyright © 2019 Kadeem Palacios. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData
import Firebase

class HomeViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    //TODO:- Add function for saving nodes to core data, add observer

    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var counterActivtyIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewActivityIndicator: UIActivityIndicatorView!

    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var streakCounterImageView: UIImageView!
    @IBOutlet var commitStatusImage: UIImageView!

    @IBOutlet var centerView: UIView!
    var newCounterLabel:UILabel!
    var counterView:UIView!
    var profilePictureURL:URLRequest!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()
    let circleLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    var pulsatingLayer : CAShapeLayer!
    var streak = 0

    var nodes:[CommitNode] = []
    var currentDay:Date!


    override func viewWillAppear(_ animated: Bool) {
        counterActivtyIndicator.startAnimating()
        imageViewActivityIndicator.startAnimating()

       // CommitManager.updateHasCommited()
        NotificationCenter.default.addObserver(self, selector: #selector(internetAlertError), name: NotificationName.internetErrorNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadDefaults), name: NotificationName.loadDefaults, object: nil)

        imageViewActivityIndicator.isHidden = true
        counterActivtyIndicator.isHidden = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        } else if scrollView.contentOffset.y >= 0 {
            scrollView.contentOffset.y = 0
        }

    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if scrollView.bounds.maxY < 550 {
            print("execture")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewSetup()
        trackLayerSetup()
        counterLabelSetup()
        if let user = Auth.auth().currentUser {
            FirebaseController.instance.returnUserInfo(category: FirebaseUserKeys.firstName, completion: {(name)  in
                self.greetingLabel.text = "Hello \(name)"
            }
            )
        }
        username = UserDefaults.standard.string(forKey: "username")
        pulsatingLayer = CAShapeLayer()

    }
    func scrollViewSetup() {
        let scrollerView = UIScrollView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.view.frame.height) * 0.8))
        scrollerView.contentSize = CGSize(width: 250, height: 600)
        scrollerView.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        scrollerView.delegate = self

        counterView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        counterView.center = CGPoint(x: scrollerView.bounds.midX, y: scrollerView.bounds.midY)

        //counterView.layer.backgroundColor = UIColor.brown.cgColor
        self.view.addSubview(scrollerView)
        scrollerView.addSubview(counterView)


    }

    func trackLayerSetup(){
        let center = CGPoint(x: counterView.bounds.midX, y: counterView.bounds.midY) //CGPoint(x: (counterView.frame.minX) + 40, y: (counterView.frame.minY) - 120)
        let trackPath = UIBezierPath(arcCenter: center, radius: 170, startAngle: -CGFloat.pi / 2, endAngle: (CGFloat.pi * 2), clockwise: true)
        trackLayer.path = trackPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 3
        trackLayer.fillColor = UIColor.black.cgColor

        trackLayer.shadowOffset = .zero
        trackLayer.shadowColor = UIColor(red: 81/255, green: 156/255, blue: 215/255, alpha: 1).cgColor
        trackLayer.shadowRadius = 20
        trackLayer.shadowOpacity = 1
        trackLayer.shadowPath = trackPath.cgPath
        counterView.layer.addSublayer(trackLayer)
    }

    func counterLabelSetup() {
        newCounterLabel = UILabel(frame: CGRect(x: counterView.bounds.midX, y: counterView.bounds.midY, width: 100, height: 60))

        newCounterLabel.center = CGPoint(x: counterView.bounds.midX, y: counterView.bounds.midY)
        newCounterLabel.text = "15"
        newCounterLabel.textColor = UIColor.white
        newCounterLabel.font = UIFont(name: "Marion", size: 60)
        newCounterLabel.textAlignment = .center


        counterView.addSubview(newCounterLabel)
    }


    override func viewWillDisappear(_ animated: Bool) {
        CoreDataStack.saveStreak(streak: self.streak)
    }
    @objc func loadDefaults() {
        CoreDataStack.getUsername(completion: { username in


            self.username = username
        })
        CoreDataStack.getStreak(completion: {streak in
            self.streak =  streak
            //            self.counterLabel.text = String(streak)
        })
        let coreDataNodes = CoreDataStack.returnSavedNodes()
        for node in coreDataNodes {
            self.nodes.append(node)
        }


        imageViewSetup()
        drawCircles()
        animateCircleDrawing()
        animatePulsatingLayer(nil)
        self.counterActivtyIndicator.isHidden = true
    }
    func load() {

        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1


        if self.username != nil {
            operationQueue.addOperation {
                DispatchQueue.main.async {
                    self.imageViewSetup()
                    //                    print("setting images")
                    CoreDataStack.getUser(completion: { (user) in
                        //                        print(user)
                    })
                }
                //                print("2")
            }
            operationQueue.addOperation {
                DispatchQueue.main.async {
                    CommitManager.updateCommitStatus(completion: { (streak, returnedNodes) in
                        self.streak = streak
                        //                        print("the streak is set to \(self.streak)")
                        self.nodes = returnedNodes
                        //                        print("just drew circles")
                    }
                    )

                }
                print("4")

            }
            operationQueue.addOperation {
                DispatchQueue.main.async {
                    //                    print(" the  view streak is\(self.streak)")
                    self.animateCircleDrawing()
                    self.animatePulsatingLayer(nil)
                    self.counterActivtyIndicator.isHidden = true
                    //                    print("updating streak")
                }
                //                print("6")
            }
        } else {
            loadDefaults()
        }
    }

    func commitSetup() {
        //  hasCommited = userDefaults.bool(forKey:"hasCommited")
        guard let node = nodes.last else { return }
        if pulsatingLayer != nil {
            print(node.date)

            if node.commitStatus {

                UIView.animate(withDuration: 10, animations: {
                    self.pulsatingLayer.strokeColor = UIColor(red: 102/255, green: 255/255, blue: 100/255, alpha: 0.3).cgColor
                    self.commitStatusImage.image = UIImage(named: "Circled Green Check")
                })
            } else {
                UIView.animate(withDuration: 10, animations: {
                    self.pulsatingLayer.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7).cgColor
                })
                self.commitStatusImage.image = UIImage(named: "Circled Red X")
            }
        }
    }


    func imageViewSetup() {
        profilePictureImageView.layer.cornerRadius = 30
        profilePictureImageView.clipsToBounds = true
        view.applyMotion(toView: profilePictureImageView, magnitude: 10)
        view.applyMotion(toView: commitStatusImage, magnitude: 10)
        CoreDataStack.getUserProfilePhoto(completion: { image in
            self.profilePictureImageView.image = image
        })
        imageViewActivityIndicator.stopAnimating()
        imageViewActivityIndicator.isHidden = true
    }

    var animator = UIViewPropertyAnimator(duration: 5, curve: .easeInOut)
    @IBAction func US(_ sender: Any) {
        //        updateStatus()
        // var animator = UIViewPropertyAnimator(duration: 5, curve: .easeInOut)
        //animatePulsatingLayer(nil)

        //        if let context  = UIGraphicsGetCurrentContext() {
        //            context.beginPath()
        //            context.addEllipse(in: .init(origin: view.center, size: CGSize(width: 120, height: 120)))
        //            context.addRect(CGRect(x: 100, y: 100, width: 100, height: 100))
        //            context.clip()
        //            let space = CGColorSpaceCreateDeviceRGB()
        //            let color1 = UIColor.black
        //            let color2 = UIColor.lightGray
        //            let color3 = UIColor.gray
        //            let colors = [color1.cgColor,color2.cgColor,color3.cgColor] as CFArray
        //            let locations :[CGFloat] = [0.0,0.5,0.9]
        //            let gradient = CGGradient(colorsSpace: space, colors: colors, locations: locations)
        //            let start = CGPoint(x: 10, y: 10)
        //            let end = CGPoint(x: 110, y: 110)
        //
        //            context.drawLinearGradient(gradient!, start:start , end: end, options: .drawsBeforeStartLocation)
        //        }
    }



    func drawCircles() {
        let angle:Double = ((Double(streak)/100)*360)
        let degrees = CGFloat(angle)
        let center = view.center

        let trackPath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:(CGFloat.pi * 2), clockwise: true)
        let percentageCirclePath = UIBezierPath(arcCenter: center, radius: 120, startAngle: -CGFloat.pi / 2, endAngle:CGPoint.degreesToRadians(degrees: degrees - 90), clockwise: true)

        commitSetup()

        //    pulsatingLayer.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.7).cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.fillColor = UIColor.clear.cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.path = UIBezierPath(arcCenter: .zero, radius: 120, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        pulsatingLayer.position = view.center

        trackLayer.path = trackPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10

        //trackLayer.position = centerView.center

        circleLayer.path = percentageCirclePath.cgPath
        circleLayer.lineWidth = 10
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.blue.cgColor
        circleLayer.strokeEnd = 0
        circleLayer.lineCap = CAShapeLayerLineCap.round

        view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(trackLayer)
        view.layer.addSublayer(circleLayer)
    }
}
extension HomeViewController {

    @objc func internetAlertError() {
        let alert = UIAlertController(title: "Couldn't retrive your commits", message: "Check Your network connection and try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel , handler: nil)
        alert.addAction(okAction)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }

    @objc func animateCircleDrawing() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        circleLayer.add(basicAnimation, forKey: "StrokeEnd")
    }

    func animatePulsatingLayer(_ speed:Int?) {

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.09
        animation.fromValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    func stopPulsing(){
        animator.addAnimations {
            //self.trackLayer.frame.origin.x = self.trackLayer.frame.midX + 40
            self.pulsatingLayer.transform = CATransform3DMakeScale(CGFloat(3), CGFloat(3), CGFloat(3))

        }
        animator.addAnimations {
            self.pulsatingLayer.transform = CATransform3DMakeScale(CGFloat(1), CGFloat(1), CGFloat(1))
        }
        animator.addAnimations {
            self.pulsatingLayer.strokeColor = UIColor.clear.cgColor
        }

        animator.startAnimation()
    }
}

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

class HomeViewController: UIViewController {

    //TODO:- Add function for saving nodes to core data, add observer

    @IBOutlet var counterActivtyIndicator: UIActivityIndicatorView!
    @IBOutlet var imageViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var streakCounterImageView: UIImageView!
    @IBOutlet var commitStatusImage: UIImageView!

    @IBOutlet var centerView: UIView!
    var profilePictureURL:URLRequest!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()
    let circleLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    var pulsatingLayer : CAShapeLayer!
    var streak = 0
    var hasCommited = false
    var timer :Timer!
    var counter = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var nodes:[CalendarNode] = []
    var currentDay:Date!


    override func viewWillAppear(_ animated: Bool) {
        counterActivtyIndicator.startAnimating()
        imageViewActivityIndicator.startAnimating()
        hasCommited = userDefaults.bool(forKey: DefaultStrings.hasCommited)
        CommitManager.updateHasCommited()
        NotificationCenter.default.addObserver(self, selector: #selector(internetAlertError), name: NotificationName.internetErrorNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadDefaults), name: NotificationName.loadDefaults, object: nil)
        
        if hasCommited == false {

        }
        load()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)

        username = UserDefaults.standard.string(forKey: "username")
        pulsatingLayer = CAShapeLayer()

    }
    override func viewWillDisappear(_ animated: Bool) {
        CoreDataStack.saveStreak(streak: self.streak)
    }
    @objc func loadDefaults() {
        CoreDataStack.getUsername(completion: { username in
            self.usernameLabel.text = username
            self.username = username
        })
        CoreDataStack.getStreak(completion: {streak in
            self.streak =  streak
            self.counterLabel.text = String(streak)
        })
        let coreDataNodes = CoreDataStack.returnSavedNodes()
        for node in coreDataNodes {
            let newNode = CalendarNode(date: node.date ?? Date(), commitStatus: node.commitStatus, commitCount: Int(node.commitCount))
            self.nodes.append(newNode)
        }
        usernameLabel.text = self.username
        counterLabel.text = String(self.streak)
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
            self.usernameLabel.text = self.username

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
                        self.counterLabel.text = String(self.streak)
                        self.drawCircles()
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
        profilePictureImageView.layer.cornerRadius = 50
        profilePictureImageView.clipsToBounds = true
        view.applyMotion(toView: profilePictureImageView, magnitude: 10)
        view.applyMotion(toView: usernameLabel, magnitude: 10)
        view.applyMotion(toView: commitStatusImage, magnitude: 10)

        //  profilePictureImageView.layer.borderWidth = 3
        //  profilePictureImageView.layer.borderColor = UIColor(red: 31/255, green: 105/255, blue: 240/255, alpha: 1).cgColor

        //   trackLayer.shadowOffset = CGSize(width: 10, height: 20)
        // trackLayer.shadowColor = UIColor.black.cgColor
        // trackLayer.shadowRadius = 6
        //   trackLayer.shadowOpacity = 1
        //        counterLabel.shadowColor = UIColor.gray
        //        counterLabel.shadowOffset = CGSize(width: 10, height: 15)
        CoreDataStack.getUserProfilePhoto(completion: {
            image in self.profilePictureImageView.image = image
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

    @objc func updateData() {

        if username != nil {
            if counter < 5 {
                NetworkingProvider.getCurrentStreakFor(username: username) { (streakCount) in
                    self.commitSetup()
                    self.counterLabel.text = String(streakCount)
                    self.streak = streakCount
                    self.counterActivtyIndicator.isHidden = true
                }
            } else if counter == 2 {
                UIView.animate(withDuration: 5) {
                    self.pulsatingLayer.strokeColor = UIColor.clear.cgColor
                    self.pulsatingLayer.fillColor = UIColor.blue.cgColor
                    // self.drawCircles()
                }
            } else {
                stopPulsing()
                timer.invalidate()
            }
        }
        print(counter)
        counter += 1
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

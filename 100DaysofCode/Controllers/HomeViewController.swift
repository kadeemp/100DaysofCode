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
    @IBOutlet var commitStatusImage: UIImageView!
    @IBOutlet var commitStatusLabel: UILabel!



    var counterView: CView!
    var userDefaults = UserDefaults.standard
    var username:String!
    var downloader = ImageDownloader()


    var nodes:[CommitNode] = []
    var currentDay:Date!


    override func viewWillAppear(_ animated: Bool) {
        counterActivtyIndicator.startAnimating()
        imageViewActivityIndicator.startAnimating()
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width/2
        profilePictureImageView.layer.borderWidth = 2
        profilePictureImageView.layer.borderColor = UIColor.white.cgColor
        profilePictureImageView.af_setImage(withURL: Auth.auth().currentUser!.photoURL!)
        NotificationCenter.default.addObserver(self, selector: #selector(internetAlertError), name: NotificationName.internetErrorNote, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadDefaults), name: NotificationName.loadDefaults, object: nil)

        imageViewActivityIndicator.isHidden = true
        counterActivtyIndicator.isHidden = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewSetup()
        counterView.counterLabel.layer.opacity = 0
        counterView.shadowLayer.opacity = 0

        commitStatusLabel.font = UIFont(name: "Marion", size: 22)
        greetingLabel.font = UIFont(name: "Marion", size: 33)
        
        if Auth.auth().currentUser != nil {
            updateStreak()
            FirebaseController.instance.returnUserInfo(category: FirebaseUserKeys.firstName, completion: {(name)  in
                self.greetingLabel.text = "Hello \(name)"
            }
            )

        }
        username = UserDefaults.standard.string(forKey: "username")
    }


    func animateTrackShadow() {

        counterView.triggerStreakLoadAnim()


//
//        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .repeat, animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
//                self.counterView.shadowLayer.shadowColor = UIColor.clear.cgColor
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
//                self.counterView.shadowLayer.shadowColor = UIColor.red.cgColor
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.50, relativeDuration: 0.25, animations: {
//
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
//                self.counterView.shadowLayer.shadowColor = UIColor.blue.cgColor
//            })
//
//        })
    }
    func scrollViewSetup() {
        let scrollerView = UIScrollView(frame:  CGRect(x: 0, y: 0, width: self.view.frame.width, height: (self.view.frame.height) * 0.8))
        scrollerView.contentSize = CGSize(width: 250, height: 600)
        scrollerView.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        scrollerView.delegate = self

        counterView = CView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        counterView.center = CGPoint(x: scrollerView.bounds.midX, y: scrollerView.bounds.midY)
        counterView.counterLabel.text = "0"
        
        self.view.addSubview(scrollerView)
        scrollerView.addSubview(counterView)


    }

    @IBAction func test(_ sender: Any) {
        animateTrackShadow()
    }
    func updateStreak() {

            NetworkingProvider.returnCommitData(completion: { (hasCommited, streak, nodes) in
                FirebaseController.instance.returnUserStreak(completion: { (lastStreak) in
                    if streak > lastStreak {
                        FirebaseController.instance.updateStreak(streak: streak)
                        self.counterView.setStreak(streak)
                    }
                    else {
                        self.counterView.setStreak(lastStreak)

                    }
                })
                if hasCommited {
                    self.commitStatusImage.image = UIImage(named: "Circled Green Check")
                } else {
                    self.commitStatusImage.image = UIImage(named: "Circled Red X")

                }
            })
        
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
                updateStreak()
                counterView.streakLayer.opacity = 0
                UIView.animate(withDuration: 1) {
                    self.counterView.shadowLayer.opacity = 0
                    self.counterView.counterLabel.layer.opacity = 0
                }

            }
        }

        override func viewWillDisappear(_ animated: Bool) {
            CoreDataStack.saveStreak(streak: counterView.streak)
        }
        @objc func loadDefaults() {
            CoreDataStack.getUsername(completion: { username in


                self.username = username
            })
            CoreDataStack.getStreak(completion: {streak in
                self.counterView.streak =  streak
                //            self.counterLabel.text = String(streak)
            })
            let coreDataNodes = CoreDataStack.returnSavedNodes()
            for node in coreDataNodes {
                self.nodes.append(node)
            }

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
                           self.counterView.streak = streak
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



        var animator = UIViewPropertyAnimator(duration: 5, curve: .easeInOut)
        @IBAction func US(_ sender: Any) {

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
            //circleLayer.add(basicAnimation, forKey: "StrokeEnd")
        }

        func animatePulsatingLayer(_ speed:Int?) {

            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = 1.09
            animation.fromValue = 1
            animation.duration = 2
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity

        }
        func stopPulsing(){
            animator.addAnimations {

            }
            animator.addAnimations {

            }
            animator.addAnimations {
            }

            animator.startAnimation()
        }
}

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

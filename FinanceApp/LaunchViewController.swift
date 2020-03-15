//
//  LaunchViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 06/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    let topWidth: CGFloat = 210
    let middleWidth: CGFloat = 140
    let partHeight: CGFloat = 70
    let spaceHeight: CGFloat = 30
    
    var topLogo: UIImageView!
    var topLogoExtra: UIImageView!
    var middleLogo: UIImageView!
    var middleLogoExtra: UIImageView!
    var bottomLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let singleTapSelector = #selector(self.openHomePage)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: singleTapSelector)
        view.addGestureRecognizer(singleTap)
        
        createImageViews()
        showImageViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createImageViews() {
        let boundsTop = CGRect(x: (self.view.frame.width / 2) - (self.topWidth / 2), y: (view.frame.height / 2) - ((partHeight * 1.5) + spaceHeight), width: partHeight, height: partHeight)
        topLogo = UIImageView(frame: boundsTop)
        topLogo.image = UIImage(named: "logo")
        topLogo.layer.cornerRadius = partHeight / 2
        topLogo.clipsToBounds = true
        topLogo.tintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0)
        topLogo.alpha = 0
        view.addSubview(topLogo)
        
        let boundsTopExtra = CGRect(x: (self.view.frame.width / 2) - (self.topWidth / 2), y: (view.frame.height / 2) - ((partHeight * 1.5) + spaceHeight), width: partHeight, height: partHeight)
        topLogoExtra = UIImageView(frame: boundsTopExtra)
        topLogoExtra.image = UIImage(named: "logo")
        topLogoExtra.layer.cornerRadius = partHeight / 2
        topLogoExtra.clipsToBounds = true
        topLogoExtra.tintColor = Colors.Blue
        topLogoExtra.alpha = 0
        view.addSubview(topLogoExtra)
        
        let boundsMiddle = CGRect(x: (self.view.frame.width / 2) - (self.topWidth / 2), y: (view.frame.height / 2) - (partHeight / 2), width: partHeight, height: partHeight)
        middleLogo = UIImageView(frame: boundsMiddle)
        middleLogo.image = UIImage(named: "logo")
        middleLogo.layer.cornerRadius = partHeight / 2
        middleLogo.clipsToBounds = true
        middleLogo.tintColor = UIColor(red:0.83, green:0.83, blue:0.83, alpha:1.0)
        middleLogo.alpha = 0
        view.addSubview(middleLogo)
        
        let boundsMiddleExtra = CGRect(x: (self.view.frame.width / 2) - (self.topWidth / 2), y: (view.frame.height / 2) - (partHeight / 2), width: partHeight, height: partHeight)
        middleLogoExtra = UIImageView(frame: boundsMiddleExtra)
        middleLogoExtra.image = UIImage(named: "logo")
        middleLogoExtra.layer.cornerRadius = partHeight / 2
        middleLogoExtra.clipsToBounds = true
        middleLogoExtra.tintColor = Colors.Blue
        middleLogoExtra.alpha = 0
        view.addSubview(middleLogoExtra)
        
        let boundsBottom = CGRect(x: (self.view.frame.width / 2) - (self.topWidth / 2), y: (view.frame.height / 2) + (partHeight / 2) + spaceHeight, width: partHeight, height: partHeight)
        bottomLogo = UIImageView(frame: boundsBottom)
        bottomLogo.image = UIImage(named: "logo")
        bottomLogo.layer.cornerRadius = partHeight / 2
        bottomLogo.clipsToBounds = true
        bottomLogo.tintColor = Colors.Blue
        bottomLogo.alpha = 0
        view.addSubview(bottomLogo)
    }
    
    func showImageViews() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topLogo.alpha = 1
            self.topLogoExtra.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                self.middleLogo.alpha = 1
                self.middleLogoExtra.alpha = 1
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
                    self.bottomLogo.alpha = 1
                }, completion: { _ in
                    self.animateMiddle()
                    let bounds = self.topLogo.frame
                    let boundsExtra = self.topLogoExtra.frame
                    UIView.animate(withDuration: 0.3, animations: {
                        self.topLogo.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: self.topWidth, height: bounds.size.height)
                        self.topLogoExtra.frame = CGRect(x: boundsExtra.origin.x + self.topWidth - self.partHeight, y: boundsExtra.origin.y, width: boundsExtra.size.width, height: boundsExtra.size.height)
                    }, completion: nil)
                })
            })
        })
    }
    
    func animateMiddle() {
        self.animateBottom()
        let bounds = middleLogo.frame
        let boundsExtra = middleLogoExtra.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.middleLogo.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: self.middleWidth, height: bounds.size.height)
            self.middleLogoExtra.frame = CGRect(x: boundsExtra.origin.x + self.middleWidth - self.partHeight, y: boundsExtra.origin.y, width: boundsExtra.size.width, height: boundsExtra.size.height)
        }, completion: nil)
    }
    
    func animateBottom() {
        let bounds = bottomLogo.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomLogo.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: self.partHeight, height: bounds.size.height)
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.openHomePage()
            }
        })
    }
    
    @objc func openHomePage() {
        let newViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let newView = UIView(frame: newViewFrame)
        newView.backgroundColor = .white
        newView.alpha = 0
        self.view.addSubview(newView)
        UIView.animate(withDuration: 0.1, animations: {
            newView.alpha = 1
        }, completion: {_ in
            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            homePage.modalPresentationStyle = .overCurrentContext
            homePage.modalTransitionStyle = .crossDissolve
            self.present(homePage, animated: true, completion: nil)
        })
    }

}

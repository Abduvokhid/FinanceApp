//
//  HomePageViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 04/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var firstItem: UIView!
    @IBOutlet weak var secondItem: UIView!
    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var fourthItem: UIView!
    
    @IBOutlet weak var firstConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabBar: UIView!
    
    var currentItem: UIView!
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMenuSize()
        
        firstItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.firstButtonPressed(_:))))
        secondItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.secondButtonPressed(_:))))
        thirdItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.thirdButtonPressed(_:))))
        fourthItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.fourthButtonPressed(_:))))
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        buttonPressed(sender: firstItem)
        view.bringSubviewToFront(pageControl)
        
        let sel = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let sele = #selector(self.closeKeyboard)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: sele)
        view.addGestureRecognizer(tap)
    }
    
    func setMenuSize(){
        let width = self.view.frame.width
        let per = CGFloat(width / 4)
        let last = width - (per * 3)
        firstConstraint.constant = per
        secondConstraint.constant = per
        thirdConstraint.constant = per
        fourthConstraint.constant = last
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (!KB.isOpen){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if (KB.keyBoardHeight == -1) {
                    KB.keyBoardHeight = keyboardSize.origin.y - keyboardSize.height -
                        (tabBar.frame.height)
                }
            }
            var tabBarFrame: CGRect = (tabBar.frame)
            if (KB.defaultLoc == -1) {
                KB.defaultLoc = tabBarFrame.origin.y
            }
            tabBarFrame.origin.y = KB.keyBoardHeight
            tabBar.frame = tabBarFrame
            KB.isOpen = true
        }
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
        if (KB.isOpen){
            var tabBarFrame: CGRect = (tabBar.frame)
            tabBarFrame.origin.y = KB.defaultLoc
            tabBar.frame = tabBarFrame
            KB.isOpen = false
        }
    }
    
    @objc func firstButtonPressed(_ sender: UITapGestureRecognizer) {
        moveScroll(sender: firstItem)
        buttonPressed(sender: firstItem)
    }
    
    @objc func secondButtonPressed(_ sender: UITapGestureRecognizer) {
        moveScroll(sender: secondItem)
        buttonPressed(sender: secondItem)
    }
    
    @objc func thirdButtonPressed(_ sender: UITapGestureRecognizer) {
        moveScroll(sender: thirdItem)
        buttonPressed(sender: thirdItem)
    }
    
    @objc func fourthButtonPressed(_ sender: UITapGestureRecognizer) {
        moveScroll(sender: fourthItem)
        buttonPressed(sender: fourthItem)
    }
    
    func moveScroll(sender: UIView){
        scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(sender.tag - 1), y: scrollView.contentOffset.y), animated: true)
    }
    
    func buttonPressed(sender: UIView) {
        undoCurrent()
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                if let title = sender.viewWithTag(20) as? UILabel {
                    title.textColor = .black
                }
                if let image = sender.viewWithTag(10) as? UIImageView {
                    image.tintColor = .black
                }
                sender.transform = CGAffineTransform.identity
            })
        })
        currentItem = sender
    }
    
    func undoCurrent() {
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            if self.currentItem != nil {
                if let title = self.currentItem.viewWithTag(20) as? UILabel {
                    title.textColor = .lightGray
                }
                if let image = self.currentItem.viewWithTag(10) as? UIImageView {
                    image.tintColor = .lightGray
                }
            }
        })
    }
    
    func createSlides() -> [Slide] {
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "imageOne")
        slide1.label.text = "A real-life bear"
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "imageTwo")
        slide2.label.text = "A real-life bear"
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "imageThree")
        slide3.label.text = "A real-life bear"
        
        let slide4:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide4.imageView.image = UIImage(named: "imageFour")
        slide4.label.text = "A real-life bear"
        
        return [slide1, slide2, slide3, slide4]
    }

    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch (pageControl.currentPage + 1) {
        case 1:
            buttonPressed(sender: firstItem)
        case 2:
            buttonPressed(sender: secondItem)
        case 3:
            buttonPressed(sender: thirdItem)
        case 4:
            buttonPressed(sender: fourthItem)
        default:
            break
        }
    }
    
    /*
     * default function called when view is scrolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        //let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        //let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        //let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        //let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        //let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        //let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        /*let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }*/
    }
}

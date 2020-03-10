//
//  HomePageViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 04/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    
    static var parentController: UIViewController! = nil
    
    let transition = CircularTransition()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var firstItem: UIView!
    @IBOutlet weak var secondItem: UIView!
    @IBOutlet weak var thirdItem: UIView!
    @IBOutlet weak var fourthItem: UIView!
    
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var helpButtonShadowView: UIView!
    
    @IBOutlet weak var firstConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabBarConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabBar: UIView!
    
    var currentItem: UIView!
    
    var isOpen = false
    var tabBarConstant: CGFloat = -1
    static var extraPoint: CGFloat = 0
    
    var slides:[Slide] = [];
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (HomePageViewController.parentController == nil) {
            HomePageViewController.parentController = self
        }
        
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
        
        let keyboardSelector = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: keyboardSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let singleTapSelector = #selector(self.closeKeyboard)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: singleTapSelector)
        view.addGestureRecognizer(singleTap)
        
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.3
        
        helpButton.layer.cornerRadius = 25
        helpButtonShadowView.layer.cornerRadius = 25
        
        helpButtonShadowView.layer.shadowRadius = 5
        helpButtonShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        helpButtonShadowView.layer.shadowOpacity = 0.5
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
        if (!isOpen){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if (tabBarConstant == -1) {
                    var constant = keyboardSize.origin.y - keyboardSize.height - (tabBar.frame.height)
                    constant = (constant - tabBar.frame.origin.y) * -1
                    tabBarConstant = constant
                    HomePageViewController.extraPoint = constant + 100
                }
            }
            tabBarConstraint.constant = tabBarConstant
            view.layoutIfNeeded()
            isOpen = true
            let current = slides[pageControl!.currentPage]
            current.keyboardOpened()
        }
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
        if (isOpen){
            closeKeyboardAll()
            tabBarConstraint.constant = 0
            view.layoutIfNeeded()
            isOpen = false
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
    
    func closeKeyboardAll() {
        for slide in slides {
            slide.keyboardClosed()
        }
    }
    
    func buttonPressed(sender: UIView) {
        closeKeyboard()
        undoCurrent()
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                if let title = sender.viewWithTag(20) as? UILabel {
                    title.textColor = UIColor(red:0.24, green:0.45, blue:0.87, alpha:1.0)
                }
                if let image = sender.viewWithTag(10) as? UIImageView {
                    image.tintColor = UIColor(red:0.24, green:0.45, blue:0.87, alpha:1.0)
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
        
        let slide1:Slide = Bundle.main.loadNibNamed("MortgageView", owner: self, options: nil)?.first as! Slide
        let slide2:Slide = Bundle.main.loadNibNamed("LoanView", owner: self, options: nil)?.first as! Slide
        let slide3:Slide = Bundle.main.loadNibNamed("SavingView", owner: self, options: nil)?.first as! Slide
        let slide4:Slide = Bundle.main.loadNibNamed("CompoundView", owner: self, options: nil)?.first as! Slide
        
        return [slide1, slide2, slide3, slide4]
    }

    func setupSlideScrollView(slides : [UIView]) {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //
    //
    // This part is created to animate help page view opening
    //
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! HelpPageViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = helpButton.center
        transition.circleColor = .white
        //transition.circleColor = helpButton.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = helpButton.center
        transition.circleColor = helpButton.backgroundColor!
        
        return transition
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//
//  HomePageViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 04/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIScrollViewDelegate {
    
    // As all pages are shown inside this view as a subview, it is impossible to call methods of this class from its children. So this static value is used to store reference to parent (current) class instance
    static var parentController: HomePageViewController! = nil
    
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
    
    @IBOutlet weak var tabBarConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tabBar: UIView!
    
    var currentItem: UIView!
    
    // These variables are used to store settings about keyboard status and settings
    var isOpen = false
    var tabBarConstant: CGFloat = -1
    static var extraPoint: CGFloat = 0
    
    // This array stores all views used and shown in this current page (View Controller)
    var slides:[Slide] = [];
    
    // Setting status bar to light (white) style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If instance of current controller is not set previously, it is stored in static variable
        if (HomePageViewController.parentController == nil) {
            HomePageViewController.parentController = self
        }
        
        // Setting menu size depending on the phone model (basically screen size)
        setMenuSize()
        
        // Adding tap gesture recognizers for all 4 buttons of the menu
        firstItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.firstButtonPressed(_:))))
        secondItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.secondButtonPressed(_:))))
        thirdItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.thirdButtonPressed(_:))))
        fourthItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.fourthButtonPressed(_:))))
        
        // Setting current class instance as scrollView delegate to create and use necessary methods of ScrollView
        scrollView.delegate = self
        
        // Generating 4 slide instances to show in scroll view of the current page
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        // Using page control item to store information about slides and current open slide
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        
        // Making first slide opened by default when application is opened
        buttonPressed(sender: firstItem)
        
        // Sending pageControl to the back to make it invisible for user as it is not needed
        view.bringSubviewToFront(pageControl)
        
        // Creating observer to be notified when keyboard is shown. It is used to move menu (tab bar) while keyboard is open
        let keyboardSelector = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: keyboardSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // Current tap gesture recognizer is used to close the keyboard when user presses to any part of the screen
        let singleTapSelector = #selector(self.closeKeyboard)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: singleTapSelector)
        view.addGestureRecognizer(singleTap)
        
        // Setting shadow for menu (tab bar)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.3
        
        // Opening current page with transition to make opening smooth
        openTransition()
    }
    
    // This method is used to create white view on the screen and hide it smoothly. It makes the current page to open smoothly
    func openTransition(){
        let newViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let newView = UIView(frame: newViewFrame)
        newView.backgroundColor = .white
        newView.alpha = 1
        self.view.addSubview(newView)
        UIView.animate(withDuration: 0.1, animations: {
            newView.alpha = 0
        }, completion: {_ in
            newView.isHidden = true
            newView.removeFromSuperview()
        })
    }
    
    // This method is setting menu bar and button sizes according to the screen size
    func setMenuSize(){
        let width = self.view.frame.width
        let per = CGFloat(width / 4)
        let last = width - (per * 3)
        firstConstraint.constant = per
        secondConstraint.constant = per
        thirdConstraint.constant = per
        fourthConstraint.constant = last
    }
    
    // This method is called when keyboard is opened. Here menu bar is moved to the top of keyboard when keyboard is opened
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
    
    // This method is called when user moved to another page or tapped to any random place of the screen
    @objc func closeKeyboard(){
        view.endEditing(true)
        if (isOpen){
            closeKeyboardAll()
            tabBarConstraint.constant = 0
            view.layoutIfNeeded()
            isOpen = false
        }
    }
    
    // These 4 methods are used to move slider to the necessary slide when user presses button from the menu
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
    
    // This method is moving the view to necessary point according to the user scroll
    func moveScroll(sender: UIView){
        scrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(sender.tag - 1), y: scrollView.contentOffset.y), animated: true)
    }
    
    // This method is closing keyboard for all views (slides)
    func closeKeyboardAll() {
        for slide in slides {
            slide.keyboardClosed()
        }
    }
    
    // This method is called when user presses any button from the menu. It is changing text and image color of the chosen menu item
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
    
    // This method is changing previously selected item style to default
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
    
    // This method is creating instance of all 4 pages and returning as a list of slides
    func createSlides() -> [Slide] {
        let slide1:Slide = Bundle.main.loadNibNamed("MortgageView", owner: self, options: nil)?.first as! Slide
        let slide2:Slide = Bundle.main.loadNibNamed("LoanView", owner: self, options: nil)?.first as! Slide
        let slide3:Slide = Bundle.main.loadNibNamed("MonthlySavingView", owner: self, options: nil)?.first as! Slide
        let slide4:Slide = Bundle.main.loadNibNamed("LumpSumSavingView", owner: self, options: nil)?.first as! Slide
        
        return [slide1, slide2, slide3, slide4]
    }

    // This method is adding each generated slide instance to the main view (technically to the scroll view inside main view)
    func setupSlideScrollView(slides : [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    // This method is called when user stops scrolling. Based on the scroll point, necessary menu item's style is changed
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
    
    // This method is changing current active page information when user scrolls the view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
}

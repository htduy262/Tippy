//
//  ViewController.swift
//  Tippy
//
//  Created by Duy Huynh Thanh on 9/20/16.
//  Copyright © 2016 Duy Huynh Thanh. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var adBanner: GADBannerView!
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var groupSlider: UISlider!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var numberOfMemberLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var viewFinal: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    @IBOutlet weak var viewFinalTopConstrain: NSLayoutConstraint!
    
    var timerPacman = Timer()
    let defaults = UserDefaults.standard
    let tipPercentageArray = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3]
    var currentCurrencyLable = ""
    var totalAmount:Double = 0
    var numberOfMember:Int = 2
    var oldTipPercentage:Int = 0
    var pacmanFlag = 1
    var savedDistance:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //timerPacman = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(pacmanChange), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        // TextField
        billField.layer.cornerRadius = 0
        billField.layer.borderWidth = 1
        billField.layer.borderColor = UIColor(colorLiteralRed: 227/255, green: 227/255, blue: 227/255, alpha: 1).cgColor
        
        // Color for navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 0, green: 145/255, blue: 146/255, alpha: 1)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 0, green: 143/255, blue: 85/255, alpha: 1),
            NSFontAttributeName: UIFont(name: "Avenir Next", size: 24)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        // Thumb image for slider
        tipSlider.setThumbImage(UIImage(named: "pacman1"), for: UIControlState.normal)
        tipSlider.setThumbImage(UIImage(named: "pacman1"), for: UIControlState.highlighted)
        groupSlider.setThumbImage(UIImage(named: "group4inch"), for: UIControlState.normal)
        groupSlider.setThumbImage(UIImage(named: "group4inch"), for: UIControlState.highlighted)
        if self.view.frame.height < 667 {
            groupSlider.setThumbImage(UIImage(named: "group4inch"), for: UIControlState.normal)
            groupSlider.setThumbImage(UIImage(named: "group4inch"), for: UIControlState.highlighted)
        }
        else {
            groupSlider.setThumbImage(UIImage(named: "group"), for: UIControlState.normal)
            groupSlider.setThumbImage(UIImage(named: "group"), for: UIControlState.highlighted)
        }
        
        // Load default settings
        let tipPercentage = defaults.integer(forKey: "TIP_PERCENTAGE_INDEX")
        print("TIP_PERCENTAGE_INDEX = \(tipPercentage)")
        tipSlider.value = Float(tipPercentageArray[tipPercentage]) * 100
        oldTipPercentage = Int(tipSlider.value)
        tipPercentageLabel.text = "Tip \(Int(tipSlider.value)) %"
        groupSlider.value = 2
        numberOfMemberLabel.text = "Split to 2 people"
        
        // Load ads
        adBanner.adUnitID = "ca-app-pub-8801439798856966/5867909131"
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
    
    func appMovedToBackground() {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        if let currencyLabel = defaults.string(forKey: "CURRENCY_LABEL") {
            print("CURRENCY_LABEL = \(currencyLabel)")
            currentCurrencyLable = currencyLabel
        }
        else {
            currentCurrencyLable = "$"
        }
        
        // Always calculate bill
        calculateBill(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if savedDistance == 0 {
            savedDistance = viewBottom.frame.height
            
            // Focus on bill field
            billField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Make end editing
    @IBAction func tapAction(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func billAmountChanged(_ sender: AnyObject) {
        calculateBill(self)
    }
    
    @IBAction func calculateBill(_ sender: AnyObject) {
        
        if (billField.text != "" && Double (billField.text!) == nil) {
            billField.backgroundColor = UIColor(colorLiteralRed: 1, green: 200/255, blue: 200/255, alpha: 1)
        }
        else {
            billField.backgroundColor = UIColor(colorLiteralRed: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        }
        
        let bill = Double (billField.text!) ?? 0
        let tip = bill * Double(tipSlider.value) / 100
        totalAmount = bill + tip
        
        tipLabel.pushTransition(duration: 0.4)
        tipLabel.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, tip)
        
        totalLabel.pushTransition(duration: 0.4)
        totalLabel.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount)
        
        updateFinalAmountLabel()
    }
    
    func updateFinalAmountLabel() {
        finalAmount.pushTransition(duration: 0.4)
        finalAmount.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / Double(Int(groupSlider.value)))
    }
    
    @IBAction func tipPercentageChanged(_ sender: AnyObject) {
        
        tipSlider.setValue((Float)((Int)((tipSlider.value + 2.5) / 5) * 5), animated: true)
        
        tipPercentageLabel.text = "Tip \(Int(tipSlider.value)) %"
        
        if billField.text == "" {
            return
        }
    }
    
    @IBAction func beginChangeTipPercentage(_ sender: AnyObject) {
        timerPacman = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(pacmanChange), userInfo: nil, repeats: true)
    }
    @IBAction func endChangeTipPercentage(_ sender: AnyObject) {
        timerPacman.invalidate()
        
        if oldTipPercentage != Int(tipSlider.value) {
            oldTipPercentage = Int(tipSlider.value)
            calculateBill(self)
        }
    }
    
    @IBAction func numberOfMemberChanged(_ sender: AnyObject) {
        numberOfMemberLabel.text = "Split to \(Int(groupSlider.value)) people"
        
        if billField.text == "" {
            return
        }
    }
    
    @IBAction func endChangeNumberOfMember(_ sender: AnyObject) {
        if billField.text != "" && numberOfMember != Int(groupSlider.value) {
            numberOfMember = Int(groupSlider.value)
            updateFinalAmountLabel()
        }
    }
    
    
    @IBAction func plusTouched(_ sender: AnyObject) {
        tipSlider.value = tipSlider.value + 1
        
        pacmanChange()
        
        if tipSlider.value > 30 {
            tipSlider.value = 30
        }
        
        tipPercentageLabel.text = "Tip \(Int(tipSlider.value)) %"
        
        if billField.text != "" {
            calculateBill(self)
        }
    }
    
    @IBAction func minusTouched(_ sender: AnyObject) {
        tipSlider.value = tipSlider.value - 1
        
        pacmanChange()
        
        if tipSlider.value < 0 {
            tipSlider.value = 0
        }
        
        tipPercentageLabel.text = "Tip \(Int(tipSlider.value)) %"
        
        if billField.text != "" {
            calculateBill(self)
        }
    }
    
    internal func keyboardWillShow(notification: NSNotification) {
        if let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1, animations: {
                self.viewFinalTopConstrain.constant += -keyboard.height + self.savedDistance
                self.view.layoutIfNeeded()
            })
        }
    }
    
    internal func keyboardWillHide(notification: NSNotification) {
        if let keyboard = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 1, animations: {
                self.viewFinalTopConstrain.constant += keyboard.height - self.savedDistance
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func pacmanChange() {
        tipSlider.setThumbImage(UIImage(named: "pacman\(pacmanFlag)"), for: UIControlState.normal)
        tipSlider.setThumbImage(UIImage(named: "pacman\(pacmanFlag)"), for: UIControlState.highlighted)
        pacmanFlag += 1
        if pacmanFlag > 8 {
            pacmanFlag = 1
        }
    }
}

extension UIView {
    func pushTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionPush)
    }
}

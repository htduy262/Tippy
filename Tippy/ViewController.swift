//
//  ViewController.swift
//  Tippy
//
//  Created by Duy Huynh Thanh on 9/20/16.
//  Copyright © 2016 Duy Huynh Thanh. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var adBanner: GADBannerView!
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var groupSlider: UISlider!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var numberOfMemberLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var number2Label: UILabel!
    @IBOutlet weak var number3Label: UILabel!
    @IBOutlet weak var number4Label: UILabel!
    @IBOutlet weak var number5Label: UILabel!
    @IBOutlet weak var number6Label: UILabel!
    @IBOutlet weak var divedBy2Label: UILabel!
    @IBOutlet weak var divedBy3Label: UILabel!
    @IBOutlet weak var divedBy4Label: UILabel!
    @IBOutlet weak var divedBy5Label: UILabel!
    @IBOutlet weak var divedBy6Label: UILabel!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    
    let defaults = UserDefaults.standard
    let tipPercentageArray = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3]
    var currentCurrencyLable = ""
    var totalAmount:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // TextField delegate
        billField.delegate = self
        
        // Color for navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 0, green: 145/255, blue: 146/255, alpha: 1)
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor(colorLiteralRed: 0, green: 143/255, blue: 85/255, alpha: 1),
            NSFontAttributeName: UIFont(name: "Avenir Next", size: 24)!
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        // Focus on bill field
        billField.becomeFirstResponder()
        
        // Thumb image for slider
        tipSlider.setThumbImage(UIImage(named: "thumb"), for: UIControlState.normal)
        tipSlider.setThumbImage(UIImage(named: "thumb"), for: UIControlState.highlighted)
        groupSlider.setThumbImage(UIImage(named: "thumb"), for: UIControlState.normal)
        groupSlider.setThumbImage(UIImage(named: "thumb"), for: UIControlState.highlighted)
        
        // Load default settings
        let tipPercentage = defaults.integer(forKey: "TIP_PERCENTAGE_INDEX")
        print("TIP_PERCENTAGE_INDEX = \(tipPercentage)")
        tipSlider.value = Float(tipPercentageArray[tipPercentage]) * 100
        tipPercentageLabel.text = "\(Int(tipSlider.value)) %"
        groupSlider.value = 2
        numberOfMemberLabel.text = "2"
        
        // Load ads
        adBanner.adUnitID = "ca-app-pub-8801439798856966/5867909131"
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
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
            billField.layer.borderColor = UIColor(colorLiteralRed: 240/255, green: 70/255, blue: 40/255, alpha: 1).cgColor
            billField.layer.borderWidth = 1.0;
            billField.layer.cornerRadius = 5.0;
            
            billField.backgroundColor = UIColor(colorLiteralRed: 1, green: 200/255, blue: 200/255, alpha: 1)
        }
        else {
            billField.layer.borderColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
            billField.backgroundColor = UIColor.white
        }
        
        let bill = Double (billField.text!) ?? 0
        let tip = bill * Double(tipSlider.value) / 100
        totalAmount = bill + tip
        
        tipLabel.pushTransition(duration: 0.4)
        tipLabel.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, tip)
        
        totalLabel.pushTransition(duration: 0.4)
        divedBy2Label.pushTransition(duration: 0.4)
        divedBy3Label.pushTransition(duration: 0.4)
        divedBy4Label.pushTransition(duration: 0.4)
        divedBy5Label.pushTransition(duration: 0.4)
        divedBy6Label.pushTransition(duration: 0.4)
        
        totalLabel.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount)
        
        let numberOfMember:Int = Int(numberOfMemberLabel.text!)!
        
        switch numberOfMember {
        case 1:
            number2Label.text = "2"
            number3Label.text = "3"
            number4Label.text = "4"
            number5Label.text = "5"
            number6Label.text = "6"
            
            divedBy2Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 2)
            divedBy3Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 3)
            divedBy4Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 4)
            divedBy5Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 5)
            divedBy6Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 6)
            break;
        case 2, 3, 4, 5, 6, 7, 8, 9, 10:
            number2Label.text = String(Int(groupSlider.value))
            number3Label.text = String(Int(groupSlider.value + 1))
            number4Label.text = String(Int(groupSlider.value + 2))
            number5Label.text = String(Int(groupSlider.value + 3))
            number6Label.text = String(Int(groupSlider.value + 4))
            
            divedBy2Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / Double(numberOfMember))
            divedBy3Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / Double(numberOfMember + 1))
            divedBy4Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / Double(numberOfMember + 2))
            divedBy5Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / Double(numberOfMember + 3))
            divedBy6Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / Double(numberOfMember + 4))
            break;
        case 11, 12, 13, 14, 15:
            number2Label.text = "11"
            number3Label.text = "12"
            number4Label.text = "13"
            number5Label.text = "14"
            number6Label.text = "15"
            
            divedBy2Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 11)
            divedBy3Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 12)
            divedBy4Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 13)
            divedBy5Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 14)
            divedBy6Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, totalAmount / 15)
            break;
        default:
            print("Á \(groupSlider.value)")
            break;
        }
    }
    
    @IBAction func tipPercentageChanged(_ sender: AnyObject) {
        tipSlider.setValue((Float)((Int)((tipSlider.value + 2.5) / 5) * 5), animated: true)
        
        tipPercentageLabel.text = "\(Int(tipSlider.value)) %"
        
        if billField.text == "" {
            return
        }
        
        Thread.cancelPreviousPerformRequests(withTarget: self, selector: #selector(calculateBill), object: nil)
        self.perform(#selector(calculateBill), with: self, afterDelay: 0.7)
        
    }
    
    @IBAction func numberOfMemberChanged(_ sender: AnyObject) {
        groupSlider.value = groupSlider.value
        numberOfMemberLabel.text = "\(Int(groupSlider.value))"
        
        if billField.text == "" {
            return
        }
        
        Thread.cancelPreviousPerformRequests(withTarget: self, selector: #selector(calculateBill), object: nil)
        self.perform(#selector(calculateBill), with: self, afterDelay: 0.7)
    }
    
    @IBAction func plusTouched(_ sender: AnyObject) {
        tipSlider.value = tipSlider.value + 1
        
        if tipSlider.value > 30 {
            tipSlider.value = 30
        }
        
        tipPercentageLabel.text = "\(Int(tipSlider.value)) %"
        
        if billField.text != "" {
            calculateBill(self)
        }
    }
    
    @IBAction func minusTouched(_ sender: AnyObject) {
        tipSlider.value = tipSlider.value - 1
        
        if tipSlider.value < 0 {
            tipSlider.value = 0
        }
        
        tipPercentageLabel.text = "\(Int(tipSlider.value)) %"
        
        if billField.text != "" {
            calculateBill(self)
        }
    }
    
    @IBAction func groupButtonTouched(_ sender: AnyObject) {
        groupSlider.value = 1
        numberOfMemberLabel.text = "1"
        
        if billField.text != "" {
            calculateBill(self)
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

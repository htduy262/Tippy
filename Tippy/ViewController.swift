//
//  ViewController.swift
//  Tippy
//
//  Created by Duy Huynh Thanh on 9/20/16.
//  Copyright © 2016 Duy Huynh Thanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var divedBy2Label: UILabel!
    @IBOutlet weak var divedBy3Label: UILabel!
    @IBOutlet weak var divedBy4Label: UILabel!
    @IBOutlet weak var divedBy5Label: UILabel!
    @IBOutlet weak var divedBy6Label: UILabel!

    let defaults = UserDefaults.standard
    let tipPercentageArray = [0, 0.05, 0.1, 0.15, 0.2, 0.25]
    var currentCurrencyLable = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Color for navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor(colorLiteralRed: 0, green: 145/255, blue: 146/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(colorLiteralRed: 0, green: 143/255, blue: 85/255, alpha: 1)]
        
        // Focus on bill field
        billField.becomeFirstResponder()
        
        // Load default settings
        let tipPercentage = defaults.integer(forKey: "TIP_PERCENTAGE_INDEX")
        print("TIP_PERCENTAGE_INDEX = \(tipPercentage)")
        tipControl.selectedSegmentIndex = tipPercentage
        
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
    
    @IBAction func calculateBill(_ sender: AnyObject) {
        let bill = Double (billField.text!) ?? 0
        let tip = bill * tipPercentageArray[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.pushTransition(duration: 0.4)
        totalLabel.pushTransition(duration: 0.4)
        divedBy2Label.pushTransition(duration: 0.4)
        divedBy3Label.pushTransition(duration: 0.4)
        divedBy4Label.pushTransition(duration: 0.4)
        divedBy5Label.pushTransition(duration: 0.4)
        divedBy6Label.pushTransition(duration: 0.4)
        
        tipLabel.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, tip)
        totalLabel.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, total)
        divedBy2Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, total / 2)
        divedBy3Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, total / 3)
        divedBy4Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, total / 4)
        divedBy5Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, total / 5)
        divedBy6Label.text = String(format: "\(currentCurrencyLable) %.2f", locale: Locale.current, total / 6)
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

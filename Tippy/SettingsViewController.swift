//
//  SettingsViewController.swift
//  Tippy
//
//  Created by Duy Huynh Thanh on 9/20/16.
//  Copyright © 2016 Duy Huynh Thanh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var currencyField: UITextField!

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //UIFont(name: "HelveticaNeue-Bold", size: 11.0)
//        let attributes = [
//            NSFontAttributeName : UIFont(name: "Arial", size: 11.0)
//        ] as [String : Any]
//        tipControl.setTitleTextAttributes(attributes, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tipPercentage = defaults.integer(forKey: "TIP_PERCENTAGE_INDEX")
        print("TIP_PERCENTAGE_INDEX = \(tipPercentage)")
        tipControl.selectedSegmentIndex = tipPercentage
        
        if let currencyLabel = defaults.string(forKey: "CURRENCY_LABEL") {
            print("CURRENCY_LABEL = \(currencyLabel)")
            currencyField.text = currencyLabel
        }
        else {
            currencyField.text = "$"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if currencyField.text == "" {
            currencyField.text = "$"
        }
        defaults.set(currencyField.text, forKey: "CURRENCY_LABEL")
        defaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tapAction(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    var oldText = ""
    @IBAction func changedText(_ sender: AnyObject) {
        if (currencyField.text?.characters.count)! > 3 {
            currencyField.text = oldText
            return
        }
        
        oldText = currencyField.text!
    }
    
    @IBAction func endEditCurrency(_ sender: AnyObject) {
        if currencyField.text == "" {
            currencyField.text = "$"
        }
        defaults.set(currencyField.text, forKey: "CURRENCY_LABEL")
        defaults.synchronize()
    }
    
    @IBAction func changedTipPercentage(_ sender: AnyObject) {
        defaults.set(tipControl.selectedSegmentIndex, forKey: "TIP_PERCENTAGE_INDEX")
        defaults.synchronize()
    }
    
}

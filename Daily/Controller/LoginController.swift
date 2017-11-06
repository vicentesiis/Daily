//
//  ViewController.swift
//  Daily
//
//  Created by Vicente Cantu Garcia on 18/10/17.
//  Copyright © 2017 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    let picker: [String] = ["White","Yellow","Blue","Red","Orange","Purple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTextField.delegate = self
        self.passTextField.delegate = self
        colorPicker.delegate = self
        colorPicker.isHidden = true
        if let colorData = UserDefaults.standard.object(forKey: "color") as? Data{
            if let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor{
                self.view.backgroundColor = color
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    @IBAction func colorsPressed(_ sender: Any) {
        colorPicker.isHidden = false
    }
    
    @IBAction func buttonLoginPressed(_ sender: Any) {
        if let userData = KeychainWrapper.standard.data(forKey: "userName"){
            if let userArray = NSKeyedUnarchiver.unarchiveObject(with: userData) as? [String]{
                if userArray.contains(userTextField.text!){
                    let index = userArray.index(of: userTextField.text!)
                    if let passData = KeychainWrapper.standard.data(forKey: "password"){
                        if let passArray = NSKeyedUnarchiver.unarchiveObject(with: passData) as? [String]{
                            let pass = passArray[index!]
                            if pass == passTextField.text!{
                                UserInformation.instance.registerUser(user: userTextField.text!)
                                performSegue(withIdentifier: "momentsSegue", sender: Any?.self)
                            }else{
                                sendAlert(title: "Error", message: "UserName or password is incorrect")
                            }
                        }
                    }
                }else{
                    sendAlert(title: "Error", message: "UserName or password is incorrect")
                }
            }
        }else{
            sendAlert(title: "Error", message: "No users registers")
        }
    }
    
    // MARK: - Alert at user
    func sendAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.placeholder?.contains("Username"))! && textField.text != ""{
            passTextField.becomeFirstResponder()
        }else if (textField.placeholder?.contains("Password"))! && textField.text != "" {
            textField.resignFirstResponder()
            buttonLoginPressed(Any.self)
        }else{
            return false
        }
        return true
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let color = picker[row]
        switch color {
        case "White":
            self.view.backgroundColor = UIColor.white
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.white)
            UserDefaults.standard.set(colorData, forKey: "color")
        case "Yellow":
            self.view.backgroundColor = UIColor.yellow
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.yellow)
            UserDefaults.standard.set(colorData, forKey: "color")
        case "Blue":
            self.view.backgroundColor = UIColor.blue
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.blue)
            UserDefaults.standard.set(colorData, forKey: "color")
        case "Red":
            self.view.backgroundColor = UIColor.red
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.red)
            UserDefaults.standard.set(colorData, forKey: "color")
        case "Orange":
            self.view.backgroundColor = UIColor.orange
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.orange)
            UserDefaults.standard.set(colorData, forKey: "color")
        case "Purple":
            self.view.backgroundColor = UIColor.purple
            let colorData = NSKeyedArchiver.archivedData(withRootObject: UIColor.purple)
            UserDefaults.standard.set(colorData, forKey: "color")
        default:
            print("WUT")
        }
        colorPicker.isHidden = true
    }
}

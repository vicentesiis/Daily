//
//  RegisterController.swift
//  Daily
//
//  Created by Vicente Cantu Garcia on 18/10/17.
//  Copyright © 2017 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import CoreData

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTextField.delegate = self
        passTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        userTextField.becomeFirstResponder()
        if let colorData = UserDefaults.standard.object(forKey: "color") as? Data{
            if let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor{
                self.view.backgroundColor = color
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let placeholder = textField.placeholder!
        if placeholder.contains("Username") && userTextField.text != ""{
            passTextField.becomeFirstResponder()
        }else if placeholder.contains("Password") && passTextField.text != ""{
            nameTextField.becomeFirstResponder()
        }else if placeholder.contains("Name") && nameTextField.text != ""{
            emailTextField.becomeFirstResponder()
        }else if placeholder.contains("Email") && emailTextField.text != ""{
            textField.resignFirstResponder()
            buttonRegisterPressed(Any.self)
        }else{
            return false
        }
        return true
    }
    
    // MARK: - IBActions
    @IBAction func buttonRegisterPressed(_ sender: Any) {
        if userTextField.text != "" && passTextField.text != ""{
            saveData(userName: userTextField.text!, password: passTextField.text!)
        }else{
            let alert = UIAlertController(title: "Error", message: "The userName and the password is required!!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveData(userName: String, password: String){
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        let managedObject = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        var val = 0
        if let userDataLoad = KeychainWrapper.standard.data(forKey: "userName"){
            if var userArray = NSKeyedUnarchiver.unarchiveObject(with: userDataLoad) as? [String]{
                if !userArray.contains(userName){
                    userArray.append(userName)
                    let userDataSave = NSKeyedArchiver.archivedData(withRootObject: userArray)
                    KeychainWrapper.standard.set(userDataSave, forKey: "userName")
                    managedObject.setValue(userName, forKey: "userName")
                    val += 1
                }else{
                    let alert = UIAlertController(title: "Error", message: "\(userName) already exists!!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }else{
            let userArray = [userName]
            let userDataSave = NSKeyedArchiver.archivedData(withRootObject: userArray)
            KeychainWrapper.standard.set(userDataSave, forKey: "userName")
            managedObject.setValue(userName, forKey: "userName")
            val += 1
        }
        if let passDataLoad = KeychainWrapper.standard.data(forKey: "password"){
            if var passArray = NSKeyedUnarchiver.unarchiveObject(with: passDataLoad) as? [String]{
                passArray.append(password)
                let passDataSave = NSKeyedArchiver.archivedData(withRootObject: passArray)
                KeychainWrapper.standard.set(passDataSave, forKey: "password")
                managedObject.setValue(password, forKey: "password")
                val += 1
            }else{
                let _ = KeychainWrapper.standard.removeAllKeys()
                let alert = UIAlertController(title: "Error", message: "All users been deleted for a problem in the system", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let passArray = [password]
            let passDataSave = NSKeyedArchiver.archivedData(withRootObject: passArray)
            KeychainWrapper.standard.set(passDataSave, forKey: "password")
            managedObject.setValue(password, forKey: "password")
            val += 1
        }
        if val == 2{
            if let name = nameTextField.text{
                managedObject.setValue(name, forKey: "name")
            }else{
                managedObject.setValue("-", forKey: "name")
            }
            if let email = emailTextField.text{
                managedObject.setValue(email, forKey: "email")
            }else{
                managedObject.setValue("-", forKey: "email")
            }
            do {
                try managedContext.save()
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

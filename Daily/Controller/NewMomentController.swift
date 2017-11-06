//
//  NewMomentController.swift
//  Daily
//
//  Created by Vicente Cantu Garcia on 19/10/17.
//  Copyright © 2017 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import CoreData
import SwiftKeychainWrapper
import MobileCoreServices

class NewMomentController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var imageToSave: UIImageView!
    
    var moment: Moment?
    var editMoment: Bool = false
    let managerContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        if let colorData = UserDefaults.standard.object(forKey: "color") as? Data{
            if let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor{
                self.view.backgroundColor = color
            }
        }
        if let text = moment?.text{
            textViewDescription.text! = text
        }
        if let imageData = moment?.image{
            if let image = UIImage(data: imageData as Data){
                imageToSave.image = image
            }
        }
        if moment?.image == nil{
            if  UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                imagePicker.setEditing(true, animated: true)
                self.present(imagePicker, animated: true, completion: nil)
            }else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.mediaTypes = [kUTTypeImage as String]
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func deleteAllPressed(_ sender: Any) {
        let fetchRequests = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let arrayManagedObjects = try managerContext.fetch(fetchRequests)
            for dict in arrayManagedObjects{
                managerContext.delete(dict)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        let fetchRequestso = NSFetchRequest<NSManagedObject>(entityName: "Moment")
        do {
            let arrayManagedObjects = try managerContext.fetch(fetchRequestso)
            for dict in arrayManagedObjects{
                managerContext.delete(dict)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        do {
            try managerContext.save()
            let _ = KeychainWrapper.standard.removeAllKeys()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    @IBAction func buttonSavePressed(_ sender: Any) {
        if !editMoment{
            let user: User = User(context: managerContext)
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "userName == %@", UserInformation.instance.userRegistered())
            do {
                let userData = try managerContext.fetch(fetchRequest)
                for attribute in userData{
                    user.userName = attribute.userName
                    user.password = attribute.password
                    user.name = attribute.name
                    user.email = attribute.email
                }
            } catch (let error) {
                print(error)
            }
            let entityMoment = NSEntityDescription.entity(forEntityName: "Moment", in: managerContext)
            let moment = Moment(entity: entityMoment!, insertInto: managerContext)
            moment.text = textViewDescription.text!
            moment.user = user
            moment.date = NSDate()
            if let image = imageToSave.image{
                if let dataImage = UIImageJPEGRepresentation(image, 1){
                    moment.image = dataImage as NSData?
                }
            }
            do {
                try managerContext.save()
                let alert = UIAlertController(title: "Success", message: "The moment has been saved", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self.performSegue(withIdentifier: "unWindToTableView", sender: Any?.self)
                }))
                present(alert, animated: true, completion: nil)
            } catch (let error) {
                print(error.localizedDescription)
            }
        }else{
            moment?.text = textViewDescription.text!
            moment?.date = NSDate()
            if let image = imageToSave.image{
                if let dataImage = UIImageJPEGRepresentation(image, 1){
                    moment?.image = dataImage as NSData?
                }
            }
            do {
                try managerContext.save()
                editMoment = false
                let alert = UIAlertController(title: "Success", message: "The moment has been saved", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self.performSegue(withIdentifier: "unWindToTableView", sender: Any?.self)
                }))
                present(alert, animated: true, completion: nil)
            } catch (let error) {
                print(error)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        self.dismiss(animated: true, completion: nil)
        if mediaType == kUTTypeImage as String{
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
                self.imageToSave.image = image
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
                self.imageToSave.image = image
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}

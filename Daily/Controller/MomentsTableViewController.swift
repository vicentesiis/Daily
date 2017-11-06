//
//  MomentsTableViewController.swift
//  Daily
//
//  Created by Vicente Cantu Garcia on 19/10/17.
//  Copyright © 2017 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import CoreData

class MomentsTableViewController: UITableViewController {
    
    var moments = [Moment]()
    let managerContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let colorData = UserDefaults.standard.object(forKey: "color") as? Data{
            if let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor{
                self.view.backgroundColor = color
            }
        }
        loadMoments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMoment", for: indexPath) as! MomentsTableViewCell
        let moment = moments[indexPath.row]
        cell.momentLabel.text = moment.date?.description
        if let imageData = moment.image{
            if let image = UIImage(data: imageData as Data){
                cell.momentImage.image = image
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moment = moments[indexPath.row]
        performSegue(withIdentifier: "momentSegue", sender: moment as Moment)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "momentSegue"{
            let newMomentVC = segue.destination as? NewMomentController
            newMomentVC?.moment = sender as? Moment
            newMomentVC?.editMoment = true
        }
    }
    
    @IBAction func unWindToTableView(segue: UIStoryboardSegue){
        loadMoments()
    }
    
    func loadMoments() {
        let fetchRequest = NSFetchRequest<Moment>(entityName: "Moment")
        fetchRequest.predicate = NSPredicate(format: "user.userName == %@", UserInformation.instance.userRegistered())
        do {
            let moments = try managerContext?.fetch(fetchRequest)
            self.moments = moments!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}

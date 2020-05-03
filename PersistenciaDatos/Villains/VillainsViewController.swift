//
//  VillainsViewController.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class VillainsViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var villains: [Villain] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Villains", comment: "")
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.villains = CoreDataManager.shared.getVillains()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VillainsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.villains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.villains[indexPath.row].name
        return cell
    }
}

extension VillainsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterViewController = CharacterDetailViewController(character: self.villains[indexPath.row])
        
        self.navigationController?.pushViewController(characterViewController, animated: true)
    }
    
}

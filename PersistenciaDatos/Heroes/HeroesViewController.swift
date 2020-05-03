//
//  HeroesViewController.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit
import CoreData

class HeroesViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var heroes: [Hero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Heroes", comment: "")
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.heroes = CoreDataManager.shared.getHeroes()
        
        let nib = UINib.init(nibName: "CharacterTableViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "CharacterCell")
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

extension HeroesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        cell.setCharacter(self.heroes[indexPath.row])
        return cell
    }
}


extension HeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = CharacterDetailViewController(character: self.heroes[indexPath.row]) {
            self.table.reloadData()
        }
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

//
//  BattlesViewController.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class BattlesViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var battles: [Battle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self

        self.title = NSLocalizedString("Battles", comment: "")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        self.battles = CoreDataManager.shared.getBattles()
    }

    @objc func plusButtonTapped() {
        let createBattleController = CreateBattleViewController(battleCreatedCallback: ({
            self.battles = CoreDataManager.shared.getBattles()
            self.table.reloadData()
        }))
        self.navigationController?.present(createBattleController, animated: true, completion: nil)
    }

}

extension BattlesViewController: UITableViewDelegate {
    
}

extension BattlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.battles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let battle = self.battles[indexPath.row]
        let heroName = battle.hero?.name ?? "Unknown"
        let villainName = battle.villain?.name ?? "Unknown"
        
        cell.textLabel?.text = "Battle \(battle.id)"
        cell.detailTextLabel?.text = "\(heroName) vs \(villainName)"
        
        cell.imageView?.image = UIImage(named: battle.winner == battle.hero ? "ic_tab_heroes" : "ic_tab_villain")?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = (battle.hero == battle.winner) ? .blue : .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
        let deleteAction = UIContextualAction(style: .normal, title: deleteTitle) { (myContext, myView, complete) in
            let battle = self.battles[indexPath.row]
            CoreDataManager.shared.delete(battle)
            self.battles = CoreDataManager.shared.getBattles()
            self.table.reloadData()
            complete(true)
        }
        
        let actionsConfiguration = UISwipeActionsConfiguration(actions: [
            deleteAction
        ])
        
        return actionsConfiguration
    }
}

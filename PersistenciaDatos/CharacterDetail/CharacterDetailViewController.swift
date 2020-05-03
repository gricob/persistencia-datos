//
//  CharacterDetailViewController.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    var character: Character?
    var battles: [Battle] = []
    private var edited: (() -> Void)?
    
    @IBOutlet weak var battlesTable: UITableView!
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var powerImage: UIImageView!
    
    convenience init(character: Character, edited: (() -> Void)?) {
        self.init(nibName: "CharacterDetailViewController", bundle: nil)
        
        self.character = character
        self.battles = CoreDataManager.shared.getBattles(ofCharacter: character)
        self.edited = edited
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setUpView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonTapped))
        
        self.battlesTable.dataSource = self
        self.infoTable.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBattleListChanged), name: .battleListUpdated, object: nil)
    }
    func setUpView() {
        self.title = self.character?.name
        
        if let image = self.character?.image {
            self.image.image = UIImage(named: image)
        }
        
        if let power = self.character?.power {
            self.powerImage.image = UIImage(named: "ic_stars_\(power)")
        }
    }
    
    @objc func didBattleListChanged() {
        guard let character = self.character else { return }
        
        self.battles = CoreDataManager.shared.getBattles(ofCharacter: character)
        self.battlesTable.reloadData()
    }

    @objc func editButtonTapped(_ sender: Any) {
        guard let character = self.character else { return }
        
        let editPowerViewController = EditPowerViewController(withCharacter: character) {
            self.setUpView()
            
            self.edited?()
        }
        
        self.present(editPowerViewController, animated: true, completion: nil)
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        let selected = sender.selectedSegmentIndex
        
        self.infoTable.isHidden = selected != 0
        self.battlesTable.isHidden = selected != 1
    }
}

extension CharacterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.battlesTable) {
            return self.battles.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.battlesTable) {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            let battle = self.battles[indexPath.row]
            let heroName = battle.hero?.name ?? "Unknown"
            let villainName = battle.villain?.name ?? "Unknown"
            let resultText = self.character == battle.winner ? "Victory" : "Defeat"
            
            cell.textLabel?.text = "Battle \(battle.id) - \(resultText)"
            cell.detailTextLabel?.text = "\(heroName) vs \(villainName)"
            
            cell.imageView?.image = UIImage(named: battle.winner == battle.hero ? "ic_tab_heroes" : "ic_tab_villain")?.withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = (battle.hero == battle.winner) ? .blue : .red
            
            return cell
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.character?.desc
        
        return cell
    }
    
    
}

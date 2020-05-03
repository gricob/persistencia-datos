//
//  CreateBattleViewController.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class CreateBattleViewController: UIViewController {

    @IBOutlet weak var charactersPicker: UIPickerView!
    @IBOutlet weak var villainPicker: UIPickerView!
    @IBOutlet weak var fightButton: UIButton!
    
    var heroes: [Hero] = []
    var villains: [Villain] = []
    
    var battleCreatedCallback: (() -> Void)?
    
    convenience init(battleCreatedCallback: (() -> Void)?) {
        self.init()
        
        self.battleCreatedCallback = battleCreatedCallback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.charactersPicker.dataSource = self
        self.charactersPicker.delegate = self
        self.charactersPicker.selectRow(0, inComponent: 0, animated: false)
        self.charactersPicker.selectRow(0, inComponent: 1, animated: false)
        
        self.heroes = CoreDataManager.shared.getHeroes()
        self.villains = CoreDataManager.shared.getVillains()
        
        self.fightButton.titleLabel?.text = NSLocalizedString("Fight", comment: "")
    }


    @IBAction func fightButtonTapped(_ sender: Any) {
        let heroIndex = self.charactersPicker.selectedRow(inComponent: 0)
        let villainIndex = self.charactersPicker.selectedRow(inComponent: 1)
        

        CoreDataManager.shared.createBattle(hero: self.heroes[heroIndex], villain: self.villains[villainIndex])
        
        self.battleCreatedCallback?()
        
        self.dismiss(animated: true, completion: nil)
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

extension CreateBattleViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? self.heroes.count : self.villains.count
    }
}

extension CreateBattleViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? self.heroes[row].name : self.villains[row].name
    }
}

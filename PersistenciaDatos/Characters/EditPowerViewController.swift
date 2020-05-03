//
//  EditPowerViewController.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class EditPowerViewController: UIViewController {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var power1Button: UIButton!
    @IBOutlet weak var power2Button: UIButton!
    @IBOutlet weak var power3Button: UIButton!
    @IBOutlet weak var power4Button: UIButton!
    @IBOutlet weak var power5Button: UIButton!
    
    var character: Character?
    
    private var saved: (() -> Void)?
    
    var power: Int16 = 0 {
        didSet {
            updatePowerButtons()
        }
    }
    
    convenience init(withCharacter character: Character, confirmed: (() -> Void)?) {
        self.init(nibName: "EditPowerViewController", bundle: nil)
        self.character = character
        self.saved = confirmed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let character = self.character else { return }
        
        if let img = character.image {
            self.characterImage.image = UIImage(named: img)
        }
        
        characterName.text = self.character?.name
        self.power = character.power
    }
    
    func updatePowerButtons() {
        let starImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        
        self.power1Button.setImage(self.power >= 1 ? starFillImage : starImage, for: .normal)
        self.power2Button.setImage(self.power >= 2 ? starFillImage : starImage, for: .normal)
        self.power3Button.setImage(self.power >= 3 ? starFillImage : starImage, for: .normal)
        self.power4Button.setImage(self.power >= 4 ? starFillImage : starImage, for: .normal)
        self.power5Button.setImage(self.power == 5 ? starFillImage : starImage, for: .normal)
    }

    @IBAction func powerButtonTapped(_ sender: UIButton) {
        self.power = Int16(sender.tag)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.character?.power = self.power
        
        self.saved?()
        
        self.dismiss(animated: true, completion: nil)
    }
}

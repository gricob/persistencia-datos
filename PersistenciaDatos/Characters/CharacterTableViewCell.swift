//
//  CharacterTableViewCell.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterPower: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setCharacter(_ character: Character) {
        if let image = character.image {
            self.characterImage.image = UIImage(named: image)
        }
        
        self.characterName.text = character.name
        self.characterPower.image = UIImage(named: "ic_stars_\(character.power)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

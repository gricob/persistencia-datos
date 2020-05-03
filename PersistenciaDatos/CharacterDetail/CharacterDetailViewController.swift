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
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var powerImage: UIImageView!
    @IBOutlet weak var biographyLabel: UILabel!
    @IBOutlet weak var biographyContent: UILabel!
    
    convenience init(character: Character) {
        self.init(nibName: "CharacterDetailViewController", bundle: nil)
        
        self.character = character
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.character?.name
        
        if let image = self.character?.image {
            self.image.image = UIImage(named: image)
        }
        
        if let power = self.character?.power {
            self.powerImage.image = UIImage(named: "ic_stars_\(power)")
        }
        
        self.biographyLabel.text = NSLocalizedString("Biography", comment: "")
        
        if let biography = self.character?.desc {
            self.biographyContent.text = biography
        }
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

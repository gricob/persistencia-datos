//
//  CoreDataManager.swift
//  PersistenciaDatos
//
//  Created by Gerardo Rico Botella on 03/05/2020.
//  Copyright © 2020 Gerardo Rico Botella. All rights reserved.
//

import UIKit
import CoreData

enum EntityType: String {
    case Hero = "Hero"
    case Villain = "Villain"
    case Battle = "Battle"
}

extension Notification.Name {
    static let battleListUpdated = Notification.Name("BattleListUpdated")
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var managedObjectContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func delete(_ object: NSManagedObject) {
        guard let context = managedObjectContext else { return }
        
        context.delete(object)
        
        try? context.save()
        
        if (object.isKind(of: Battle.self)) {
            NotificationCenter.default.post(name: .battleListUpdated, object: nil)
        }
    }
    
    func getBattles(ofCharacter character: Character) -> [Battle] {
        guard let context = managedObjectContext else { return [] }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityType.Battle.rawValue)
        fetchRequest.predicate = NSPredicate(format: "hero = %@ OR villain = %@", character, character)
        
        guard let battles = try? context.fetch(fetchRequest) else {
            return []
        }
        
        return battles as! [Battle]
    }
    
    func createBattle(hero: Hero, villain: Villain) {
        guard
            let context = managedObjectContext,
            let entityBattle = NSEntityDescription.entity(forEntityName: "Battle", in: context)
        else {
            return
        }
        
        let lastBattleId = self.getLastBattle()?.id ?? 0
        
        let id = lastBattleId + 1
        let winner = self.getWinner(hero: hero, villain: villain)
        
        let battleObject = NSManagedObject(entity: entityBattle, insertInto: context)
        battleObject.setValue(id, forKey: "id")
        battleObject.setValue(hero, forKey: "hero")
        battleObject.setValue(villain, forKey: "villain")
        battleObject.setValue(winner, forKey: "winner")
        
        try? context.save()
        
        NotificationCenter.default.post(name: .battleListUpdated, object: nil)
    }
    
    func getLastBattle() -> Battle? {
        guard let context = managedObjectContext else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EntityType.Battle.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        return try? context.fetch(fetchRequest).first as? Battle
    }
    
    private func getWinner(hero: Hero, villain: Villain) -> Character {
        let max = Int(hero.power + villain.power)
        return Int.random(in: 1...max) <= hero.power ? hero : villain
    }
    
    func getBattles() -> [Battle] {
        return self.getAll(ofType: .Battle, sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
    }
    
    func getHeroes() -> [Hero] {
        return self.getAll(ofType: .Hero)
    }
    
    func getVillains() -> [Villain] {
        return self.getAll(ofType: .Villain)
    }
    
    private func getAll<T>(ofType type: EntityType, sortDescriptors: [NSSortDescriptor] = []) -> [T] {
        guard let context = managedObjectContext else { return [] }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: type.rawValue)
        fetchRequest.sortDescriptors = sortDescriptors
        
        guard let objects = try? context.fetch(fetchRequest) else {
            return []
        }
        
        return objects as! [T]
    }
    
    func load() -> Void {
        saveCharacter(type: .Hero, name: "Captain Marvel", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 5, image: "img_heroe_marvel_captain")
        saveCharacter(type: .Hero, name: "Captain America", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 4, image: "img_heroe_america_captain")
        saveCharacter(type: .Hero, name: "Black Panther", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 3, image: "img_heroe_black_panther")
        saveCharacter(type: .Hero, name: "Black Widow", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 3, image: "img_heroe_black_widow")
        saveCharacter(type: .Hero, name: "Doctor Strange", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 5, image: "img_heroe_dr_strange")
        
        
        saveCharacter(type: .Villain, name: "Ego", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 5, image: "img_villain_ego")
        saveCharacter(type: .Villain, name: "Hela", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 4, image: "img_villain_hela")
        saveCharacter(type: .Villain, name: "Ivan vanko", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 2, image: "img_villain_ivan_vanko")
        saveCharacter(type: .Villain, name: "Thanos", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", power: 4, image: "img_villain_thanos")
    }
    
    func saveCharacter(type: EntityType, name: String, description: String, power: Int8, image: String) -> Void {
        guard
            let context = managedObjectContext,
            let entityCharacter = NSEntityDescription.entity(forEntityName: type.rawValue, in: context)
        else {
            return
        }
        
        let characterObject = NSManagedObject(entity: entityCharacter, insertInto: context)
        characterObject.setValue(name, forKey: "name")
        characterObject.setValue(description, forKey: "desc")
        characterObject.setValue(power, forKey: "power")
        characterObject.setValue(image, forKey: "image")
        
        try? context.save()
    }
}

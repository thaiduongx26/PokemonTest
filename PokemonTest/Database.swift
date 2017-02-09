//
//  Database.swift
//  PokemonTest
//
//  Created by Thai Duong on 2/8/17.
//  Copyright © 2017 Thai Duong. All rights reserved.
//

import Foundation
import FMDB
import SQLite
class Database {
    let queryString = "select id, name, tag, gen, img, color from pokemon"
    
    static var defaults: Database {
        get {
            return Database()
        }
    }
    private var database: FMDatabase!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        database = FMDatabase(path: appDelegate.pathDocument())
    }
    
    //get amount data
    func getAmountData() -> Int! {
        var count = 0
        guard database.open() else {
            print("Unable to open database")
            return nil
        }
        do {
            let results = try database.executeQuery(queryString, values: nil)
            while results.next() {
                count += 1
            }
        } catch let error {
            print("error: \(error.localizedDescription)")
            return nil
        }
        
        guard database.close() else {
            print("Unable to close databse")
            return nil
        }
        return count
    }
    
    //get pokemon from database
    func getDataPokemon(index: String) -> Pokemon? {
        var pokemon: Pokemon?
        guard database.open() else {
            print("Unable to open database")
            return nil
        }
        
        do {
            let results = try database.executeQuery(queryString + " where id = " + index, values: nil)
            while results.next() {
                //                print("name: " + results.string(forColumn: "name"))
                pokemon = Pokemon(id: results.string(forColumn: "id"),
                                  name: results.string(forColumn: "name"),
                                  tag: results.string(forColumn: "tag"),
                                  gen: results.string(forColumn: "gen"),
                                  imageName: results.string(forColumn: "img"),
                                  color: results.string(forColumn: "color"))
            }
        } catch let error {
            print("error: \(error.localizedDescription)")
            return nil
        }
        guard database.close() else {
            print("Unable to close databse")
            return nil
        }
        return pokemon
    }
    
    
    //get 3 name pokemon incorrect
    func getIncorrectName(index: String, count: Int) -> [String]? {
        var names: [String] = []
        guard database.open() else {
            print("Unable to open database")
            return nil
        }
        var i = 0
        while i < 3 {
            let c = Int(arc4random()) % count + 1
            if "\(c)" != index {
                i += 1
                do {
                    let result = try database.executeQuery("select id, name from pokemon where id = " + "\(c)", values: nil)
                    while result.next() {
                        names.append(result.string(forColumn: "name"))
                    }
                    
                } catch let error as NSError {
                    print("error: \(error.description)")
                    return nil
                }
            }
        }
        
        guard database.close() else {
            print("Unable to close databse")
            return nil
        }
        
        return names
    }
}

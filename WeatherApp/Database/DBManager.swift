//
//  DBManager.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import Foundation
import RealmSwift

class DBManager {
    
    public var database:Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    //
    //    func getDataFromDB(objs: [Object]) -> Results<Object> {
    //
    //        let results: Results<Object> = database.objects(objs.self)
    //        return results
    //    }
    
    
    func getObjects(type: Object.Type) -> Results<Object>? {
        //return database.objects(type)
        
        let results: Results<Object> = database.objects(type)
        print("Get Objects")
        return results
    }
    
    
    func addData(objs: [Object]) {
        try! database.write {
            database.add(objs,update: .modified)
            print("Added new object")
        }
    }
    
    func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
            // database.refresh();
            print("Delete all database")
        }
    }
    
    func deleteFromDb(object: [Object]) {
        try! database.write {
            database.delete(object)
            print("Delete from database")
        }
    }
    
}

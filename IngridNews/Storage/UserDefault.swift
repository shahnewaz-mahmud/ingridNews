//
//  UserDefault.swift
//  IngridNews
//
//  Created by BJIT on 1/17/23.
//

import Foundation

class UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    
    func saveData(userInfo: User, key: String){
        let encoder = JSONEncoder()
        let data = try? encoder.encode(userInfo)
        
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getSavedData(key: String) -> User?{
        guard let fetchedData = UserDefaults.standard.data(forKey: Constants.userDefaultsUser) else { return nil }
        let decoder = JSONDecoder()
        let userInfo = try? decoder.decode(User.self, from: fetchedData)
        return userInfo
        
    }
    
    func removeSavedData(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }

}

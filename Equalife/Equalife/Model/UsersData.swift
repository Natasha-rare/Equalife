//
//  UsersData.swift
//  UsersData
//
//  Created by Kostya Bunsberry on 28.07.2021.
//

import Foundation

class UsersData {
    static public var shared = UsersData()
    
    private let kHaveAlreadyLaunched = "UsersData.kHaveAlreadyLaunched"
    
    var haveAlreadyLaunched: Bool? {
        get { return UserDefaults.standard.bool(forKey: kHaveAlreadyLaunched) }
        set { UserDefaults.standard.set(newValue, forKey: kHaveAlreadyLaunched) }
    }
}

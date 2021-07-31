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
    private let kDidAlreadyGoToMain = "UsersData.kDidAlreadyGoToMain"
    
    var haveAlreadyLaunched: Bool? {
        get { return UserDefaults.standard.bool(forKey: kHaveAlreadyLaunched) }
        set { UserDefaults.standard.set(newValue, forKey: kHaveAlreadyLaunched) }
    }
    
    var didAlreadyGoToMain: Bool? {
        get { return UserDefaults.standard.bool(forKey: kDidAlreadyGoToMain) }
        set { UserDefaults.standard.set(newValue, forKey: kDidAlreadyGoToMain) }
    }
}

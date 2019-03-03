//
//  UserDefaultsHelper.swift
//  ALC_RB
//
//  Created by ayur on 27.02.2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    
    let userKey = "authUser"
    let userDefaults = UserDefaults.standard
    
    func userIsAuthorized() -> Bool {
        do {
            let user = try self.userDefaults.get(objectType: AuthUser.self, forKey: userKey)
            if user != nil {
                return true
            }
        } catch {
            print("Some error with getting user from UserDefaults")
        }
        return false
    }
    
    func getAuthorizedUser() -> AuthUser? {
        do {
            let user = try self.userDefaults.get(objectType: AuthUser.self, forKey: userKey)
            return user
        } catch {
            print("Some error with getting user from UserDefaults")
        }
        return nil
    }
    
    func setAuthorizedUser(user: AuthUser) -> Bool {
        do {
            try userDefaults.set(object: user, forKey: userKey)
            return true
        } catch {
            print("Somer error with setting user in UserDefaults")
        }
        return false
    }
    
    func deleteAuthorizedUser() {
        userDefaults.removeObject(forKey: userKey)
    }
    
}

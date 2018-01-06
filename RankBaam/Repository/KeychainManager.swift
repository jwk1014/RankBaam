//
//  KeychainManager.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class SignManager {
    static let ACCOUNT_KEY = "ACCOUNT_KEY"
    static var keychain: SignForm? {
        get {
            if  let data = KeychainWrapper.standard.data(forKey: ACCOUNT_KEY),
                let signFrom = try? JSONDecoder().decode(SignForm.self, from: data){
                return signFrom
            }
            return nil
        }
        set {
            if  let newValue = newValue,
                let data = try? JSONEncoder().encode(newValue) {
                KeychainWrapper.standard.set(data, forKey: ACCOUNT_KEY)
            }
        }
    }
}

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
    static var keychain: SignData? {
        get {
            if  let data = KeychainWrapper.standard.data(forKey: ACCOUNT_KEY),
                let signFrom = try? JSONDecoder().decode(SignData.self, from: data){
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

struct SignData: Codable {
  var type: SignType
  var email: String? = nil
  var identification: String
  
  init(type: SignType, email: String?, identification: String) {
    self.type = type
    self.email = email
    self.identification = identification
  }
  
  init(email: String, identification: String) {
    self.init(type: SignType.email, email: email, identification: identification)
  }
  
  init(type: SignType, identification: String) {
    self.init(type: type, email: nil, identification: identification)
  }
}

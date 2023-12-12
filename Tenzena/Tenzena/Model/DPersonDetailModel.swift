//
//  DPersonDetailModel.swift
//  Las020
//
//  Created by apple on 18/11/2023.
//

import Foundation
class DPersonDetailModel: NSObject {
    var id: Int = 0
    var biography: String = ""
    var birthday: String = ""
    var deathday: String = ""
    var profile_path: String = ""
    
    override init() {
        
    }
    
    init(_ dictionary: DDictionary){
        if let val = dictionary["id"] as? Int{ id = val }
        if let val = dictionary["biography"] as? String{ biography = val }
        if let val = dictionary["birthday"] as? String{ birthday = val }
        if let val = dictionary["deathday"] as? String{ deathday = val }
        if let val = dictionary["profile_path"] as? String{ profile_path = val }
    }
}

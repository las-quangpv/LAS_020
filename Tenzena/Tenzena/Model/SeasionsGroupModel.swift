//
//  SeasionsGroupModel.swift
//  Las020
//
//  Created by apple on 18/11/2023.
//

import Foundation
class SeasionsGroupModel: NSObject {
    var episode_count: Int = 0
    var group_count: Int = 0
    var id: String = ""
    var name: String = ""
    
    override init() {
        
    }
    init(data: [String: Any]){
        if let val = data["episode_count"] as? Int{ episode_count = val }
        if let val = data["group_count"] as? Int{ group_count = val }
        if let val = data["id"] as? String{ id = val }
        if let val = data["name"] as? String{ name = val }
    }
    init(_ dictionary: DDictionary){
        if let val = dictionary["episode_count"] as? Int{ episode_count = val }
        if let val = dictionary["group_count"] as? Int{ group_count = val }
        if let val = dictionary["id"] as? String{ id = val }
        if let val = dictionary["name"] as? String{ name = val }
    }
}

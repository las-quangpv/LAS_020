//
//  SeasonDetailModel.swift
//  Las020
//
//  Created by apple on 18/11/2023.
//

import Foundation
class SeasonDetailModel: NSObject {
    var id: String = ""
    var air_date: String = ""
    var poster_path: String = ""
    var name: String = ""
    var episode_count: Int = 0
    var group_count: Int = 0
    override init() {
        
    }
    
    init(_ dictionary: DDictionary){
        if let val = dictionary["id"] as? String{ id = val }
        if let val = dictionary["air_date"] as? String{ id = val }
        if let val = dictionary["poster_path"] as? String{ id = val }
        if let val = dictionary["name"] as? String{ name = val }
    }
}

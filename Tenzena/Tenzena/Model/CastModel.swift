import Foundation

class CastModel : NSObject{
    var id: Int = 0
    var name: String = ""
    var profile_path: String = ""
    var known_for_department: String = ""
    var gender: Int = 0
    var character: String = ""
    
    override init() {
        
    }
    init(data: [String: Any]){
        if let val = data["id"] as? Int{ id = val }
        if let val = data["name"] as? String{ name = val }
        if let val = data["profile_path"] as? String{ profile_path = val }
        if let val = data["known_for_department"] as? String{ known_for_department = val }
        if let val = data["gender"] as? Int{ gender = val }
        if let val = data["character"] as? String{ character = val }
    }
    init(_ dictionary: DDictionary){
        if let val = dictionary["id"] as? Int{ id = val }
        if let val = dictionary["name"] as? String{ name = val }
        if let val = dictionary["profile_path"] as? String{ profile_path = val }
        if let val = dictionary["known_for_department"] as? String{ known_for_department = val }
        if let val = dictionary["gender"] as? Int{ gender = val }
        if let val = dictionary["character"] as? String{ character = val }
    }
    
}


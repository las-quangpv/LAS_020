import Foundation

class Genres: NSObject{
    var id: Int = 0
    var name: String = ""
    
    override init() {
        
    }
    init(data: [String: Any]){
        if let val = data["id"] as? Int{ id = val }
        if let val = data["name"] as? String{ name = val }
    }
    init(_ dictionary: DDictionary){
        if let val = dictionary["id"] as? Int{ id = val }
        if let val = dictionary["name"] as? String{ name = val }
    }
    
}

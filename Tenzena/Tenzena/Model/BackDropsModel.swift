
import Foundation
class BackDropsModel : NSObject{
    var filePath: String = ""
  
    
    override init() {
        
    }
    init(data: [String: Any]){
        if let val = data["file_path"] as? String{ filePath = val }
    }
    init(_ dictionary: DDictionary){
        if let val = dictionary["file_path"] as? String{ filePath = val }
    }
    
}


import Foundation
let SPACE_SAVE_NOTES = "~!@~"
class NoteModel : NSObject{
    var image: String = ""
    var name: String = ""
    var notes: String = ""
    
    override init() {
        
    }
    init(image: String, name: String, notes: [String]){
        self.image = image
        self.name = name
        self.notes = notes.joined(separator: SPACE_SAVE_NOTES)
        
    }
    
    init(data: [String: Any]) {
        if let val = data["image"] as? String { image = val }
        if let val = data["name"] as? String { name = val }
        if let val = data["notes"] as? String {
            self.notes = val
        }
        
    }
    func toString() -> [String: Any] {
        return ["image": image,
                "name": name,
                "notes": notes]
    }

}
extension NoteModel {
    static func readFromNoteJson() -> [NoteModel] {
        let string = readString(fileName: NAME_NOTE_SAVE)
        if string == nil || string == "" {
            return [NoteModel]()
        }
        let data: [DDictionary] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [NoteModel]()
        for item in data {
            let model = NoteModel(data: item)
            result.append(model)
        }
        return result
    }
}

//
//  DPersonModel.swift
//  Las020
//
//  Created by apple on 18/11/2023.
//

import Foundation

class DPersonModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var profilePath: String = ""
    var listKnownFor: [KnownForModel] = []
    override init() {
        
    }
    
    init(_ dictionary: DDictionary) {
        if let val = dictionary["id"] as? Int { id = val }
        if let val = dictionary["name"] as? String { name = val }
        if let val = dictionary["profile_path"] as? String { profilePath = val }
        if let val = dictionary["known_for"] as? [DDictionary] {
            for item in val {
                let model = KnownForModel(item)
                listKnownFor.append(model)
            }
        }
    }
}
class KnownForModel: NSObject {
    var id: Int = 0
    var backdrop_path: String = ""
    var overview: String = ""
    var genre_ids: [Int] = []
    var vote_average: Double = 0
    var vote_count: Double = 0
    var title: String = ""
    var posterPath: String = ""
    var mediaType: String = ""
    var releaseDate: String = ""
    var original_name: String = ""
    init(_ dictionary: DDictionary) {
        if let val = dictionary["id"] as? Int { id = val }
        if let val = dictionary["title"] as? String { title = val }
        if let val = dictionary["poster_path"] as? String { posterPath = val }
        if let val = dictionary["release_date"] as? String { releaseDate = val }
        if let val = dictionary["media_type"] as? String { mediaType = val }
        if let val = dictionary["backdrop_path"] as? String { backdrop_path = val }
        if let val = dictionary["original_name"] as? String { original_name = val }
        if let val = dictionary["overview"] as? String { overview = val }
        if let val = dictionary["genre_ids"] as? [Int] { genre_ids = val }
        if let val = dictionary["vote_average"] as? Double { vote_average = val }
        if let val = dictionary["vote_count"] as? Double { vote_count = val }

    }
}

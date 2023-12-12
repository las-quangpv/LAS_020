
import UIKit
import Foundation

class DMoviesDetail: NSObject {

    var adult: Bool = false//
    var backdrop_path: String = ""//
    var budget: Int = 0
    var genre_ids: [Int] = [Int]()
    var homepage: String = ""
    var id: Int = 0
    var imdb_id: String = ""
    var original_language: String = ""
    var original_title: String = ""
    var overview: String = ""
    var popularity: Double = 0
    var poster_path: String = ""
    var release_date: String = ""
    var revenue: Int = 0
    var runtime: Int = 0
    var status: String = ""
    var tagline: String = ""
    var title: String = ""
    var video: Bool = false
    var vote_count: Int = 0
    var vote_average: Double = 0
    var isMove: Bool = true
    override init() {
        
    }
    
    init(data: [String: Any]) { 
        if let val = data["vote_count"] as? Int { vote_count = val }
        if let val = data["video"] as? Bool { video = val }
        if let val = data["poster_path"] as? String { poster_path = val }
        if let val = data["homepage"] as? String { homepage = val }
        if let val = data["imdb_id"] as? String { imdb_id = val }
        if let val = data["status"] as? String { status = val }
        if let val = data["tagline"] as? String { tagline = val }
        if let val = data["id"] as? Int { id = val }
        if let val = data["revenue"] as? Int { revenue = val }
        if let val = data["runtime"] as? Int { runtime = val }
        if let val = data["budget"] as? Int { budget = val }
        if let val = data["backdrop_path"] as? String { backdrop_path = val }
        if let val = data["original_language"] as? String { original_language = val }
        if let val = data["original_title"] as? String { original_title = val }
        if let val = data["overview"] as? String { overview = val }
        if let val = data["popularity"] as? Double { popularity = val }
        if let val = data["title"] as? String { title = val }
        if let val = data["vote_average"] as? Double { vote_average = val }
        if let val = data["adult"] as? Bool { adult = val }
        if let val = data["release_date"] as? String { release_date = val }
        if let val = data["genre_ids"] as? [Int] { genre_ids = val }
        if let val = data["isMove"] as? Bool { isMove = val }
    }
    
    init(_ dictionary: DDictionary) {
        if let val = dictionary["vote_count"] as? Int { vote_count = val }
        if let val = dictionary["video"] as? Bool { video = val }
        if let val = dictionary["poster_path"] as? String { poster_path = val }
        if let val = dictionary["homepage"] as? String { homepage = val }
        if let val = dictionary["imdb_id"] as? String { imdb_id = val }
        if let val = dictionary["status"] as? String { status = val }
        if let val = dictionary["tagline"] as? String { tagline = val }
        if let val = dictionary["id"] as? Int { id = val }
        if let val = dictionary["revenue"] as? Int { revenue = val }
        if let val = dictionary["runtime"] as? Int { runtime = val }
        if let val = dictionary["budget"] as? Int { budget = val }
        if let val = dictionary["backdrop_path"] as? String { backdrop_path = val }
        if let val = dictionary["original_language"] as? String { original_language = val }
        if let val = dictionary["original_title"] as? String { original_title = val }
        if let val = dictionary["overview"] as? String { overview = val }
        if let val = dictionary["popularity"] as? Double { popularity = val }
        if let val = dictionary["title"] as? String { title = val }
        if let val = dictionary["vote_average"] as? Double { vote_average = val }
        if let val = dictionary["adult"] as? Bool { adult = val }
        if let val = dictionary["release_date"] as? String { release_date = val }
        if let val = dictionary["genre_ids"] as? [Int] { genre_ids = val }
        if let val = dictionary["isMove"] as? Bool { isMove = val }
    }
    
    func toString() -> [String: Any] {
        return[
            "vote_count": self.vote_count,
            "video": self.video,
            "poster_path": self.poster_path,
            "homepage": self.homepage,
            "imdb_id": self.imdb_id,
            "status": self.status,
            "tagline": self.tagline,
            "id": self.id,
            "revenue": self.revenue,
            "runtime": self.runtime,
            "budget": self.budget,
            "backdrop_path": self.backdrop_path,
            "original_language": self.original_language,
            "original_title": self.original_title,
            "overview": self.overview,
            "popularity": self.popularity,
            "title": self.title,
            "vote_average": self.vote_average,
            "adult": self.adult,
            "release_date": self.release_date,
            "genre_ids": self.genre_ids,
            "isMove": self.isMove
        ]
    }
}
extension DMoviesDetail{
    var dataDictionary: DDictionary {
        return[
            "vote_count": self.vote_count,
            "video": self.video,
            "poster_path": self.poster_path,
            "homepage": self.homepage,
            "imdb_id": self.imdb_id,
            "status": self.status,
            "tagline": self.tagline,
            "id": self.id,
            "revenue": self.revenue,
            "runtime": self.runtime,
            "budget": self.budget,
            "backdrop_path": self.backdrop_path,
            "original_language": self.original_language,
            "original_title": self.original_title,
            "overview": self.overview,
            "popularity": self.popularity,
            "title": self.title,
            "vote_average": self.vote_average,
            "adult": self.adult,
            "release_date": self.release_date,
            "genre_ids": self.genre_ids,
            "isMove": self.isMove
        ]
    }
}
extension DMoviesDetail {
    static func readFromNoteJson() -> [DMoviesDetail] {
        let string = readString(fileName: FAV_SAVE)
        if string == nil || string == "" {
            return [DMoviesDetail]()
        }
        let data: [DDictionary] = dataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [DMoviesDetail]()
        for item in data {
            let model = DMoviesDetail(data: item)
            result.append(model)
        }
        return result
    }
}

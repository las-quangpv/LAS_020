
import Foundation
class DTvShowDetail: NSObject {
    var adult: Bool = false//
    var backdrop_path: String = ""//
    var genre_ids: [Int] = [Int]()
    var id: Int = 0
    var original_name: String = ""
    var overview: String = ""
    var popularity: Double = 0
    var poster_path: String = ""
    var first_air_date: String = ""
    var name = ""
    var video: Bool = false
    var vote_count: Int = 0
    var vote_average: Double = 0
    override init() {
        
    }
    
    init(data: [String: Any]) {
        if let val = data["adult"] as? Bool { adult = val }
        if let val = data["backdrop_path"] as? String { backdrop_path = val }
        if let val = data["genre_ids"] as? [Int] { genre_ids = val }
        if let val = data["id"] as? Int { id = val }
        if let val = data["original_name"] as? String { original_name = val }
        if let val = data["overview"] as? String { overview = val }
        if let val = data["popularity"] as? Double { popularity = val }
        if let val = data["poster_path"] as? String { poster_path = val }
        if let val = data["first_air_date"] as? String { first_air_date = val }
        if let val = data["name"] as? String { name = val }
        if let val = data["video"] as? Bool { video = val }
        if let val = data["vote_count"] as? Int { vote_count = val }
        if let val = data["vote_average"] as? Double { vote_average = val }
    }
    
    init(_ dictionary: DDictionary) {
        if let val = dictionary["adult"] as? Bool { adult = val }
        if let val = dictionary["backdrop_path"] as? String { backdrop_path = val }
        if let val = dictionary["genre_ids"] as? [Int] { genre_ids = val }
        if let val = dictionary["id"] as? Int { id = val }
        if let val = dictionary["original_name"] as? String { original_name = val }
        if let val = dictionary["overview"] as? String { overview = val }
        if let val = dictionary["popularity"] as? Double { popularity = val }
        if let val = dictionary["poster_path"] as? String { poster_path = val }
        if let val = dictionary["first_air_date"] as? String { first_air_date = val }
        if let val = dictionary["name"] as? String { name = val }
        if let val = dictionary["video"] as? Bool { video = val }
        if let val = dictionary["vote_count"] as? Int { vote_count = val }
        if let val = dictionary["vote_average"] as? Double { vote_average = val }

    }
    static func convertTvShowToMove(tvShow: DTvShowDetail)-> DMoviesDetail{
        let moveDetail = DMoviesDetail()
        moveDetail.adult = tvShow.adult
        moveDetail.backdrop_path = tvShow.backdrop_path
        moveDetail.genre_ids = tvShow.genre_ids
        moveDetail.id = tvShow.id
        moveDetail.overview = tvShow.overview
        moveDetail.original_title = tvShow.original_name
        moveDetail.title = tvShow.name
        moveDetail.release_date = tvShow.first_air_date
        moveDetail.poster_path = tvShow.poster_path
        moveDetail.vote_average = tvShow.vote_average
        moveDetail.vote_count = tvShow.vote_count
        return moveDetail
    }
}
extension DTvShowDetail{
    var dataDictionary: DDictionary {
        return[
            "adult": self.adult,
            "backdrop_path": self.backdrop_path,
            "genre_ids": self.genre_ids,
            "id": self.id,
            "original_name": self.original_name,
            "overview": self.overview,
            "popularity": self.popularity,
            "poster_path": self.poster_path,
            "first_air_date": self.first_air_date,
            "name": self.name,
            "video": self.video,
            "vote_count": self.vote_count,
            "vote_average": self.vote_average
        ]
    }
}

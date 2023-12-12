

import Foundation
import UIKit
// For request API
let apiHost = "https://api.themoviedb.org"
let imageHost = "https://image.tmdb.org/t/p/w500"
class ApiDefines: NSObject{
    class func getUpcomming() ->String{
        return "\(apiHost)/3/movie/upcoming"
    }
    class func getPopularMove() ->String{
        return "\(apiHost)/3/movie/popular"
    }
    class func getPopularToprated() ->String{
        return "\(apiHost)/3/movie/top_rated"
    }
    class func getNowPlayingMove() ->String{
        return "\(apiHost)/3/movie/now_playing"
    }
    class func genresApi() -> String {
        return "\(apiHost)/3/genre/movie/list"
    }
    class func getMovieDetail(moveId: String) -> String {
        return "\(apiHost)/3/movie/\(moveId)"
    }
    class func getMoviesShowCast(moveId: String) -> String {
        return "\(apiHost)/3/movie/\(moveId)/credits"
    }
    class func getMoveBackdrops(moveId: String) -> String {
        return "\(apiHost)/3/movie/\(moveId)/images"
    }
    class func getMoviesRecommendations(moveId: String) -> String {
        return "\(apiHost)/3/movie/\(moveId)/recommendations"
    }
    class func getMoviesVideo(moveId: String) -> String {
        return "\(apiHost)/3/movie/\(moveId)/videos"
    }
    class func getTvVideo(tvId: String) -> String {
        return "\(apiHost)/3/tv/\(tvId)/videos"
    }
    class func searchMovies() -> String {
        return "\(apiHost)/3/search/movie"
    }
    class func getPersonPopular() -> String {
        return "\(apiHost)/3/person/popular"
    }
    
    class func searchTv() -> String {
        return "\(apiHost)/3/search/tv"
    }
    
    
    class func getGenreMovieDetailWithPage() -> String {
        return "\(apiHost)/3/discover/movie"
    }
    
    //tv
    class func getAirTodayTv(type: String) -> String {
        return "\(apiHost)/3/tv/\(type)"
    }
    class func getPopularTv() -> String {
        return "\(apiHost)/3/tv/popular"
    }
    class func getTvShowCast(tvId: String) -> String {
        return "\(apiHost)/3/tv/\(tvId)/credits"
    }
    class func getTvShowRecommendations(tvId: String) -> String {
        return "\(apiHost)/3/tv/\(tvId)/recommendations"
    }
    class func getTvBackdrops(tvId: String) -> String {
        return "\(apiHost)/3/tv/\(tvId)/images"
    }
    class func getGenreTvDetailWithPage() -> String {
        return "\(apiHost)/3/discover/tv"
    }
    class func genresTvApi() -> String {
        return "\(apiHost)/3/genre/tv/list"
    }
    class func getEpisodeGroups(tvId: String) -> String {
        return "\(apiHost)/3/tv/\(tvId)/episode_groups"
    }
    class func getDetailSeason(seriesId: String) -> String {
        return "\(apiHost)/3/tv/\(seriesId)/season/1"
    }
    // person
    class func getDetailPerson(personId: String) -> String {
        return "\(apiHost)/3/person/\(personId)"
    }
}

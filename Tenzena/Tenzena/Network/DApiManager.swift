

import Foundation
import UIKit

fileprivate enum HttpMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
let apiKey = "7ee59323be031d45f543f8c0809f4b6b"

typealias ApiCompletion = (_ data: DResponse) -> ()
typealias DDictionary = [String: Any]

class DApiManage: NSObject{
    private let TIMEOUT_REQUEST: TimeInterval = 30
    
    
    // create Instance
    static let getInstance: DApiManage = DApiManage()
    
    fileprivate func request(urlString: String,
                             param: DDictionary,
                             headers: [String: String]?,
                             method: HttpMethod,
                             showLoading: Bool,
                             completion: ApiCompletion?
    ){
        //showloading
        var request:URLRequest!
        
        // set method & param
        if method == .get{
            if param.keys.count > 0{
                let parameterString = param.stringFromHttpParameters()
                request = URLRequest(url: URL(string:"\(urlString)?\(parameterString)")!)
            }
            else{
                request = URLRequest(url: URL(string:urlString)!)
            }
            if let headers = headers {
                request.allHTTPHeaderFields = headers
            }
        }
        else if method == .post || method == .put || method == .delete {
            request = URLRequest(url: URL(string:urlString)!)
            
            // content-type
            if let headers = headers {
                request.allHTTPHeaderFields = headers
            }
            else {
                //?
                request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            }
            
            let body = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            request.httpBody = body
        }
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = method.rawValue
        
        // call api
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // handle error 401
                if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                    return
                }
                
                // check for fundamental networking error
                guard let data = data, error == nil else {
                    if let block = completion {
                        let data = DResponse(error: error?.localizedDescription)
                        block(data)
                    }
                    return
                }
                
                //
                if let block = completion {
                    if let json = self.dataToJSON(data: data) {
                        let data = DResponse(true, data: json)
                        block(data)
                    }
                    else if let stringJson = String(data: data, encoding: .utf8) {
                        print("stringJson: \(stringJson)")
                        let data = DResponse(true, data: nil)
                        block(data)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    private func createBody(parameters: DDictionary,
                            boundary: String,
                            images: [UIImage],
                            field: String,
                            mimeType: String) -> Data
    {
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        var index = 0
        for img in images {
            if let data = img.pngData() {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(field)\"; filename=\"\(index)\"\r\n")
                body.appendString("Content-Type: \(mimeType)\r\n\r\n")
                body.append(data)
                body.appendString("\r\n")
                index += 1
            }
        }
        
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    private func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch { }
        return nil
    }
}
extension DApiManage{
    func getGenres(isMove: Bool, completion: @escaping ApiCompletion){
        let url = isMove ? ApiDefines.genresApi() : ApiDefines.genresTvApi()
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: true) { (response) in
            if let data = response.data as? DDictionary{
                if let listDataGenres = data["genres"] as? [DDictionary] {
                    var listGenres = [Genres]()
                    for item in listDataGenres{
                        let genres = Genres(item)
                        listGenres.append(genres)
                    
                    }
                    let res = DResponse(true, data: listGenres)
                    completion(res)
                    return
                }
            }
            completion(response)
        }
    }
    
    func getMovieUpcoming(page: Int, showLoading: Bool, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getUpcomming()
        let params: DDictionary = ["api_key": apiKey, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: showLoading) { (response) in
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    let res = DResponse(true, data: listMovie)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    
    func getMovieNowPlaying(page: Int, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getNowPlayingMove()
        let params: DDictionary = ["api_key": apiKey, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: true) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listMovie, totalPage: totalPage)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    
    func getMovieToprated(page: Int, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getPopularToprated()
        let params: DDictionary = ["api_key": apiKey, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: true) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listMovie, totalPage: totalPage)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    func getPersonPopular(page: Int, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getPersonPopular()
        let params: DDictionary = ["api_key": apiKey, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: true) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if  let listDataPerson = data["results"] as? [DDictionary] {
                    var listPerson = [DPersonModel]()
                    for item in listDataPerson {
                        let person = DPersonModel(item)
                        listPerson.append(person)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listPerson, totalPage: totalPage)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
    func getMoviePopular(page: Int, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getPopularMove()
        let params: DDictionary = ["api_key": apiKey, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: true) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listMovie, totalPage: totalPage)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    
    func getMoveDetail(_ moveId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getMovieDetail(moveId:moveId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                let movie = DMoviesDetail(data)
                let res = DResponse(true, data: movie)
                completion(res)
                return
            }
            completion(response)
        }
    }
    func getPersonDetail(_ personId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getDetailPerson(personId: personId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                let personDetail = DPersonDetailModel(data)
                let res = DResponse(true, data: personDetail)
                completion(res)
                return
            }
            completion(response)
        }
    }
    
    func getMoviesShowCast(_ moveId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getMoviesShowCast(moveId:moveId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if  let ddCasts = data["cast"] as? [DDictionary] {
                    var casts = [CastModel]()
                    for item in ddCasts {
                        let cast = CastModel(item)
                        casts.append(cast)
                    }
                    let res = DResponse(true, data: casts)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    func getMoviesBackDrops(_ moveId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getMoveBackdrops(moveId:moveId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let ddImages = data["backdrops"] as? [DDictionary] {
                    var images = [BackDropsModel]()
                    for item in ddImages {
                        let image = BackDropsModel(item)
                        images.append(image)
                    }
                    let res = DResponse(true, data: images)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    func getMoviesRecommendations(_ moveId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getMoviesRecommendations(moveId:moveId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    let res = DResponse(true, data: listMovie)
                    completion(res)
                    return
                }
               
            }
            completion(response)
        }
    }
    func getGenreMovieDetailWithPage(_ genresId: String,page: Int = 1, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getGenreMovieDetailWithPage()
        let params: DDictionary = ["api_key": apiKey,
                                   "page": page,
                                   "with_genres": genresId
                                   ]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listMovie, totalPage: totalPage)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    func getGenreTvDetailWithPage(_ genresId: String,page: Int = 1, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getGenreTvDetailWithPage()
        let params: DDictionary = ["api_key": apiKey,
                                   "page": page,
                                   "with_genres": genresId
                                   ]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listData = data["results"] as? [DDictionary] {
                    var listTv = [DTvShowDetail]()
                    for item in listData {
                        let tv = DTvShowDetail(item)
                        listTv.append(tv)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listTv, totalPage: totalPage)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
    func searchMove(_ search: String,page: Int = 1, completion: @escaping ApiCompletion) {
        let url = ApiDefines.searchMovies()
        let params: DDictionary = ["api_key": apiKey, "query":search, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataMovie = data["results"] as? [DDictionary] {
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    var listMovie = [DMoviesDetail]()
                    for item in listDataMovie {
                        let movie = DMoviesDetail(item)
                        listMovie.append(movie)
                    }
                    let res = DResponse(true, data: listMovie, totalPage: totalPage)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
    func searchTv(_ search: String,page: Int = 1, completion: @escaping ApiCompletion) {
        let url = ApiDefines.searchTv()
        let params: DDictionary = ["api_key": apiKey, "query":search, "page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataTv = data["results"] as? [DDictionary] {
                    var listTv = [DTvShowDetail]()
                    for item in listDataTv {
                        let tv = DTvShowDetail(item)
                        listTv.append(tv)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listTv, totalPage: totalPage)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
   
    
    func getVideoKey(_ moveId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getMoviesVideo(moveId:moveId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let listDataKey = data["results"] as? [DDictionary], listDataKey.count > 0 {
                    let item = listDataKey[0]
                    if let key = item["key"] as? String {
                        let res = DResponse(true, data: key)
                        completion(res)
                        return
                    }
                }
            }
            completion(response)
        }
    }
    func getTvVideoKey(_ tvId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getTvVideo(tvId: tvId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let listDataKey = data["results"] as? [DDictionary], listDataKey.count > 0 {
                    let item = listDataKey[0]
                    if let key = item["key"] as? String {
                        let res = DResponse(true, data: key)
                        completion(res)
                        return
                    }
                }
               
            }
            completion(response)
        }
    }
    // tv
    func getTvSeasonGroup(_ tvId:String,completion: @escaping ApiCompletion) {
        let url = ApiDefines.getEpisodeGroups(tvId: tvId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let listData = data["results"] as? [DDictionary] {
                    var listSeason = [SeasionsGroupModel]()
                    for item in listData {
                        let season = SeasionsGroupModel(item)
                        listSeason.append(season)
                    }
                   
                    let res = DResponse(true, data: listSeason)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
    func getDetailSeasons(_ seriesId:String,completion: @escaping ApiCompletion) {
        let url = ApiDefines.getDetailSeason(seriesId: seriesId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                let detail = SeasonDetailModel(data)
                let res = DResponse(true, data: detail)
                completion(res)
                return
            }
            completion(response)
        }
    }
    
    // tv
    func getTypeTv(page: Int = 1,type: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getAirTodayTv(type: type)
        let params: DDictionary = ["api_key": apiKey,"page": page]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            var totalPage = 1.0
            if let data = response.data as? DDictionary {
                if let listDataTv = data["results"] as? [DDictionary] {
                    var listTv = [DTvShowDetail]()
                    for item in listDataTv {
                        let tv = DTvShowDetail(item)
                        listTv.append(tv)
                    }
                    if let maxPage = data["total_pages"] as? Double {
                        totalPage = maxPage
                    }
                    let res = DResponse(true, data: listTv, totalPage: totalPage)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
    func getTvShowCast(_ tvId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getTvShowCast(tvId: tvId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let ddCasts = data["cast"] as? [DDictionary] {
                    var casts = [CastModel]()
                    for item in ddCasts {
                        let cast = CastModel(item)
                        casts.append(cast)
                    }
                    let res = DResponse(true, data: casts)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    func getTvShowRecommendations(_ tvId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getTvShowRecommendations(tvId: tvId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if let listDataTv = data["results"] as? [DDictionary] {
                    var listTv = [DTvShowDetail]()
                    for item in listDataTv {
                        let tv = DTvShowDetail(item)
                        listTv.append(tv)
                    }
                    let res = DResponse(true, data: listTv)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
    func getTvShowBackDrops(_ tvId: String, completion: @escaping ApiCompletion) {
        let url = ApiDefines.getTvBackdrops(tvId: tvId)
        let params: DDictionary = ["api_key": apiKey]
        let headers: [String: String]? = nil
        request(urlString: url, param: params, headers: headers, method: .get, showLoading: false) { (response) in
            if let data = response.data as? DDictionary {
                if  let ddImages = data["backdrops"] as? [DDictionary] {
                    var images = [BackDropsModel]()
                    for item in ddImages {
                        let image = BackDropsModel(item)
                        images.append(image)
                    }
                    let res = DResponse(true, data: images)
                    completion(res)
                    return
                }
                
            }
            completion(response)
        }
    }
    
}



import Foundation
import Alamofire

enum Endpoint {
    case getScheduledAnime(params: ScheduleParam)
    case getDetailAnime(params: Int)
    case getSeasonNow(params: SeasonNowParam)
    case filterAnime(params: FilterAnimeParam)
    case filterManga(params: FilterMangaParam)
    case getAnimeCharacter(params: Int)
    case getAnimeStaff(params: Int)
    case getRecommendationAnime(params: Int)
    case postUserAnime(params: UserAnimeBody)
    case getUserAnime(params: Int)
    case putUserAnime(params: UpdateUserAnimeBody)
    case deleteUserAnime(params: String)
    case findOneUserAnime(params: OneUserAnimeParam)
    case getTopAnime(params: TopAnimeParam)
    
    func path() -> String {
        switch self {
        case .getScheduledAnime:
            return "/schedules"
        case .getSeasonNow:
            return "/seasons/now"
        case .filterAnime:
            return "/anime"
        case .filterManga:
            return "/manga"
        case .getDetailAnime(let malId):
            return "/anime/\(malId)/full"
        case .getAnimeCharacter(let malId):
            return "/anime/\(malId)/characters"
        case .getAnimeStaff(let malId):
            return "/anime/\(malId)/staff"
        case .getRecommendationAnime(let malId):
            return "/anime/\(malId)/recommendations"
        case .postUserAnime, .getUserAnime:
            return "/anime/user"
        case .findOneUserAnime:
            return "/anime/user/find"
        case .putUserAnime(let param):
            return "/anime/user/\(param.id)"
        case .deleteUserAnime(let id):
            return "/anime/user/\(id)"
        case .getTopAnime:
            return "/top/anime"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getUserAnime, .findOneUserAnime, .getTopAnime:
            return .get
        case .postUserAnime:
            return .post
        case .putUserAnime:
            return .put
        case .deleteUserAnime:
            return .delete
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getScheduledAnime(let param):
            return [
                "filter":param.filter,
                "page":param.page,
                "limit":param.limit
            ]
        case .getSeasonNow(let param):
            return [
                "page": param.page,
                "limit": param.limit]
        case .filterAnime(params: let param):
            
            var params = [String: Any]()
            
            if let query = param.q {
                params["q"] = query
            }
            
            if let limit = param.limit {
                params["limit"] = limit
            }
            
            if let page = param.page {
                params["page"] = page
            }
            params["sfw"] = "true"
            
            return params
            
        case .filterManga(let param):
            var params = [String: Any]()
            
            if let query = param.q {
                params["q"] = query
            }
            
            if let limit = param.limit {
                params["limit"] = limit
            }
            
            if let page = param.page {
                params["page"] = page
            }
            
            params["sfw"] = "true"
            
            return params
        case .getUserAnime(let userId):
            return ["user_id": userId]
        case .findOneUserAnime(let param):
            return ["user_id": param.userId, "mal_id": param.malId]
        case .postUserAnime(let params):
            let param = try? params.asDictionary()
            return param
        case .putUserAnime(let param):
            var params = [String: Any]()
            params["user_score"] = param.userScore
            params["user_episode"] = param.userEpisode
            params["watch_status"] = param.watchStatus
            return params
        case .getTopAnime(let param):
            var params = [String: Any]()
            params["filter"] = param.filter
            params["page"] = param.page
            return params
        case .getDetailAnime, .getAnimeStaff, .getAnimeCharacter, .getRecommendationAnime, .deleteUserAnime:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        let params: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        return params
    }
    
    func urlString() -> String {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getTopAnime:
            return BaseConstant.baseURL + self.path()
        case .postUserAnime, .getUserAnime,.findOneUserAnime, .putUserAnime, .deleteUserAnime:
            return BaseConstant.baseURL2 + self.path()
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getUserAnime, .findOneUserAnime, .deleteUserAnime, .getTopAnime:
            return URLEncoding.queryString
        case .postUserAnime, .putUserAnime:
            return JSONEncoding.default
        }
    }
}


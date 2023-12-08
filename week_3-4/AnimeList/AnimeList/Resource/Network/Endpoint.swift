import Foundation
import Alamofire

enum Endpoint {
    case getScheduledAnime(params: ScheduleParam)
    case getDetailAnime(params: Int)
    case getSeasonNow(params: SeasonNowParam)
    case getAnimeCharacter(params: Int)
    case getAnimeStaff(params: Int)
    case getRecommendationAnime(params: Int)
    case getTopAnime(params: TopAnimeParam)
    case getSeasonList
    case getSeason(params: AnimeSeasonParam)
    case getUserAnime(params: Int)
    case findOneUserAnime(params: OneUserAnimeParam)
    case filterAnime(params: FilterAnimeParam)
    case filterManga(params: FilterMangaParam)
    case postUserAnime(params: UserAnimeBody)
    case postLogin(params: LoginParam)
    case postRegister(params: RegisterParam)
    case putUserAnime(params: UpdateUserAnimeBody)
    case deleteUserAnime(params: String)
    
    func path() -> String {
        switch self {
        case .getScheduledAnime:
            return "/schedules"
        case .getSeasonNow:
            return "/seasons/now"
        case .getDetailAnime(let malId):
            return "/anime/\(malId)/full"
        case .getAnimeCharacter(let malId):
            return "/anime/\(malId)/characters"
        case .getAnimeStaff(let malId):
            return "/anime/\(malId)/staff"
        case .getTopAnime:
            return "/top/anime"
        case .getSeasonList:
            return "/seasons"
        case .getSeason(let param):
            return "/seasons/\(param.year)/\(param.season)"
        case .getRecommendationAnime(let malId):
            return "/anime/\(malId)/recommendations"
        case .filterAnime:
            return "/anime"
        case .filterManga:
            return "/manga"
        case .findOneUserAnime:
            return "/anime/user/find"
        case .postUserAnime, .getUserAnime:
            return "/anime/user"
        case .postLogin:
            return "/auth/login"
        case .postRegister:
            return "/auth/register"
        case .putUserAnime(let param):
            return "/anime/user/\(param.id)"
        case .deleteUserAnime(let id):
            return "/anime/user/\(id)"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getUserAnime, .findOneUserAnime, .getTopAnime, .getSeasonList, .getSeason:
            return .get
        case .postUserAnime, .postLogin, .postRegister:
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
        case .getUserAnime(let userId):
            return ["user_id": userId]
        case .getTopAnime(let param):
            var params = [String: Any]()
            params["filter"] = param.filter
            params["page"] = param.page
            params["limit"] = "15"
            return params
        case .getSeason(let param):
            var params = [String: Any]()
            params["page"] = param.page
            params["limit"] = param.limit
            return params
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
        case .postLogin(let param):
            var params = [String: Any]()
            params["username"] = param.username
            params["password"] = param.password
            return params
        case .postRegister(let param):
            var params = [String: Any]()
            params["username"] = param.username
            params["email"] = param.email
            params["password"] = param.password
            return params
        case .getDetailAnime, .getAnimeStaff, .getAnimeCharacter, .getRecommendationAnime, .deleteUserAnime, .getSeasonList:
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
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getTopAnime, .getSeasonList, .getSeason:
            return BaseConstant.baseURL + self.path()
        case .getUserAnime,.findOneUserAnime, .postUserAnime, .postLogin, .postRegister, .putUserAnime, .deleteUserAnime:
            return BaseConstant.baseURL2 + self.path()
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getUserAnime, .findOneUserAnime, .deleteUserAnime, .getTopAnime, .getSeason:
            return URLEncoding.queryString
        case .getSeasonList:
            return URLEncoding.default
        case .postUserAnime, .putUserAnime, .postLogin, .postRegister:
            return JSONEncoding.default
        }
    }
}


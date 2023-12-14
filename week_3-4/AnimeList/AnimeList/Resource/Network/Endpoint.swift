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
    case getUserAnime(params: String)
    case getUser(params: String)
    case getUserRecentUpdate(params: String)
    case findOneUserAnime(params: OneUserAnimeParam)
    case filterAnime(params: FilterAnimeParam)
    case filterManga(params: FilterMangaParam)
    case postUserAnime(params: UserAnimeParam)
    case postLogin(params: LoginParam)
    case postLoginGoogle(params: LoginGoogleParam)
    case postRegister(params: RegisterParam)
    case postRegisterGoogle(params: RegisterGoogleParam)
    case postUploadProfileImage(params: UploadProfileImageParam)
    case putUser(params: UpdateUserParam)
    case putUserAnime(params: UpdateUserAnimeParam)
    case putChangePassword(params: ChangePasswordParam)
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
        case .getUser:
            return "/user"
        case .getUserRecentUpdate:
            return "/anime/user/recentUpdate"
        case .filterAnime:
            return "/anime"
        case .filterManga:
            return "/manga"
        case .findOneUserAnime:
            return "/anime/user/find"
        case .postUserAnime, .getUserAnime:
            return "/anime/user"
        case .postUploadProfileImage(let param):
            return "/user/profileImage?userId=\(param.userId)"
        case .postLogin:
            return "/auth/login"
        case .postLoginGoogle:
            return "/oauth2/login/google"
        case .postRegister:
            return "/auth/register"
        case .postRegisterGoogle:
            return "/oauth2/register/google"
        case .putUser:
            return "/user"
        case .putUserAnime(let param):
            return "/anime/user/\(param.id)"
        case .putChangePassword(let param):
            return "/auth/changePassword/\(param.userId)"
        case .deleteUserAnime(let id):
            return "/anime/user/\(id)"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .postUserAnime, .postLogin, .postRegister, .postLoginGoogle, .postRegisterGoogle, .postUploadProfileImage:
            return .post
        case .putUserAnime, .putUser, .putChangePassword:
            return .put
        case .deleteUserAnime:
            return .delete
        default:
            return .get
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
        case .getUser(let param):
            return ["userId": param]
        case .getUserRecentUpdate(let param), .getUserAnime(let param):
            return ["user_id": param]
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
        case .putUserAnime(let param):
            var params = [String: Any]()
            
            params["user_score"] = param.userScore
            params["user_episode"] = param.userEpisode
            params["watch_status"] = param.watchStatus
            return params
        case .putChangePassword(let param):
            var params = [String: Any]()
            
            params["oldPassword"] = param.oldPassword
            params["newPassword"] = param.newPassword
            return params
        case .putUser(let params):
            let param = try? params.asDictionary()
            return param
        case .postUserAnime(let params):
            let param = try? params.asDictionary()
            return param
        case .postLoginGoogle(let param):
            let params = try? param.asDictionary()
            return params
        case .postLogin(let param):
            let params = try? param.asDictionary()
            return params
        case .postRegister(let param):
            let params = try? param.asDictionary()
            return params
        case .postRegisterGoogle(let param):
            let params = try? param.asDictionary()
            return params
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getTopAnime, .filterManga, .filterAnime, .getSeasonList, .getSeason, .postLogin, .postRegister, .postLoginGoogle, .postRegisterGoogle:
            let params: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            return params
        case .getUserAnime, .getUser, .getUserRecentUpdate, .findOneUserAnime, .postUserAnime, .postUploadProfileImage, .putUser, .putChangePassword, .putUserAnime, .deleteUserAnime:
            let token = TokenHelper().retrieveToken()
            
            let params: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
            return params
        }
    }
    
    func urlString() -> String {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getTopAnime, .getSeasonList, .getSeason:
            return BaseConstant.baseURL + self.path()
        case .getUserAnime, .getUser, .getUserRecentUpdate, .findOneUserAnime, .postUserAnime, .postLogin, .postLoginGoogle, .postRegisterGoogle, .postRegister, .postUploadProfileImage, .putUserAnime, .putChangePassword, .putUser, .deleteUserAnime:
            return BaseConstant.baseURL2 + self.path()
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .getSeasonList, .getTopAnime, .getUserRecentUpdate, .getSeason, .getUser, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getUserAnime, .findOneUserAnime, .putUser, .deleteUserAnime:
            return URLEncoding.queryString
        case .postUserAnime, .putUserAnime, .postLogin, .postUploadProfileImage, .postLoginGoogle, .postRegisterGoogle, .postRegister, .putChangePassword:
            return JSONEncoding.default
        }
    }
}


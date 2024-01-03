import Foundation
import Alamofire

enum Endpoint {
    case getScheduledAnime(params: ScheduleParam)
    case getDetailAnime(params: Int)
    case getDetailManga(params: Int)
    case getSeasonNow(params: SeasonNowParam)
    case getAnimeCharacter(params: Int)
    case getAnimeStaff(params: Int)
    case getRecommendationAnime(params: Int)
    case getMangaChapterImage(params: MangaChapterImageParam)
    case getTopAnime(params: TopAnimeParam)
    case getTopManga(params: TopMangaParam)
    case getSeasonList
    case getSeason(params: AnimeSeasonParam)
    case getUserManga(params: String)
    case getUserAnime(params: String)
    case getUser(params: String)
    case getUserRecentUpdate(params: String)
    case getUserStats(params: UserStatsParam)
    case getMangaMangadex(params: MangaParam)
    case getMangaChapters(params: MangaChaptersParam)
    case findOneUserAnime(params: OneUserAnimeParam)
    case filterAnime(params: FilterAnimeParam)
    case filterManga(params: FilterMangaParam)
    case postUserManga(params: CreateUserMangaParam)
    case postUserAnime(params: UserAnimeParam)
    case postLogin(params: LoginParam)
    case postLoginGoogle(params: LoginGoogleParam)
    case postRegister(params: RegisterParam)
    case postRegisterGoogle(params: RegisterGoogleParam)
    case postUploadProfileImage(params: UploadProfileImageParam)
    case putUser(params: UpdateUserParam)
    case putUserAnime(params: UpdateUserAnimeParam)
    case putChangePassword(params: ChangePasswordParam)
    case putUserManga(params: UpdateUserMangaParam)
    case deleteUserAnime(params: String)
    case deleteUserManga(params: String)
    
    func path() -> String {
        switch self {
        case .getScheduledAnime:
            return "/schedules"
        case .getDetailManga(let param):
            return "/manga/\(param)/full"
        case .getSeasonNow:
            return "/seasons/now"
        case .getDetailAnime(let malId):
            return "/anime/\(malId)/full"
        case .getAnimeCharacter(let malId):
            return "/anime/\(malId)/characters"
        case .getAnimeStaff(let malId):
            return "/anime/\(malId)/staff"
        case .getMangaChapters:
            return "/chapter"
        case .getMangaChapterImage(params: let param):
            return "/at-home/server/\(param.chapterId)"
        case .getTopAnime:
            return "/top/anime"
        case .getTopManga:
            return "/top/manga"
        case .getSeasonList:
            return "/seasons"
        case .getSeason(let param):
            return "/seasons/\(param.year)/\(param.season)"
        case .getRecommendationAnime(let malId):
            return "/anime/\(malId)/recommendations"
        case .getUser:
            return "/user"
        case .getUserStats:
            return "/user/stats"
        case .getUserRecentUpdate:
            return "/anime/user/recentUpdate"
        case .filterAnime:
            return "/anime"
        case .filterManga, .getMangaMangadex:
            return "/manga"
        case .findOneUserAnime:
            return "/anime/user/find"
        case .postUserAnime, .getUserAnime:
            return "/anime/user"
        case .getUserManga, .postUserManga:
            return "/manga/user"
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
        case .putUserManga:
            return "/manga/user"
        case .putChangePassword(let param):
            return "/auth/changePassword/\(param.userId)"
        case .deleteUserAnime(let id):
            return "/anime/user/\(id)"
        case .deleteUserManga(let id):
            return "/manga/user/\(id)"
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .postUserAnime, .postLogin, .postRegister, .postLoginGoogle, .postRegisterGoogle, .postUserManga, .postUploadProfileImage:
            return .post
        case .putUserAnime, .putUser, .putChangePassword, .putUserManga:
            return .put
        case .deleteUserAnime, .deleteUserManga:
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
                "limit":param.limit
            ]
        case .getSeasonNow(let param):
            return [
                "page": param.page,
                "limit": param.limit]
        case .getTopAnime(let param):
            var params = [String: Any]()
            params["filter"] = param.filter
            params["limit"] = param.limit
            return params
        case .getTopManga(let param):
            var params = [String: Any]()
            params["filter"] = param.filter
            params["limit"] = param.limit
            params["type"] = param.type
            return params
        case .getSeason(let param):
            var params = [String: Any]()
            params["limit"] = param.limit
            return params
        case .getUser(let param):
            return ["userId": param]
        case .getUserStats(let param):
            return ["userId": param.userId]
        case .getUserRecentUpdate(let param), .getUserAnime(let param), .getUserManga(let param):
            return ["user_id": param]
        case .getMangaChapters(let param):
            return ["manga": param.mangaId, "order[chapter]": param.orderChapter, "translatedLanguage[]": param.translatedLanguage, "limit": 100]
        case .getMangaMangadex(let param):
            var params = [String: Any]()
            params["limit"] = param.limit
            if let title = param.title{
                params["title"] = title
            }
            return params
        case .filterAnime(params: let param):
            
            var params = [String: Any]()
            
            if let query = param.q {
                params["q"] = query
            }
            
            if let limit = param.limit {
                params["limit"] = limit
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
            
            params["type"] = param.type
            
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
        case .putUserManga(let param):
            var params = [String: Any]()
            
            params["id"] = param.id
            params["userScore"] = param.userScore
            params["userEpisode"] = param.userEpisode
            params["watchStatus"] = param.watchStatus
            return params
        case .putChangePassword(let param):
            var params = [String: Any]()
            
            params["oldPassword"] = param.oldPassword
            params["newPassword"] = param.newPassword
            return params
        case .postUserManga(params: let param):
            var params = [String: Any]()
            
            params["mal_id"] = param.malId
            params["manga_id"] = param.mangaId
            params["user_id"] = param.userId
            params["user_score"] = param.userScore
            params["user_episode"] = param.userEpisode
            params["watch_status"] = param.watchStatus
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
        case .getUserAnime, .getUserManga, .getUser, .getUserRecentUpdate, .getUserStats, .findOneUserAnime, .postUserAnime, .postUploadProfileImage, .postUserManga, .putUser, .putUserManga, .putChangePassword, .putUserAnime, .deleteUserAnime, .deleteUserManga:
            
            let params: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(TokenHelper.shared.retrieveToken())"
            ]
            return params
        default:
            let params: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
            return params
        }
    }
    
    func urlString() -> String {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .getDetailManga, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getTopAnime, .getTopManga, .getSeasonList, .getSeason:
            return BaseConstant.baseURL + self.path()
        case .getUserAnime, .getUserManga, .getUser, .getUserRecentUpdate, .getUserStats, .findOneUserAnime, .postUserAnime, .postLogin, .postLoginGoogle, .postRegisterGoogle, .postRegister, .postUserManga, .postUploadProfileImage, .putUserAnime, .putUserManga, .putChangePassword, .putUser, .deleteUserAnime, .deleteUserManga:
            return BaseConstant.baseURL2 + self.path()
        case .getMangaMangadex, .getMangaChapters, .getMangaChapterImage:
            return BaseConstant.baseURL3 + self.path()
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getMangaChapters, .getScheduledAnime, .getSeasonNow, .getMangaChapterImage, .getMangaMangadex, .getDetailManga, .getSeasonList, .getTopAnime, .getTopManga, .getUserStats, .getUserRecentUpdate, .getSeason, .getUser, .getUserManga, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime, .getUserAnime, .findOneUserAnime, .postUserManga, .putUser, .putUserManga, .deleteUserManga, .deleteUserAnime:
            return URLEncoding.queryString
        default:
            return JSONEncoding.default
        }
    }
}

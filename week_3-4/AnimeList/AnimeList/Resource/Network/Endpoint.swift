import Foundation
import Alamofire

enum Endpoint {
    case getScheduledAnime(params: ScheduleParam)
    case getDetailAnime(malId: Int)
    case getSeasonNow(page: String, limit: String)
    case filterAnime(params: FilterAnimeParam)
    case filterManga(params: FilterMangaParam)
    case getAnimeCharacter(malId: Int)
    case getAnimeStaff(malId: Int)
    case getRecommendationAnime(malId: Int)
    
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
        }
    }
    
    func method() -> HTTPMethod {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga, .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime:
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
        case .getSeasonNow(let page, let limit):
            return [
                "page": page,
                "limit": limit]
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
        case .getDetailAnime, .getAnimeStaff, .getAnimeCharacter, .getRecommendationAnime:
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
        return BaseConstant.baseURL + self.path()
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getScheduledAnime, .getSeasonNow, .filterAnime, .filterManga:
            return URLEncoding.queryString
        case .getDetailAnime, .getAnimeCharacter, .getAnimeStaff, .getRecommendationAnime:
            return URLEncoding.default
        }
    }
}

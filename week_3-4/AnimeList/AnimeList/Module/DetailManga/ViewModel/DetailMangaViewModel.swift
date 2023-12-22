import Foundation
import RxSwift
import RxCocoa

class DetailMangaViewModel: BaseViewModel{
    
    let mangaDetail = BehaviorRelay<DetailMangaEntity?>(value: nil)
    let errorMessage = BehaviorRelay<String>(value: "")
    let mangaChapters = BehaviorRelay<[MangaChaptersEntity]>(value: [])
    let order = BehaviorRelay<Bool>(value: true)
    
    func loadData <T: Codable> (for endpoint: Endpoint, resultType: T.Type, completion:  ((String) -> Void)? = nil){
        
        switch endpoint {
        case .getDetailManga:
            self.loadingState.accept(.loading)
        default:
            self.loadingState2.accept(.loading)
        }
        
        api.fetchRequest(endpoint: endpoint){[weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                switch endpoint {
                case .getDetailManga:
                    self.loadingState.accept(.finished)
                    if let data = data as? DetailMangaResponse {
                        self.mangaDetail.accept(data.data)
                        if let title = data.data.title{
                            completion?(title)
                        }
                    }
                    self.loadingState.accept(.finished)
                    break
                case .getMangaMangadex:
                    if let data = data as? MangaMangadexResponse, let mangaId = data.data.first?.id {
                        completion?(mangaId)
                    }
                    self.loadingState2.accept(.finished)
                    break
                case .getMangaChapters:
                    if let data = data as? MangaChaptersResponse {
                        let  tempData = data.data.sorted {Int($0.attributes.chapter ?? "0") ?? 0 > Int($1.attributes.chapter ?? "0") ?? 0}
                        self.mangaChapters.accept(tempData)
                    }
                    self.loadingState2.accept(.finished)
                    break
                default:
                    break
                }
            case .failure(let data):
                if let data = data as? CustomError {
                    if (data.statusCode == HTTPStatusCode.serviceUnvaliable){
                        self.errorMessage.accept(data.message)
                    }else{
                        self.errorMessage.accept("Failed get data")
                    }
                }
                self.loadingState.accept(.failed)
                break
            }
        }
    }
    
    func changeOrder(state: Bool){
        switch order.value {
        case true:
            self.mangaChapters.accept(mangaChapters.value.sorted {Int($0.attributes.chapter ?? "0") ?? 0 < Int($1.attributes.chapter ?? "0") ?? 0})
            order.accept(false)
            break
        case false:
            self.mangaChapters.accept(mangaChapters.value.sorted {Int($0.attributes.chapter ?? "0") ?? 0 > Int($1.attributes.chapter ?? "0") ?? 0})
            order.accept(true)
            break
        }
    }
    }

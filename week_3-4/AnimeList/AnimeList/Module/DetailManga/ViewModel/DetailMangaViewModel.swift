import Foundation
import RxSwift
import RxCocoa

class DetailMangaViewModel: BaseViewModel{
    
    let mangaDetail = BehaviorRelay<DetailMangaEntity?>(value: nil)
    let errorMessage = BehaviorRelay<String>(value: "")
    
    func loadData <T: Codable> (for endpoint: Endpoint, resultType: T.Type){
        
        api.fetchRequest(endpoint: endpoint){[weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let data):
                self.loadingState.accept(.finished)
                if let data = data as? DetailMangaResponse {
                    self.mangaDetail.accept(data.data)
                }
                self.loadingState.accept(.finished)
            case . failure(let data):
                if let data = data as? CustomError {
                    self.errorMessage.accept(data.message)
                }
                self.loadingState.accept(.failed)
            }
        }
    }
}

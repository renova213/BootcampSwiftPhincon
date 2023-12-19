import Foundation
import RxSwift
import RxCocoa

class ReadMangaViewModel: BaseViewModel{
    let chapterImages = BehaviorRelay<MangaChapterImageEntity?>(value: nil)
    let errorMessage = BehaviorRelay<String>(value: "")
    
    func loadData <T: Codable> (for endpoint: Endpoint, resultType: T.Type){
        self.loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){[weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                if let data = data as? MangaChapterImageResponse {
                    self.chapterImages.accept(data.chapter)
                    self.loadingState.accept(.finished)
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
            }
        }
    }
}

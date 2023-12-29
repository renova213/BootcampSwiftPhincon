import Foundation
import RxSwift
import RxCocoa

class ReadMangaViewModel: BaseViewModel{
    let chapterImages = BehaviorRelay<MangaChapterImageResponse?>(value: nil)
    let viewState = BehaviorRelay<Bool>(value: true)
    let slideMode = BehaviorRelay<Bool>(value: true)

    
    func loadData <T: Codable> (for endpoint: Endpoint, resultType: T.Type){
        self.loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){[weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                if let data = data as? MangaChapterImageResponse {
                    self.chapterImages.accept(data)
                    self.loadingState.accept(.finished)
                }
            case .failure(let data):
                if let data = data as? CustomError {
                    self.errorMessage.accept(data.message)
                }
                self.loadingState.accept(.failed)
            }
        }
    }
    
    func chapterLength () -> Int {
        if let data = chapterImages.value{
            if (data.chapter.data.isEmpty){
                return 1
            }else{
                return data.chapter.data.count
            }
        }else{
            return 1
        }
    }
    
    func changeViewState(state: Bool){
        viewState.accept(state)
    }
    
    func changeSlideModeState(state: Bool){
        slideMode.accept(state)
    }
}

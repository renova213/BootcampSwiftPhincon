import UIKit
import Lottie
import RxSwift
import RxCocoa

protocol RefreshPopUpDelegate: AnyObject {
    func didTapRefresh()
}

class RefreshPopUp: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieAnimated()
        configureUI()
        configureGesture()
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lottieImage: LottieAnimationView!
    
    func toDismissPopUp() {
        dismiss(animated: false, completion: nil)
    }
    
    weak var delegate: RefreshPopUpDelegate?
    private let disposeBag = DisposeBag()
    
    func lottieAnimated() {
        lottieImage.animation = LottieAnimation.named("warning_sign")
        lottieImage.loopMode = .loop
        
        lottieImage.play()
    }
    
    func configureUI(){
        containerView.roundCornersAll(radius: 10)
        containerView.addShadow()
    }
    
    func configureGesture(){
        refreshButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapRefresh()
        }).disposed(by: disposeBag)
    }
}

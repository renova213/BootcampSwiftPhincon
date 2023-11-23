import UIKit

class SearchBar: UIView {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        self.addSubview(view)
    }
    
    func configureUI(){
        searchView.isUserInteractionEnabled = true
        
        searchField.borderStyle = .none

        searchView.roundCornersAll(radius: 15)
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.init(named: "Main Color")?.cgColor
        
        searchField.isEnabled = false
    }

}

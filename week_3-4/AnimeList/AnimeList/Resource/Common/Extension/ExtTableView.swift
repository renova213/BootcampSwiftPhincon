import Foundation
import UIKit
import Lottie

extension UITableView {
    
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func registerCellWithNib<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: .main)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }
    
    func showEmptyStateAnimation(animationView: LottieAnimationView) {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: bounds.width),
            animationView.heightAnchor.constraint(equalToConstant: bounds.height),
        ])
        
        animationView.play()
    }
    
    func hideEmptyStateAnimation(animationView: LottieAnimationView) {
        animationView.stop()
        animationView.removeFromSuperview()
    }
    
    func showEmptyStateLabel() {
        let emptyStateLabel = UILabel()
        emptyStateLabel.text = "No Data"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func hideEmptyStateLabel() {
        subviews.filter { $0 is UILabel }.forEach { $0.removeFromSuperview() }
    }
}

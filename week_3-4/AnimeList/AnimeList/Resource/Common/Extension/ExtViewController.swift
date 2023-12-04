import Foundation
import UIKit

extension UIView {
    func createAppBar() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(named: "Main Color")
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "appbar")
        imageView.contentMode = .scaleAspectFit
        
        self.addSubview(imageView)
                
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }
}

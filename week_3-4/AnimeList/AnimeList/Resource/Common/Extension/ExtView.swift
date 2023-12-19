import Foundation
import UIKit

extension UIView {
    public func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) / 2
        self.clipsToBounds = true
    }
    
    func roundCornersAll(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func boxShadow(opacity: Float, offset: CGSize, shadowRadius: CGFloat){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
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

//
//  ExtImageView.swift
//  fuel_management_app
//
//  Created by Phincon on 01/11/23.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func makeRadius(withRadius radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

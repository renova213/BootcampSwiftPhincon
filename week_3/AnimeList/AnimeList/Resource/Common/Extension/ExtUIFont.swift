//
//  ExtUIFont.swift
//  AnimeList
//
//  Created by Phincon on 09/11/23.
//

import Foundation
import UIKit

extension UIFont {
    static func robotoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func robotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}

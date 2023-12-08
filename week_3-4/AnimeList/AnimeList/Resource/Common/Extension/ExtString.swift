//
//  ExtString.swift
//  AnimeList
//
//  Created by Phincon on 08/12/23.
//

import Foundation

extension String{

    var gClientID: String{
        guard let value = Bundle.main.infoDictionary?[self] as? String else {
            fatalError("hello world")
        }
        return value
    }
}

class IDEncrypt {
    static let id_ID = "gClientID".gClientID
}

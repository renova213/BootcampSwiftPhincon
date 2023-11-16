//
//  ExtValidasiEmail.swift
//  fuel_management_app
//
//  Created by Phincon on 31/10/23.
//

import Foundation
import UIKit

extension LoginViewController {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

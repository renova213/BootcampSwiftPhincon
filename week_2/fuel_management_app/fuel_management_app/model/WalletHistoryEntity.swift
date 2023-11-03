//
//  WalletHistoryEntity.swift
//  fuel_management_app
//
//  Created by Phincon on 03/11/23.
//

import Foundation

struct WalletHistoryEntity {
    var statusTransaction: Int
    var balance: Int
    var date: String
    
    init(statusTransaction: Int, balance: Int, date: String) {
        self.statusTransaction = statusTransaction
        self.balance = balance
        self.date = date
    }
    
    static let listWalletHistory: [WalletHistoryEntity] = [
        WalletHistoryEntity(statusTransaction: 0, balance: 100000, date: "03 November 2023"),
        WalletHistoryEntity(statusTransaction: 1, balance: 400000, date: "03 November 2023"),
        WalletHistoryEntity(statusTransaction: 1, balance: 200000, date: "03 November 2023"),
        WalletHistoryEntity(statusTransaction: 0, balance: 50000, date: "03 November 2023"),
        WalletHistoryEntity(statusTransaction: 0, balance: 25000, date: "03 November 2023"),
    ]
}


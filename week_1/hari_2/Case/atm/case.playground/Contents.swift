import Foundation

enum ErrorResponse: Error {
    case statusCode400
}

class AtmMachine {
    var balance: Double
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func checkBalance() {
        print("Your current balance is \(balance)")
    }
}
class Deposit {
    var transaction: AtmMachine

    init(transaction: AtmMachine) {
        self.transaction = transaction
    }
    
    func depositMoney(amount: Double) {
        transaction.balance += amount
        print("You deposited the amount of \(amount)")
    }
}

class Withdraw {
    var transaction: AtmMachine

    init(transaction: AtmMachine) {
        self.transaction = transaction
    }
    
    func withdrawMoney(amount: Double) throws {
        if transaction.balance == 0 {
            print("Your current balance is zero.")
            print("You cannot withdraw!")
            print("You need to deposit money first.")
        } else if transaction.balance <= amount {
            print("You do not have sufficient money to withdraw")
            print("Check your balance to see your money in the bank.")
        } else {
            transaction.balance -= amount
            print("You withdraw the amount of Rp \(amount)")
        }
    }
}

var balance: Double = 1000.0
let transaction = AtmMachine(balance: balance)
let depositTransaction = Deposit(transaction: transaction)
let withdrawTransaction = Withdraw(transaction: transaction)

let konversiStringKeDouble: (String) throws -> Double = { string in
    if let nilaiDouble = Double(string) {
        return nilaiDouble
    } else {
        throw ErrorResponse.statusCode400
    }
}

func selectMenu(menuIndex: Int) {
    do {
        switch menuIndex {
        case 1:
            let amount = try konversiStringKeDouble("a")
            depositTransaction.depositMoney(amount: amount)
        case 2:
            let amount = try konversiStringKeDouble("700")
            try withdrawTransaction.withdrawMoney(amount: amount)
        case 3:
            transaction.checkBalance()
        default:
            print("Exit")
        }
    } catch ErrorResponse.statusCode400 {
        print("Bad Request: Hanya menerima input angka.")
    } catch {
        print("Terjadi error lain: \(error)")
    }
}

selectMenu(menuIndex: 3)  // Check Balance
selectMenu(menuIndex: 1)  // Deposit 500
selectMenu(menuIndex: 3)  // Check Balance
selectMenu(menuIndex: 2)  // Withdraw 700
selectMenu(menuIndex: 3)  // Check Balance



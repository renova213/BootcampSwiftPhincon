import Foundation

class Deposit{
    var deposit: Double = 0
    
    var temporaryDeposit: Double{
        set(value){
            deposit = value > 0 ? 0 : value
        }
        
        get {
            return deposit
        }
    }
    
    init(deposit: Double) {
        self.deposit = deposit
    }
    
}

class Withdraw{
    var withdraw: Double
    
    init(withdraw: Double) {
        self.withdraw =  withdraw
    }
    
    func takeDraw(amount: Double) {
        self.withdraw -= amount
    }
}

class BalanceInquiry {
    var deposit: Double
    
    init(deposit: Double = 0.0) {
        self.deposit = deposit
    }
    
    func setDeposit(deposit: Double){
        self.deposit = deposit
    }
}

class ATMMachine  {
    
    var balance: Double = 0
    
    var deposit: Deposit = Deposit(deposit: 0)
    var withdraw: Withdraw = Withdraw(withdraw: 1000)
    
    init(balance: Double) {
        self.balance = balance
    }
    
    
    func checkBalance() {
        print("\tYour current balance is \(balance)")
    }
    
    func withdrawMoney() {
       if balance == 0 {
           print("\tYour current balance is zero.")
           print("\tYou cannot withdraw!")
           print("\tYou need to deposit money first.")
       } else if balance <= 500 {
           print("\tYou do not have sufficient money to withdraw")
           print("\tCheck your balance to see your money in the bank.")
       } else if withdraw.withdraw > balance {
           print("\tThe amount you withdraw is greater than your balance")
           print("\tPlease check the amount you entered.")
       } else {
           balance -= withdraw.withdraw
           print("\n\tYou withdraw the amount of Rp \(withdraw.withdraw)")
       }
   }
    
   func depositMoney() {
       print("\tYou deposited the amount of \(deposit.temporaryDeposit)")
   }
    
     func selectMenu(menuIndex: Int){
        switch (menuIndex){
        case 1:
            depositMoney()
            break
        case 2:
            withdrawMoney()
            break
        case 3:
            checkBalance()
            break
        default:
            print("Exit")
        }
        
        func main(){
            selectMenu(menuIndex: 1)
        }
    }
}

var atmMachine = ATMMachine(balance: 1000000)

atmMachine.selectMenu(menuIndex: 1)

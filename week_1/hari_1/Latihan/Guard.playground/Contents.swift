import Foundation

// Guard let adalah penjagaan yang apabila tidak sesuai kondisi maka blok fungsi akan di berhentikan
let possibleNumber = "123"

func checkGuardLet(){
    guard let number = Int(possibleNumber)else{
        fatalError("The number was invalid")
    }
    print(number)
}

checkGuardLet()

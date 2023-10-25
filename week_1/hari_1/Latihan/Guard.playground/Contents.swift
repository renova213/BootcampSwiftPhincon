import Foundation

// Guard let adalah penjagaan yang apabila tidak sesuai kondisi maka blok fungsi akan di berhentikan
let possibleNumber = "123"

func checkGuardLet()-> Int{
    guard let number = Int(possibleNumber)else{
        return 0
    }
    return number
}

print(checkGuardLet())

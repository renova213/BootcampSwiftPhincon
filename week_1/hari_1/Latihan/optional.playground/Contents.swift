import Foundation

//optional data
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)

print(convertedNumber)
var serverResponseCode: Int? = 404

serverResponseCode = nil

if serverResponseCode != nil {
    print("convertedNumber contains some integer value.")
}

// Optional Binding
if let actualNumber = Int(possibleNumber) {
    print("The string \"\(possibleNumber)\" has an integer value of \(actualNumber)")
} else {
    print("The string \"\(possibleNumber)\" couldn't be converted to an integer")
}

// another example
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber)")
}


import Foundation

var greeting = "Hello, playground"

// perulangan pada angka
for index in 1...5{
    print("\(index) times 5 is \(index * 5)")
}

// perulangan pada array
let names = ["Joko", "Susanto", "Sutrisno","Suparmin"]
for i in 0..<names.count{
    print("Person \(i+1) is called \(names[i])")
}

// perulangan dengan spesifik index
for name in names[2...] {
    
    if(name=="Sutrisno"){
        print(name)
    }
}

for name in names[...2] {
    print(name)
}



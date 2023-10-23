import Foundation

// mengupdate sebuah value variable dari variable yang sudah ada

let b = 10
var a = 5
a = b
// a sekarang sama dengan b

print(a)
print(b)

// assignment dengan tuple
let (x,y) = (1,2)
// x memiliki nilai sama dengan 1, dan y 2

// operator aritmatika

print(1 + 2)
print(5 - 3)
print(2 * 3)
print(10.0 / 2.5)

//operator modular

print(9 % 4)

// operator komparasi

print(1 == 1) // operator perbandingan sama (true)
print(2 != 1) // operator negasi (true)
print(2 > 1) // operator perbandingan lebih besar (true)
print(1 < 2) // operator perbandingan lebih kecil (true)
print(1 >= 1) // operator perbandingan lebih besar sama dengan (true)
print(2 <= 1) // operator perbandingan lebih kecil sama dengan (false)

// ternary operator
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
print(rowHeight)

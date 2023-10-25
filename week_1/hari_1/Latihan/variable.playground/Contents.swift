import Foundation

var greeting = "Hello, playground"
var nama:String = String()
var number:Int = Int()

var numberFloat:Float = 3.2
numberFloat = 4

var pekerjaan:String

nama="Rizco"

print("hallo, nama saya \(nama.lowercased())")

let phi: Double = 3.14

//phi = 2.76

//kondisi optional
var sekolah: String?

print(sekolah ?? "sekolah")

var text:String

//inisiasi banyak variable
var red, green, blue : Double

//Type Alias
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min

var http404Error = (404, "Not Found")

http404Error.0 = 405

var (statusCode, statusMessage) = http404Error

print("The status code is \(statusCode)")
print("The status message is \(statusMessage)")

//array string
var kelonmpokHewan :[String] = ["tikus","kucing","anjing"]
print(kelonmpokHewan)
print(kelonmpokHewan[0])

var optional:String?


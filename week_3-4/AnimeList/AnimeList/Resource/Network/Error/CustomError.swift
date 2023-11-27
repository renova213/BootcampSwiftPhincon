import Foundation

struct CustomError: Error {
    let statusCode: HTTPStatusCode
    let message: String

    var errorDescription: String? {
        return "HTTP Status Code \(statusCode.rawValue): \(message)"
    }
}

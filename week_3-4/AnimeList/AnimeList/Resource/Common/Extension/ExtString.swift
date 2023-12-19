import Foundation

extension String {
    func convertToCustomDateFormat() -> String? {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            if let date = inputFormatter.date(from: self) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                return outputFormatter.string(from: date)
            } else {
                return nil
            }
        }
}

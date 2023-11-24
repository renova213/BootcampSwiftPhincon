import Foundation

class StatusResponse:Codable{
    let message: String
    let status: String
    
    private enum CodingKeys: String, CodingKey{
        case message, status
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decodeIfPresent(String.self, forKey: .message)) ?? ""
        status = (try? values.decodeIfPresent(String.self, forKey: .status)) ?? ""
    }
    
    init(message: String, status: String) {
        self.message = message
        self.status = status
     }
 }

import Foundation

struct AnimeCharacterData: Codable{
    var data: [AnimeCharacterEntity]
}

struct AnimeCharacterEntity: Codable {
    let character: AnimeCharacter?
    let role: String?
    let favorites: Int?
    let voiceActors: [AnimeVoiceActor]?
    
    enum CodingKeys: String, CodingKey {
        case character, role, favorites
        case voiceActors = "voice_actors"
    }
}

struct AnimeCharacter: Codable {
    let malID: Int?
    let url: String?
    let images: CharacterImages?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, images, name
    }
}

struct CharacterImages: Codable {
    let jpg: Jpg?
    let webp: Webp?
}

struct Jpg: Codable {
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

struct Webp: Codable {
    let imageURL, smallImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
    }
}

struct AnimeVoiceActor: Codable {
    let person: Person?
    let language: String?
}

struct Person: Codable {
    let malID: Int?
    let url: String?
    let images: PersonImages?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, images, name
    }
}

struct PersonImages: Codable {
    let jpg: Jpg?
}

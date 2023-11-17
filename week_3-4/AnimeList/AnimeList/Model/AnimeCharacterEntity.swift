import Foundation

struct AnimeCharacterEntity: Codable {
    let character: Character
    let role: String
    let favorites: Int
    let voiceActors: [VoiceActor]

    enum CodingKeys: String, CodingKey {
        case character, role, favorites
        case voiceActors
    }
}

struct Character: Codable {
    let malID: Int
    let url: String
    let images: CharacterImages
    let name: String

    enum CodingKeys: String, CodingKey {
        case malID
        case url, images, name
    }
}

struct CharacterImages: Codable {
    let jpg: Jpg
    let webp: Webp
}

struct Jpg: Codable {
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL
    }
}

struct Webp: Codable {
    let imageURL, smallImageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL
        case smallImageURL
    }
}

struct VoiceActor: Codable {
    let person: Person
    let language: String
}

struct Person: Codable {
    let malID: Int
    let url: String
    let images: PersonImages
    let name: String

    enum CodingKeys: String, CodingKey {
        case malID
        case url, images, name
    }
}

struct PersonImages: Codable {
    let jpg: Jpg
}

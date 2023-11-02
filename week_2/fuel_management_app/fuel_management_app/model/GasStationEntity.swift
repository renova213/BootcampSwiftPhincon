//
//  GasStationEntity.swift
//  latihan_hari_1
//
//  Created by Phincon on 30/10/23.
//

import Foundation

struct GasStationEntity {
    var name:String
    var address:String
    var reviews: [ReviewEntity]
    var totalReview: Int
    var rating: Double
    var location: String
    var imageAsset: String
    
    init(name: String, address: String, reviews: [ReviewEntity] = [], totalReview: Int, rating: Double , location: String , imageAsset: String) {
        self.name = name
        self.address = address
        self.reviews = reviews
        self.totalReview = totalReview
        self.rating = rating
        self.location = location
        self.imageAsset = imageAsset
    }
    
    static let gasStations: [GasStationEntity] = [
        GasStationEntity(name: "SPBU Baros", address: "Jl. Raya Baros No. E 47. Cimahi, Jawa Barat, Indonesia 40521", totalReview: 244, rating: 4.5, location: "Depok", imageAsset: "GasStation"),
        GasStationEntity(name: "SPBU Cigodeg", address: "Jl. Didi Sukardi No. 108. Sukabumi, Jawa Barat, Indonesia", totalReview: 160, rating: 4.5, location: "Jakarta", imageAsset: "GasStation2"),
        GasStationEntity(name: "SPBU Citayam    ", address: "Jl. Raya Citayam, Pd. Jaya, Cipayung, Kota Depok Depok, Jawa Barat, Indonesia 16431", totalReview: 100, rating: 4.1, location: "Cipayung", imageAsset: "GasStation2"),
    ]
}

struct ReviewEntity {
    var review: String
    var rating: Double
    
    init(review: String, rating: Double) {
        self.review = review
        self.rating = rating
    }
}

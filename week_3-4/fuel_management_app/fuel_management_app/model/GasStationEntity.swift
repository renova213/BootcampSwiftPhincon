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
    var urlImage: String
    
    init(name: String, address: String, reviews: [ReviewEntity] = [], totalReview: Int, rating: Double , location: String, imageAsset: String, urlImage: String) {
        self.name = name
        self.address = address
        self.reviews = reviews
        self.totalReview = totalReview
        self.rating = rating
        self.location = location
        self.urlImage = urlImage
    }
    
    static let gasStations: [GasStationEntity] = [
        GasStationEntity(name: "SPBU Baros", address: "Jl. Raya Baros No. E 47. Cimahi, Jawa Barat, Indonesia 40521", totalReview: 244, rating: 4.5, location: "Cimahi", imageAsset: "GasStation", urlImage: "https://3.bp.blogspot.com/-YdvxXDj9Puc/V99EASfVNPI/AAAAAAAAA6c/efEGrR0A0vwBUPup3aZkpW5r-5ifTNndgCLcB/s1600/SPBU%2Bbaros.png"),
        GasStationEntity(name: "SPBU Cigodeg", address: "Jl. Didi Sukardi No. 108. Sukabumi, Jawa Barat, Indonesia", totalReview: 160, rating: 4.5, location: "Jakarta", imageAsset: "GasStation2", urlImage: "https://images.autofun.co.id/file1/f2043621d7074eb192510a21726b0f54_678x380.jpg"),
        GasStationEntity(name: "SPBU Citayam", address: "Jl. Raya Citayam, Pd. Jaya, Cipayung, Kota Depok Depok, Jawa Barat, Indonesia 16431", totalReview: 100, rating: 4.1, location: "Cipayung", imageAsset: "GasStation2", urlImage: "https://carnetwork.s3.ap-southeast-1.amazonaws.com/file/06fa2bdcd205419baf0cd72b7fb64d1c.jpg"),
        GasStationEntity(name: "SPBU Citayam", address: "Jl. Raya Citayam, Pd. Jaya, Cipayung, Kota Depok Depok, Jawa Barat, Indonesia 16431", totalReview: 100, rating: 4.1, location: "Cipayung", imageAsset: "GasStation2", urlImage: "https://carnetwork.s3.ap-southeast-1.amazonaws.com/file/06fa2bdcd205419baf0cd72b7fb64d1c.jpg")
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

//
//  DashboardCategoryEntity.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import Foundation
import UIKit

struct DashboardCategoryEntity {
    let title: String
    let icon: UIImage
    
    init(title: String, icon: UIImage) {
        self.title = title
        self.icon = icon
    }
    
    static let items: [DashboardCategoryEntity] = [
    DashboardCategoryEntity(title: "Peringkat Anime", icon: UIImage(systemName: "sparkles.tv")!),
    DashboardCategoryEntity(title: "Peringkat Manga", icon: UIImage(systemName: "book")!),
    DashboardCategoryEntity(title: "Daftar Permusim", icon: UIImage(systemName: "list.bullet.rectangle.portrait")!),
    DashboardCategoryEntity(title: "Kalender", icon: UIImage(systemName: "calendar")!)
    ]
}

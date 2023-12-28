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
        DashboardCategoryEntity(title: .localized("topAnime"), icon: UIImage(systemName: "sparkles.tv")!),
        DashboardCategoryEntity(title: .localized("topManga"), icon: UIImage(systemName: "book")!),
        DashboardCategoryEntity(title: .localized("animeSeason"), icon: UIImage(systemName: "list.bullet.rectangle.portrait")!),
        DashboardCategoryEntity(title: .localized("schedule"), icon: UIImage(systemName: "calendar")!)
    ]
}

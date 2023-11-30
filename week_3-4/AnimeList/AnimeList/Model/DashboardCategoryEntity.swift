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
    DashboardCategoryEntity(title: "Top Anime", icon: UIImage(systemName: "sparkles.tv")!),
    DashboardCategoryEntity(title: "Top Manga", icon: UIImage(systemName: "book")!),
    DashboardCategoryEntity(title: "List Season", icon: UIImage(systemName: "list.bullet.rectangle.portrait")!),
    DashboardCategoryEntity(title: "Schedule", icon: UIImage(systemName: "calendar")!)
    ]
}

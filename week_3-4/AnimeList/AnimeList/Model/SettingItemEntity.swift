import Foundation

struct SettingItemEntity {
    let assetImage: String
    let title: String
    
    static let items:[SettingItemEntity] = [
    SettingItemEntity(assetImage: "pencil_line", title: "Update Profile"),
    SettingItemEntity(assetImage: "rectangle.and.pencil.and.ellipsis", title: "Change Password"),
    SettingItemEntity(assetImage: "paintbrush.fill", title: "Clear Cache"),
    SettingItemEntity(assetImage: "rectangle.portrait.and.arrow.right.fill", title: "Sign Out")
    ]
}

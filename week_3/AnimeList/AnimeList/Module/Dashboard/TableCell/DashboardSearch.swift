//
//  DashboardSearch.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import UIKit

class DashboardSearch: UITableViewCell {
    
    @IBOutlet weak var dashboardSearchView: UIView!
    @IBOutlet weak var dashboardSearchField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewStyle()
        searchFieldStyle()
    }

    func searchFieldStyle(){
        dashboardSearchField.borderStyle = .none
    }
    
    func viewStyle(){
        dashboardSearchView.roundCornersAll(radius: 15)
        dashboardSearchView.layer.borderWidth = 1
        dashboardSearchView.layer.borderColor = UIColor.init(named: "Main Color")?.cgColor
    }
}

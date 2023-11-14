//
//  DashboardSearch.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//


import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol DashboardSearchDelegate: AnyObject {
    func didSelectCell(text: String)
}

class DashboardSearch: UITableViewCell {
    
    @IBOutlet weak var dashboardSearchView: UIView!
    @IBOutlet weak var dashboardSearchField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
        textFieldEvent()
    }
    
    weak var delegate: DashboardSearchDelegate?
    let disposeBag = DisposeBag()
    
    func configureComponentStyle(){
        dashboardSearchField.borderStyle = .none

        dashboardSearchView.roundCornersAll(radius: 15)
        dashboardSearchView.layer.borderWidth = 1
        dashboardSearchView.layer.borderColor = UIColor.init(named: "Main Color")?.cgColor
    }
    
    private func textFieldEvent() {
        dashboardSearchField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.delegate?.didSelectCell(text: self?.dashboardSearchField.text ?? "")
                self?.dashboardSearchField.text = ""
            }
            .disposed(by: disposeBag)
    }
}

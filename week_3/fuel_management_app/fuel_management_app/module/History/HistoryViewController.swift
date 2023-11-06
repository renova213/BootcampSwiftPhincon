//
//  HistoryViewController.swift
//  latihan_hari_1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    func registerCell(){
        historyTable.delegate = self
        historyTable.dataSource = self
        
        historyTable.registerCellWithNib(HistoryCard.self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        
        
        let historyCard = tableView.dequeueReusableCell(forIndexPath: indexPath) as HistoryCard
        return historyCard
    }

}


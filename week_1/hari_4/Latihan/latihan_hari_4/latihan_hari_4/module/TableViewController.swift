//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var listViewTable: UITableView!
    
    let carNames: [String] = [
    "HYUNDAI",
    "TOYOTA",
    "DAIHATSU",
    "HONDA",
    "MITSUBISHI",
    "SUZUKI",
    "WULING",
    "CHERY"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listViewTable.delegate = self
        listViewTable.dataSource = self
        listViewTable.registerCellWithNib(TableViewCell.self)
        

        // Do any additional setup after loading the view.
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


extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TableViewCell
        
        cell.carLabel.text = carNames[indexPath.item]
       
        return cell
    }
}

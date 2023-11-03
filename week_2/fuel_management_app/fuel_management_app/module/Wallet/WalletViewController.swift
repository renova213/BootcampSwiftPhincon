//
//  WalletViewController.swift
//  fuel_management_app
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var bubble1: UIView!
    @IBOutlet weak var bubble2: UIView!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var walletContainer: UIView!
    @IBOutlet weak var walletTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUpStyleComponent() }
    
    func setUpStyleComponent(){
        topContainer.roundCornersAll(radius: 20)
       
        walletContainer.roundCornersAll(radius: 16)
       
        bubble1.makeCircular()
        bubble1.backgroundColor = UIColor(named: "Main Color")?.withAlphaComponent(0.15)
        
        bubble2.makeCircular()
        bubble2.backgroundColor = UIColor(named: "Main Color")?.withAlphaComponent(0.25)
    }
    
    func registerCell(){
        walletTable.delegate = self
        walletTable.dataSource = self
        
        walletTable.registerCellWithNib(WalletItem.self)
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

extension WalletViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        
        let walletItem = tableView.dequeueReusableCell(forIndexPath: indexPath) as WalletItem
        
        return walletItem
    }
}



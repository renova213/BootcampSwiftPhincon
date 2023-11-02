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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpStyleComponent() }
    
    func setUpStyleComponent(){
        topContainer.roundRadius(topLeft: 0, topRight: 0, bottomLeft: 20, bottomRight: 20)
       
        walletContainer.roundRadius(topLeft: 16, topRight: 16, bottomLeft: 16, bottomRight: 16)
       
        bubble1.makeCircular()
        bubble1.backgroundColor = UIColor(named: "Main Color")?.withAlphaComponent(0.15)
        
        bubble2.makeCircular()
        bubble2.backgroundColor = UIColor(named: "Main Color")?.withAlphaComponent(0.25)
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



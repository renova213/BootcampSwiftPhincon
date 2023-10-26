//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "registerScreen")
                self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    @IBAction func loginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "homeScreen", sender: nil)
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

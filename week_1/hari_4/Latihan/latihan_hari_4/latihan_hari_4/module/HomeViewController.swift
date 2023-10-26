//
//  ProfileViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.2
        container.layer.shadowOffset = CGSize(width: 2, height: 2)
        container.layer.shadowRadius = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dashboardButton(_ sender: Any) {
        let vc = TableViewController()
                self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func registerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "registerScreen")
                self.navigationController?.pushViewController(destinationViewController, animated: true)
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

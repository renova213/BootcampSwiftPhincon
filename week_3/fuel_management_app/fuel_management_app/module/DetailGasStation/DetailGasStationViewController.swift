//
//  DetailGasStationViewController.swift
//  latihan_hari_1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

protocol DetailGasStationDelegate {
    func didTapGasStation(data: GasStationEntity)
}


class DetailGasStationViewController: UIViewController {

    @IBOutlet weak var gasStationImage: UIImageView!
    
    var selectedId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        gasStationImage.image = UIImage(named: "GasStation")
        setUp()
    }
    
    func setUp()  {
        
        if let id = selectedId {
            print(id)
        }
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

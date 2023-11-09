//
//  HistoryViewController.swift
//  latihan_hari_1
//
//  Created by Phincon on 30/10/23.
//

import UIKit
import FloatingPanel

class HistoryViewController: UIViewController {
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var filterImage: UIImageView!
    
    var fpc = FloatingPanelController()
    
    override func viewDidLoad() {
        fpc = FloatingPanelController()

             // Assign self as the delegate of the controller.
             fpc.delegate = self // Optional

             // Set a content view controller.
             let contentVC = FloatingPanelController()
             fpc.set(contentViewController: contentVC)

             // Add and show the views managed by the `FloatingPanelController` object to self.view.
             fpc.addPanel(toParent: self)
        setUp()
        
    }
    @objc func imageTapped() {
        showFloatingPanel()
        print("tapped")
    }
    
    func setUp(){
        registerCell()
        setUpGesture()
    }
    
}

extension HistoryViewController {
    func registerCell(){
        historyTable.delegate = self
        historyTable.dataSource = self
        
        historyTable.registerCellWithNib(HistoryCard.self)
    }
    
    func setUpGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        filterImage.isUserInteractionEnabled = true
        filterImage.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension HistoryViewController: FloatingPanelControllerDelegate{
       
       func showFloatingPanel() {
           let contentVC = FloatingPanelViewController()
           fpc.set(contentViewController: contentVC)

           fpc.isRemovalInteractionEnabled = true // Optional: Let it removable by a swipe-down

           self.present(fpc, animated: true, completion: nil)
           
       }
       
       func setupFloatingPanelGesture() {
           let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
           filterImage.isUserInteractionEnabled = true
           filterImage.addGestureRecognizer(tapGestureRecognizer)
       }
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

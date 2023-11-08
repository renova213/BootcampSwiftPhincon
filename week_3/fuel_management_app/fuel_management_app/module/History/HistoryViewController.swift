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
    
    let fpc = FloatingPanelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    @objc func imageTapped() {
        showFloatingPanel()
        print("tapped")
    }
    
    func setUp(){
        registerCell()
        setupFloatingPanel()
        setUpGesture()
        setupFloatingPanelGesture()
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
    func setupFloatingPanel() {
           fpc.delegate = self
           
           let contentVC = FloatingPanelViewController()
           fpc.set(contentViewController: contentVC)
           
        fpc.surfaceView.layer.cornerRadius = 12.0
       }
       
       func showFloatingPanel() {
           guard fpc.state != .full else { return }
           fpc.set(contentViewController: FloatingPanelViewController())
           fpc.show(animated: true, completion: nil)
           
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

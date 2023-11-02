//
//  OnboardingViewController.swift
//  fuel_management_app
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        animationSetup()
    }
    
    @IBAction func startButtonTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.setViewControllers([destinationViewController], animated: true)
    }
    
    func animationSetup(){
        onboardingImage.alpha = 0
        let initialButtonPosition = startButton.frame.origin.y
        titleLabel.alpha = 0
        startButton.transform = CGAffineTransform(translationX: 0, y: 200)

        UIView.transition(with: onboardingImage, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.onboardingImage.alpha = 1
        }, completion: { finished in
            // Animasi fade-in untuk titleLabel setelah selesai animasi onboardingImage
            UIView.transition(with: self.titleLabel, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.titleLabel.alpha = 1
            }, completion: { finished in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.startButton.transform = .identity // Kembalikan posisi ke posisi awal
                }, completion: { _ in
                    // Tambahkan sedikit efek goyang setelah animasi selesai
                    UIView.animate(withDuration: 0.1, animations: {
                        self.startButton.frame.origin.y = initialButtonPosition - 20
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.startButton.frame.origin.y = initialButtonPosition
                        })
                    })
                })
                
            })
        })
        
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

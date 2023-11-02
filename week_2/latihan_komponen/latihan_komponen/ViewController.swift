//
//  ViewController.swift
//  latihan_komponen
//
//  Created by Phincon on 31/10/23.
//

import UIKit
import StepSlider

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var stepSliderLabel: UILabel!
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSliderTextLabel()
        setUpStepSliderTextLabel()
        setUpSwitch()
        setUpPickerView()
    }
    
    func setUpPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
    func setUpSwitch(){
        containerView.backgroundColor = UIColor.red
        switchButton.isOn = false
        switchButton.addTarget(self, action: #selector(switchValueChanged ), for: .valueChanged)
    }
    
    @objc func switchValueChanged() {
        if switchButton.isOn {
            // Change containerView background color to blue if switch is on
            containerView.backgroundColor = UIColor.blue
        } else {
            // Change containerView background color back to red if switch is off
            containerView.backgroundColor = UIColor.red
        }
    }
    
    func setUpSliderTextLabel(){
        sliderLabel.text = "Selected Step Slider: 0"
        slider.addTarget(self, action: #selector(sliderValueChanged ), for: .valueChanged)
        slider.minimumValue = 1
        slider.maximumValue = 100
    }
    
    func setUpStepSliderTextLabel(){
        stepSlider.addTarget(self, action: #selector(stepSliderValueChanged), for: .valueChanged)
        stepSliderLabel.text = "Selected Step Slider: \(stepSlider.index)"
    }
    
    @objc func stepSliderValueChanged() {
        stepSliderLabel.text = "Selected step: \(stepSlider.index)"
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        sliderLabel.text = "Selected step: \(value)"
    }
}



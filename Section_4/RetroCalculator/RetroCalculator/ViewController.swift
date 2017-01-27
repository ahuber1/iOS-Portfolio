//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Andrew Huber on 1/12/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var calculatorLabel: UILabel!
    
    
    var brain = CalculatorBrain()
    var buttonSound: AVAudioPlayer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOf: soundURL)
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
        
        buttonSound.prepareToPlay()
        calculatorLabel.text = "0"
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        calculatorLabel.text = brain.give(character: String(sender.tag))
    }
    
    @IBAction func dividePressed(_ sender: UIButton) {
        operationPressed(.divide)
    }
    
    @IBAction func multiplyPressed(_ sender: UIButton) {
        operationPressed(.multiply)
    }
    
    @IBAction func subtractPressed(_ sender: UIButton) {
        operationPressed(.subtract)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        operationPressed(.add)
    }
    
    @IBAction func equalsPressed(_ sender: UIButton) {
        playSound()
        if let newText = brain.evaluate() {
            calculatorLabel.text = newText
        }
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        playSound()
        calculatorLabel.text = brain.clear()
    }
    
    private func operationPressed(_ operation: CalculatorBrain.Operation) {
        playSound()
        if let newText = brain.setOperation(operation) {
            calculatorLabel.text = newText
        }
    }
    
    private func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
}

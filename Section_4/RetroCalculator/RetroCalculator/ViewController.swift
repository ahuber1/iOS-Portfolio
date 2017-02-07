//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Andrew Huber on 1/12/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import AVFoundation // allows the app to play the song

class ViewController: UIViewController {
    
    /** The `UILabel` that acts as the screen for the calculator. */
    @IBOutlet weak var calculatorLabel: UILabel!
    
    /** The "brain" of the calculator. This performs all of the logic for this app (i.e., this is the model in the MVC) */
    var brain: CalculatorBrain!
    
    /** The sound that plays every time a button is pressed. */
    var buttonSound: AVAudioPlayer!
    
    // Makes the status bar in this app (displays the time, battery level, etc.) have white text
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    // Sets up the button sound, sets the screen of the calculator so it displays "0", 
    // and creates the "brain" of the calculator
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
        brain = CalculatorBrain(calculatorDisplay: calculatorLabel)
    }
    
    /**
     Called whenever a number is pressed on the calculator
     
     - parameters:
        - sender: the `UIButton` that was pressed
     */
    @IBAction func numberPressed(_ sender: UIButton) {
        playSound()
        calculatorLabel.text = brain.give(stringContainingDigit: String(sender.tag))
    }
    
    /**
     Called whenever the divide button is pressed
     
     - parameters:
        - sender: the `UIButton` that was pressed
     */
    @IBAction func dividePressed(_ sender: UIButton) {
        operationPressed(.divide)
    }
    
    /**
     Called whenever the multiply button is pressed
     
     - parameters:
     - sender: the `UIButton` that was pressed
     */
    @IBAction func multiplyPressed(_ sender: UIButton) {
        operationPressed(.multiply)
    }
    
    /**
     Called whenever the subtract button is pressed
     
     - parameters:
     - sender: the `UIButton` that was pressed
     */
    @IBAction func subtractPressed(_ sender: UIButton) {
        operationPressed(.subtract)
    }
    
    /**
     Called whenever the add button is pressed
     
     - parameters:
     - sender: the `UIButton` that was pressed
     */
    @IBAction func addPressed(_ sender: UIButton) {
        operationPressed(.add)
    }
    
    /**
     Called whenever the equals button is pressed
     
     - parameters:
     - sender: the `UIButton` that was pressed
     */
    @IBAction func equalsPressed(_ sender: UIButton) {
        playSound()
        if let newText = brain.evaluate() {
            calculatorLabel.text = newText
        }
    }
    
    /**
     Called whenever the clear button is pressed
     
     - parameters:
     - sender: the `UIButton` that was pressed
     */
    @IBAction func clearPressed(_ sender: UIButton) {
        playSound()
        calculatorLabel.text = brain.clear()
    }
    
    /**
     The following functions call this function so that code is not repeated in the following functions.
     
     1. `addPressed(_ sender: UIButton)`
     2. `subtractPressed(_ sender: UIButton)`
     3. `multiplyPressed(_ sender: UIButton)`
     4. `dividePressed(_ sender: UIButton)`
     
     - parameters:
        - operation: the operation that was selected
     */
    private func operationPressed(_ operation: CalculatorBrain.Operation) {
        playSound()
        if let newText = brain.setOperation(operation) {
            calculatorLabel.text = newText
        }
    }
    
    /** Plays the button sound. */
    private func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
}

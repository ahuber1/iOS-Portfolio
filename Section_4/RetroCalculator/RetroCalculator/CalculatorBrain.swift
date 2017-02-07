//
//  CalculatorBrain.swift
//  RetroCalculator
//
//  Created by Andrew Huber on 1/13/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

/**
    Contains the logic behind the retro calculator.
 
    - author: Andrew Huber
 */
class CalculatorBrain {
    
    /** The string `"0"` */
    private static let zero = "0"
    
    /** The error message that will be displayed when there is an arithmetic overflow. */
    private static let overflowMessage = "Overflow"
    
    /** The operator on the "left side" */
    private var leftSide:  String = CalculatorBrain.zero
    
    /** The operator on the "right side" */
    private var rightSide: String = CalculatorBrain.zero
    
    /** The value that was evaluated after a calculation */
    private var evaluatedValue: CalculatedValue = .noValue
    
    /** The operation to apply to `leftSide` and `rightSide` (e.g., add, subtract, etc.) */
    private var operation: Operation? = nil
    
    /** The last button that was pressed */
    private var previousButtonPressed: PreviousButtonPressed = .noButtonsPressedYet
    
    /**
     Creates a new `CalculatorBrain` instance.
     
     - parameters:
        - calculatorDisplay: the `UILabel` that is being used as the calculator's display. 
            **This** `UILabel` **is not stored in** `CalculatorBrain`. Instead, the initializer 
            checks to ensure that the `UILabel` contains the text `"0"`, which is vital in order 
            to prevent logic errors.
     
     - note: if the text in `calculatorDisplay` is not `"0"`, a fatal error is thrown.
     */
    init(calculatorDisplay: UILabel) {
        
        if calculatorDisplay.text != "0" {
            fatalError("The calculator's display must contain the text \"0\"")
        }
        
        _ = clear()
    }
    
    /**
        Call this function whenever you what to give a digit to the `CalculatorBrain` (i.e., whenever the user presses a digit)
     
        - parameters:
            - digit: the digit that the user pressed
     
        - returns: what the calculator display should display
     */
    func give(stringContainingDigit digit: String) -> String {
        
        if digit.characters.count != 1 {
            fatalError("You can only give one character to the CalculatorBrain")
        }
        if digit.rangeOfCharacter(from: CharacterSet.decimalDigits)?.lowerBound != digit.startIndex {
            fatalError("A digit was not given to the CalculatorBrain")
        }
        
        switch evaluatedValue {
        // If there was a calculated value or if an arithmetic overflow occurred, then we need to reset the calculator
        case .valueWasCalculated(_), .arithmeticOverflowOccurred:
            _ = clear()
        default:
            break // Otherwise, we don't need to do anything
        }
        
        // set previousButtonPressed to .number since this function is called when a number is given to the CalculatorBrain
        previousButtonPressed = .number
        
        // If there is no operation set, then the calculator is displaying leftSide. Otherwise, it is displaying rightSide
        var currentCalculatorDisplayContents: String { return (operation == nil ? leftSide : rightSide) }
        
        // The contents that will be displayed in the calculator's display
        let futureCalculatorDisplayContents: String
        
        // Prevents the label from reading "00" or "000" or "0000", etc.
        if (currentCalculatorDisplayContents == CalculatorBrain.zero && digit == CalculatorBrain.zero) == false {
            // If currentCalculatorDisplayContents is "0", but character is not "0"
            if currentCalculatorDisplayContents == CalculatorBrain.zero {
                futureCalculatorDisplayContents = digit
            }
            // If currentCalculatorDisplayContents nor character is "0"
            else {
                futureCalculatorDisplayContents = currentCalculatorDisplayContents + digit
            }
        }
        // If currentCalculatorDisplayContents and cahracter are both "0", then the calculator's display does not change
        else {
            futureCalculatorDisplayContents = currentCalculatorDisplayContents
        }
        
        // If there is no operation, then the left side needs to be set. Otherwise, the right side needs to be set
        if operation == nil {
            leftSide = futureCalculatorDisplayContents
        }
        else {
            rightSide = futureCalculatorDisplayContents
        }
        
        // Return what the calculator display should display
        return futureCalculatorDisplayContents
    }
    
    /**
        Call this function whenever the user presses the equals button on the calculator.
        This function performs the calculation.
     
        - returns: the result of the evaluation as a string and, as such, should be the string 
          that is displayed in the calculator's display, or nil if the evaluation cannot take place yet
          and, as such, should not cause the calculator's display to change.
     */
    func evaluate() -> String? {
        if previousButtonPressed == .equals {
            switch evaluatedValue {
            // If the equal button is pressed after a value was calculated, the evaluated value should
            // be stored in the in left side, and the calculation should be performed again. For example,
            // if the user pressed 2 -> x -> x -> = ,
            //  
            //      leftSide       = 2
            //      rightSide      = 2
            //      operation      = multiply
            //      evaluatedValue = 4
            //
            // However, if the equal button is pressed again, the following should be true so the four is 
            // multiplied by 2 again, and the user gets the expected answer of 6.
            //
            //      leftSide       = 4
            //      rightSide      = 2
            //      operation      = multiply
            //      evaluatedValue = 6
            //
            // This code handles this case.
            case .valueWasCalculated(let value):
                leftSide = String(describing: value)
                evaluatedValue = .noValue // set this in order to trigger this function to perform the new calculation
                
            // If an arithmetic overflow occurred, pressing the equal sign again will not change this fact.
            // Therefore, return nil.
            case .arithmeticOverflowOccurred:
                return nil
                
            // If evaluatedValue is .noValue
            default:
                // this should never execute!!!
                fatalError("The evaluate() function is not behaving as intended. evaluatedValue = .noValue")
            }
        }
        
        // Update previousButtonPressed to .equals so we know that the user pressed the equals button at a future time.
        previousButtonPressed = .equals
        
        // If the calculation has not been performed yet, perform it if possible, and return the result of the calculation,
        // whether that be the actual value calculated, or CalculatorBrain.overflowMessage on an arithmetic overflow.
        // Otherwise, return nil.
        switch evaluatedValue {
        case .noValue:
            if let op = operation {
                // If nil was NOT returned by op.performCalculation(leftSide: Int, rightSide: Int), then the calculation
                // was performed without an overflow. Therefore, store the value that was calculated in evaluatedValue,
                // and return the calculated value as a string.
                if let calculatedValue = op.performCalculation(leftSide: Int(leftSide)!, rightSide: Int(rightSide)!) {
                    evaluatedValue = .valueWasCalculated(calculatedValue)
                    return String(describing: calculatedValue)
                }
                
                // If an arithmetic overflow occurred, make evaluatedValue equal to .arithmeticOVerflowOccurred, and
                // return CalculatorBrain.overflowMessage
                else {
                    evaluatedValue = .arithmeticOverflowOccurred
                    return CalculatorBrain.overflowMessage
                }
            }
        default:
            break
        }
        
        return nil
    }
    
    /**
        Call this function whenever the add, subtract, multiply, or divide button is pressed
     
        - parameters:
            - newValue: the operation
     
        - returns: the result of the evaluation as a string and, as such, should be the string
          that is displayed in the calculator's display, or nil if the evaluation cannot take place yet
          and, as such, should not cause the calculator's display to change.
     */
    func setOperation(_ newValue: Operation) -> String? {
        // If the right side is not set, then the calculator's display should still display leftSide.
        // Therefore, leftSide is returned, but before that is done, previousButtonPressed and operation
        // are set for future use.
        if rightSide == CalculatorBrain.zero {
            previousButtonPressed = .operation
            operation = newValue
            return leftSide
        }
            
        // If leftSide and rightSide have been assigned, then evaluate left and right side if necessary,
        // store the evaluated value, clear the calculator, set leftSide to that evaluated value, and 
        // recursively call this function so the value that the calculator should display is returned.
        else {
            var nextLeftSide: String!
            
            if previousButtonPressed == .equals {
                switch evaluatedValue {
                case .valueWasCalculated(let value):
                    nextLeftSide = String(describing: value)
                case .noValue:
                    nextLeftSide = evaluate()!
                default: // if there was an arithmetic overflow
                    return nil
                }
            }
            
            _ = clear()
            leftSide = nextLeftSide
            return setOperation(newValue)
        }
    }
    
    /**
        Clears the `CalculatorBrain`
     
        - returns: the text that should be displayed on the calculator's display.
     */
    func clear() -> String {
        leftSide = CalculatorBrain.zero
        rightSide = CalculatorBrain.zero
        evaluatedValue = .noValue
        operation = nil
        previousButtonPressed = .noButtonsPressedYet
        return CalculatorBrain.zero
    }
    
    /** An `enum` that is used to keep track of the previous button pressed */
    enum PreviousButtonPressed {
        /** The previous button that was pressed was either add, subtract, multiply, or divide */
        case operation
        
        /** The previous button that was pressed was a digit */
        case number
        
        /** Equals was the previous button that was pressed */
        case equals
        
        /** There is no button that was pressed yet */
        case noButtonsPressedYet
    }
    
    /** An `enum` that is used to keep track of the operation that will be performed (e.g., add, subtract, etc.) */
    enum Operation {
        /** Addition */
        case add
        
        /** Subtraction */
        case subtract
        
        /** Multiplication */
        case multiply
        
        /** Division */
        case divide
        
        /**
         Performs the calculation using the operation stored in `self`. For example, you can do the following
         to add 2 and 3 together. In this example, `"2 + 3 = 6"` **will** print; `"2 + 3 resulted in an overflow"` 
         will **not** print.
         
                let left = 2
                let right = 3
                let operation = Operation.add
                if let sum = operation.performCalculation(leftSide: left, rightSide: right) {
                    print("\(left) + \(right) = \(sum)")
                }
                else {
                    print("\(left) + \(right) resulted in an overflow")
                }
             
        
         
         - parameters:
            - leftSide: the number that goes on the left side of the operator
            - rightSide: the number that goes on the right side of the operator
         
         - returns: the result of the calculation, or `nil` if an overflow occurred.
         */
        func performCalculation(leftSide: Int, rightSide: Int) -> Int? {
            let function: (Int, Int) -> (Int, Bool)
            
            switch self {
            case .add:
                function = Int.addWithOverflow
            case .subtract:
                function = Int.subtractWithOverflow
            case .multiply:
                function = Int.multiplyWithOverflow
            default:
                function = Int.divideWithOverflow
            }
            
            let (calculatedValue, didOverflow) = function(leftSide, rightSide)
            
            return didOverflow ? nil : calculatedValue
        }
    }
   
    /**
     This `enum` is used to store the value that was calculated. This behaves in a similar way as the `Optional` `enum` 
     used in Swift, but instead of having `none` and `some` as values, this `enum` has `noValue`, `valueWasCalculated(Int)`
     where the `Int` is the value that was calculated, **and** `arithmeticOverflowOccurred`, which is used when an arithmetic
     overflow occurred during the calculation.
     */
    enum CalculatedValue {
        /** No value has been calculated yet (i.e., identical in meaning to the `none` member of Swift's `enum`, `Optional`) */
        case noValue
        
        /** Used when a value was calculated, and the value that was calculated is the `Int` */
        case valueWasCalculated(Int)
        
        /** Used when a value was calculated, but it resulted in an arithmetic overflow */
        case arithmeticOverflowOccurred
    }
}

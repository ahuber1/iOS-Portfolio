//
//  CalculatorBrain.swift
//  RetroCalculator
//
//  Created by Andrew Huber on 1/13/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class CalculatorBrain {
    private static let zero = "0"
    private static let overflowMessage = "Overflow"
    
    private var leftSide:  String = CalculatorBrain.zero
    private var rightSide: String = CalculatorBrain.zero
    private var evaluatedValue: CalculatedValue = .noValue
    private var operation: Operation? = nil
    private var previousButtonPressed: PreviousButtonPressed = .noButtonsPressedYet
    
    init() {
        _ = clear()
    }
    
    // Returns what the calculator label should be
    func give(character: String) -> String {
        switch evaluatedValue {
        case .valueWasCalculated(_), .arithmeticOverflowOccurred:
            _ = clear()
        default:
            break // Do nothing...
        }
        
        previousButtonPressed = .number
        var currentString: String { return (operation == nil ? leftSide : rightSide) }
        let futureString: String
        
        // Prevents the label from reading "00"
        // or "000" or "0000", etc.
        if (currentString == CalculatorBrain.zero && character == CalculatorBrain.zero) == false {
            if currentString == CalculatorBrain.zero {
                futureString = character
            }
            else {
                futureString = currentString + character
            }
        }
        else {
            futureString = currentString
        }
        
        if operation == nil {
            leftSide = futureString
        }
        else {
            rightSide = futureString
        }
        
        return futureString
    }
    
    // Returns an updated String if any for the calculator label
    func evaluate() -> String? {
        if previousButtonPressed == .equals {
            switch evaluatedValue {
            case .valueWasCalculated(let value):
                leftSide = String(describing: value)
                evaluatedValue = .noValue
            case .arithmeticOverflowOccurred:
                return nil
            default:
                assert(false, "Unexpected behavior encountered.") // this should never execute!!!
            }
        }
        
        previousButtonPressed = .equals
        
        switch evaluatedValue {
        case .valueWasCalculated(let value):
            return String(describing: value)
        case .noValue:
            if let op = operation {
                if let calculatedValue = op.closure(Int(leftSide)!, Int(rightSide)!) {
                    evaluatedValue = .valueWasCalculated(calculatedValue)
                    return String(describing: calculatedValue)
                } else {
                    evaluatedValue = .arithmeticOverflowOccurred
                    return CalculatorBrain.overflowMessage
                }
            } else {
                return nil
            }
        default:
            assert(false, "Unexpected behavior encountered.") // this should never execute!!!
        }
    }
    
    // Returns an updated String if any for the calculator label
    func setOperation(_ newValue: Operation) -> String? {
        if rightSide == CalculatorBrain.zero {
            previousButtonPressed = .operation
            operation = newValue
            return leftSide
        }
        else {
            var nextLeftSide = ""
            
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
    
    func clear() -> String {
        leftSide = CalculatorBrain.zero
        rightSide = CalculatorBrain.zero
        evaluatedValue = .noValue
        operation = nil
        previousButtonPressed = .noButtonsPressedYet
        return CalculatorBrain.zero
    }
    
    enum PreviousButtonPressed {
        case operation
        case number
        case equals
        case noButtonsPressedYet
    }
    
    enum Operation {
        case add
        case subtract
        case multiply
        case divide
        
        var closure: ((Int, Int) -> Int?) {
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
            
            return {
                let (calculatedValue, didOverflow) = function($0, $1)
                return didOverflow ? nil : calculatedValue
            }
        }
    }
    
    enum CalculatedValue {
        case valueWasCalculated(Int)
        case noValue
        case arithmeticOverflowOccurred
    }
}

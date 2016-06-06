//
//  ViewController.swift
//  Calculator
//
//  Created by justin on 3/05/2016.
//  Copyright © 2016 justin. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("loaded up a new calculator. count = \(calculatorCount)")
        brain.addUnaryOperation("Z") { [weak me = self] in
            me?.display.textColor = UIColor.redColor()
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("calculator left the heap. count = \(calculatorCount)")
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentInDisplay = display.text!
            display.text = textCurrentInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    private var brain = CalculatorBrain()

    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol)
        }
        displayValue = brain.result
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
}


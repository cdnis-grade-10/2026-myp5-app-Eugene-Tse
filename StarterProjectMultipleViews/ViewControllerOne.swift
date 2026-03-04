/*
 
 ViewControllerOne.swift
 
 This file will contain the code for the first viewcontroller.
 Please ensure that your code is organised and is easy to read.
 This means that you will need to both structure your code correctly,
 in addition to using the correct syntax for Swift.
 
 Unless you are told otherwise, ensure that you are using the
 camelCase syntax. For example, outputLabel and firstName are good
 examples of using the camelCase syntax.
 
 Within each class, you can see clearly identified sections denoted by
 MARK statements. These MARK statements allow you to structure and organise
 your code.
 
 - @IBOutlets should be listed under the MARK section on IBOutlets
 - Variables and constants listed under the MARK section Variables and Constants
 - Functions (including @IBActions) listed under the section on IBActions and Functions.
 
 As you develop each view controller class with Swift code, please include
 detailed comments to both demonstrate understanding, and which serve you as
 a reminder as to what your code actually does.
 
 */

import UIKit



class ViewControllerOne: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var timeRemaining: Int = 10
    var timer: Timer!
    
    
    @IBAction func PlayTapped(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(step)  , userInfo: nil, repeats: true)
    }
    
    @IBAction func PauseTapped(_ sender: Any) {
        timer.invalidate()
    }
    
    
    @IBAction func ResetTapped(_ sender: Any) {
        timer.invalidate()
        timeRemaining = 10
        label.text = "\(timeRemaining)"
    }
    
    @objc func step() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            timeRemaining = 10
        }
        label.text = "\(timeRemaining)"
    
    }
    
    
    // MARK: - IBOutlets
    
    
    
    // MARK: - Variables and Constants
    
    
    
    // MARK: - IBActions and Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

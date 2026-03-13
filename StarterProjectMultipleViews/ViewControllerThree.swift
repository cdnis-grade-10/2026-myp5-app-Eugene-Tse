
import UIKit
import SwiftUI
import Charts

struct ContentView: View {
    var data = [
        SleepDataPoint (
            day: "Mon", hours: 6),
        
        SleepDataPoint (
            day: "Tue", hours: 7),
        
        SleepDataPoint (
            day: "Wed", hours: 5),
        
        SleepDataPoint (
            day: "Thu", hours: 8),
        
        SleepDataPoint (
            day: "Fri", hours: 9),
        
        SleepDataPoint (
            day: "Sat", hours: 4),
        
        SleepDataPoint (
            day: "Sun", hours: 10)]
    
    var body: some View {
        
        Chart {
            
            ForEach(data) { d in 
                
                BarMark(x: PlottableValue.value("Day", d.day), y: .value("Hours", d.hours))
            }
        }
    }
}

class ViewControllerThree: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
}
    // MARK: - IBOutlets
    
    
    
    // MARK: - Variables and Constants
    
    
    
    // MARK: - IBActions and Functions


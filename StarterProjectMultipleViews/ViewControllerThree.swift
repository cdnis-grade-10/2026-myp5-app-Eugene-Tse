
import UIKit
import SwiftUI
import Charts

class ViewControllerThree: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // THIS IS WHERE THE HOSTING CODE GOES
                
                // Initialize your SwiftUI Chart View
                let chartView = ContentView()
                
                // Wrap it in the UIHostingController
                let hostingController = UIHostingController(rootView: chartView)
                
                // Add the hosting controller to the current UIKit view
                addChild(hostingController)
                view.addSubview(hostingController.view)
                
                // Constrain it to fill the screen
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                
                
                hostingController.didMove(toParent: self)
      
    }
    
}
        


struct ContentView: View {
    var data = [
        WorkDataPoint (
            day: "Mon", hours: 2),
        
        WorkDataPoint (
            day: "Tue", hours: 3),
        
        WorkDataPoint (
            day: "Wed", hours: 5, type: "Highest"),
        
        WorkDataPoint (
            day: "Thu", hours: 4),
        
        WorkDataPoint (
            day: "Fri", hours: 2),
        
        WorkDataPoint (
            day: "Sat", hours: 1, type: "Lowest"),
        
        WorkDataPoint (
            day: "Sun", hours: 1, type: "Lowest")]
    
    var body: some View {
        
        Chart {
            
            ForEach(data) { d in 
                
                BarMark(x: PlottableValue.value("Day", d.day), y: .value("Hours", d.hours)).annotation (position: .overlay){
                    Text (String(d.hours))
                        .foregroundColor(.white)
                }
                .foregroundStyle(by: .value("Type", d.type))
            }
        }
        .chartYScale(range: .plotDimension(padding: 60))
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    // MARK: - IBOutlets
    
    
    
    // MARK: - Variables and Constants
    
    
    
    // MARK: - IBActions and Functions


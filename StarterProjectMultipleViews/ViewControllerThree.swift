import UIKit
import SwiftUI
import Charts

// MARK: - 1. The Broadcast Station (ViewModel)
class ChartViewModel: ObservableObject {
    @Published var data = [
        WorkDataPoint(day: "Mon", hours: 2),
        WorkDataPoint(day: "Tue", hours: 3),
        WorkDataPoint(day: "Wed", hours: 5),
        WorkDataPoint(day: "Thu", hours: 4),
        WorkDataPoint(day: "Fri", hours: 2),
        WorkDataPoint(day: "Sat", hours: 1),
        WorkDataPoint(day: "Sun", hours: 1)
    ]
}

// MARK: - 2. The SwiftUI Chart (ContentView)
struct ContentView: View {
    @ObservedObject var viewModel: ChartViewModel
    
    var body: some View {
        // Only ONE Chart block here to fix the "Double Graph" issue
        Chart {
            ForEach(viewModel.data) { d in
                BarMark(
                    x: .value("Day", d.day),
                    y: .value("Hours", d.hours)
                )
                .annotation(position: .overlay) {
                    Text("\(Int(d.hours))")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .foregroundStyle(by: .value("Type", d.type))
            }
        }
        .padding()
    }
}

// MARK: - 3. The View Controller
class ViewControllerThree: UIViewController {
    
    let chartViewModel = ChartViewModel()
    
    // This handles the data if you use a direct button/segue
    var incomingSleepHours: Int? {
        didSet {
            if let hours = incomingSleepHours {
                updateChartData(with: hours)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    // 1. This runs every time you tap the Graph Tab
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        // Loop through all 7 days in memory
        for (index, dayName) in days.enumerated() {
            let savedValue = UserDefaults.standard.integer(forKey: "saved_\(dayName)")
            
            if savedValue > 0 {
                // Update the data array at the correct index
                self.chartViewModel.data[index].hours = Double(savedValue)
            }
        }
        
        // 2. Refresh the UI on the Main Thread
        DispatchQueue.main.async {
            self.chartViewModel.objectWillChange.send()
            self.setupChart()
            print("--- Graph Refreshed All Days ---")
        }
    }

    // 3. This updates Monday specifically (for backwards compatibility)
    func updateChartData(with hours: Int) {
        DispatchQueue.main.async {
            self.chartViewModel.data[0].hours = Double(hours)
            self.chartViewModel.objectWillChange.send()
        }
    }

    // 4. This draws the actual SwiftUI chart on the screen
    func setupChart() {
        // Clean up old charts first
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        let chartView = ContentView(viewModel: chartViewModel)
        let hostingController = UIHostingController(rootView: chartView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
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

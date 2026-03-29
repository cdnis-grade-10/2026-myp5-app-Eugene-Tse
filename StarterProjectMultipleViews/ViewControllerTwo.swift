import UIKit

class ViewControllerTwo: UIViewController {
    
    // MARK: - 1. Variables & Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var sleepHoursTextField: UITextField!
    
    @IBOutlet weak var daySelector: UISegmentedControl!
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingTime"
    
    var scheduledTimer: Timer!
    
    // MARK: - 2. Setup (Runs when screen loads)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup keyboard
        sleepHoursTextField.keyboardType = .numberPad
        
        // Load the saved timer data
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        if timerCounting {
            startTimer()
        } else {
            stopTimer()
            if let start = startTime, let stop = stopTime {
                let time = calcRestartTime(start: start, stop: stop)
                let diff = Date().timeIntervalSince(time)
                setTimeLabel(Int(diff))
            }
        }
    }
    
    // Hides keyboard on tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - 3. Segue (Runs when switching screens)
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("--- BUTTON PRESSED: Segue ID is \(segue.identifier ?? "NONE") ---")
    
    if segue.identifier == "showGraph" {
        if let destinationVC = segue.destination as? ViewControllerThree,
           let text = sleepHoursTextField.text,
           let hoursTyped = Int(text) {
            
            destinationVC.incomingSleepHours = hoursTyped
            print("Successfully sent \(hoursTyped) to the graph!")
        }
    }
}
    // MARK: - 4. Button Actions (Now safely outside of other functions!)
    @IBAction func StartStopAction(_ sender: Any) {
        
        // 1. Create the list of days (Must match the order of your Segmented Control)
                let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                
                // 2. See which day is currently tapped on the switch (0, 1, 2, etc.)
                let selectedDay = days[daySelector.selectedSegmentIndex]

                // 3. Save the hours to that specific day's "folder"
                if let text = sleepHoursTextField.text, let hours = Int(text) {
                    UserDefaults.standard.set(hours, forKey: "saved_\(selectedDay)")
                    print("--- Memory: Successfully saved \(hours) hours for \(selectedDay)! ---")
                }

                // --- Rest of your timer code ---
                if timerCounting {
                    setStopTime(date: Date())
                    stopTimer()
                } else {
                    if let stop = stopTime {
                        let restartTime = calcRestartTime(start: startTime!, stop: stop)
                        setStopTime(date: nil)
                        setStartTime(date: restartTime)
                    } else {
                        setStartTime(date: Date())
                    }
                    startTimer()
                }
            }
    
    @IBAction func resetAction(_ sender: Any) {
        setStartTime(date: nil)
        setStopTime(date: nil)
        timeLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        stopTimer()
        setTimeLabel(0)
    }

    // MARK: - 5. Timer Helper Functions
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        StartStopButton.setTitle("STOP", for: .normal)
        StartStopButton.setTitleColor(.red, for: .normal)
    }
    
    @objc func refreshValue() {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        } else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600 / 60)
        let sec = (ms % 3600 % 60)
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        StartStopButton.setTitle("START", for: .normal)
        StartStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(date, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(date, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
}

//
//  AppDelegate.swift
//  Focus
//
//  Created by Arik on 09/29/18.
//  Copyright © 2018 Arik. All rights reserved.
//

// Ascii art generator found at:
// http://patorjk.com/software/taag/#p=display&c=c%2B%2B&f=Big%20Money-ne&t=MENU
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
/////////                                                         /////////
/////////                        OG BLOCK                         /////////
/////////                                                         /////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


import Cocoa
import Charts


/// NOTES:
// alt to the current percent view
// infoTextView.isHidden = true
// Insert code here to initialize your application
// pieChartViewer.noDataText = "HAHHAHAHAHA"

// add started at x time (current time)
// add data i.e. number of clicks total weeeeeeeeee
// add wieghted option for yes/no make NO's count for two for example
// use my own generated UUID to identify next notification and allow no or yes to be pressed?


/// COMMANDS:
// ⌘Y Yes
// ⌘N No
// ⌘D Done
// ⌘R Restart


/*
 examples and code from https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language/38215613#38215613
 
 let str = "abcde"
 print(type(of: str))
 print(str[1])     // => b
 print(str[1..<3]) // => bc
 print(str[1...3]) // => bcd
 print(str[1...])  // => bcde
 print(str[...3])  // => abcd
 print(str[..<3])  // => abc
 print("")
 
 // With substrings:
 let sub = str[0...]
 print(type(of: sub))
 print(sub[1])     // => b
 print(sub[1..<3]) // => bc
 print(sub[1...3]) // => bcd
 print(sub[1...])  // => bcde
 print(sub[...3])  // => abcd
 print(sub[..<3])  // => abc
 */

//extension String {
//    subscript (i: Int) -> Character {
//        return self[index(startIndex, offsetBy: i)]
//    }
//    subscript (bounds: CountableRange<Int>) -> Substring {
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[start ..< end]
//    }
//    subscript (bounds: CountableClosedRange<Int>) -> Substring {
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[start ... end]
//    }
//    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(endIndex, offsetBy: -1)
//        return self[start ... end]
//    }
//    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[startIndex ... end]
//    }
//    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[startIndex ..< end]
//    }
//}
//extension Substring {
//    subscript (i: Int) -> Character {
//        return self[index(startIndex, offsetBy: i)]
//    }
//    subscript (bounds: CountableRange<Int>) -> Substring {
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[start ..< end]
//    }
//    subscript (bounds: CountableClosedRange<Int>) -> Substring {
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[start ... end]
//    }
//    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
//        let start = index(startIndex, offsetBy: bounds.lowerBound)
//        let end = index(endIndex, offsetBy: -1)
//        return self[start ... end]
//    }
//    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[startIndex ... end]
//    }
//    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
//        let end = index(startIndex, offsetBy: bounds.upperBound)
//        return self[startIndex ..< end]
//    }
//}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
// Added NSUserNotificationCenterDelegate to classes
    
    @IBOutlet weak var preferencesWindow: NSPanel!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var subtitleTextField: NSTextField!
    @IBOutlet weak var informationTextField: NSTextField!
    @IBOutlet weak var intervalInMinutesTextField: NSTextField!
    @IBOutlet weak var warningIntervalTooShort: NSBox!
    @IBOutlet weak var warningInvisableButton: NSButton!
    @IBOutlet weak var onOffNotificationSound: NSSegmentedControl!
    @IBOutlet weak var cautionTextField: NSTextField!

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var userPassTabView: NSTabView!
    @IBOutlet weak var passTextField: NSSecureTextField!
    @IBOutlet weak var outputView: NSView!
    @IBOutlet weak var outputText: NSTextField!
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var pieChartViewer: PieChartView!
    @IBOutlet weak var infoPercent: NSTextField!
    @IBOutlet weak var infoResponses: NSTextField!
    @IBOutlet weak var infoStart: NSTextField!
    @IBOutlet weak var clickHereButton: NSButton!
    
    var dataYes = PieChartDataEntry(value: 1)
    var dataNo = PieChartDataEntry(value: 0)
    var numberOfResponseEntries = [PieChartDataEntry]()
    /// Counter for yeses
    var yesCount: Double = 1
    /// Counter for nos
    var noCount: Double = 0
    var iCanActMultiClickProtection: Bool = true
//    var noCountWeight: Double = 1 // set in preferences to desired weight i.e. 1.5 or 2
//    var noCount: Double = noCountWeight
    var clickHereClickCount = 0
    var onOffCount = 0
    let blueHue = CGFloat(0.57)
    let greenHue = CGFloat(0.38)
    let desiredTimerIntervalWeight = 1.2
//    let DEFAULTdesiredTimerInterval: Double = 4 // 180 for 3 minutes 4.2 * 60
    let DEFAULTdesiredTimerInterval: Double = 4.2 * 60
    var desiredTimerInterval: Double = 2
    var notificationTitle: String = "Are you on task?"
    var notificationSubtitle: String = ""
    var notificationInformativeText: String = "I only ask because you wanted me to check on you."
    var notificationSoundName: String? = "Purr"
    var timmy: Timer? = nil
    var doneImage = false
    
    let DEV_USERNAME = "root"
    let DEV_PASSWORD = "root"
    var userAuthenticated = false
    var passwordAuthenticated = false
    var ju_mode = false
    var holberton_mode = false
    var overrideTimeConstraintDisabled = true
    var lastOutputText = ""


    
//   /$$      /$$ /$$$$$$$$ /$$   /$$ /$$   /$$
//  | $$$    /$$$| $$_____/| $$$ | $$| $$  | $$
//  | $$$$  /$$$$| $$      | $$$$| $$| $$  | $$
//  | $$ $$/$$ $$| $$$$$   | $$ $$ $$| $$  | $$
//  | $$  $$$| $$| $$__/   | $$  $$$$| $$  | $$
//  | $$\  $ | $$| $$      | $$\  $$$| $$  | $$
//  | $$ \/  | $$| $$$$$$$$| $$ \  $$|  $$$$$$/
//  |__/     |__/|________/|__/  \__/ \______/
    

    @IBAction func preferencesMenuItemSelected(_ sender: Any) {
        preferencesWindow.setIsVisible(true)
        
        /// I do this, one: to show that this window is the preferences
        /// and two: because this solves a bug with the background of
        /// the textfield being slightly off color if you echo an empty
        /// string/space.
        presentOutput("Preferences", 0.5)
        lastOutputText = ""
    }
    @IBAction func yesMenuItemSelected(_ sender: Any) {
        incrementYes()
    }
    @IBAction func noMenuItemSelected(_ sender: Any) {
        incrementNo()
    }
    
    /// Experimental...
    /*
    @IBAction func pauseResumeMenuItemSelected(_ sender: Any) {
        print(timmy?.timeInterval)
        print(timmy?.tolerance)
        print(timmy?.fireDate)
        if (timmy != nil) {
            print(timmy!.fireDate.timeIntervalSince1970 - Date().timeIntervalSince1970)
        }
    }
 */
    @IBAction func doneMenuItemSelected(_ sender: Any) {
        let percentNumber = percentInt()
        
        doneImage = true
        notificationSoundName = NSUserNotificationDefaultSoundName
        notifyUser(title: "Well done!", subtitle: "", informative: "You were " + String(percentNumber) + "% focused")

        infoPercent.stringValue = "Done!"
        clickHereButtonClicked(self)
        infoPercent.isHidden = false
//        infoPercent.font = NSFont(name: "SignPainter", size: 80)
        infoResponses.isHidden = true
        infoStart.isHidden = true
        
        clickHereClickCount = 0
        
        /// Prints green circle
        resetENV()
        let changingSaturation = CGFloat(1)
        let chartDataSet = PieChartDataSet(values: numberOfResponseEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSColor(named: NSColor.Name(rawValue: "noColor")), NSColor.init(hue: greenHue, saturation: changingSaturation, brightness: 1, alpha: 1)]
        chartDataSet.colors = colors as! [NSUIColor]
        /// Hides values (numbers)
        chartDataSet.drawValuesEnabled = false
        /// Prevents chart from expanding on click
        chartDataSet.selectionShift = 0
        pieChartViewer.animate(xAxisDuration: 1, yAxisDuration: 0.5)
        pieChartViewer.data = chartData

        /// Stops notifications
        stopTimer()
        /// Prevents user clicking on notification changing data
        iCanActMultiClickProtection = false
    }
    @IBAction func restartMenuItemSelected(_ sender: Any) {
        setStartTime()
        resetENV()
        updateChartData()
        startTimer()
    }

//   /$$$$$$$$ /$$   /$$ /$$   /$$  /$$$$$$  /$$$$$$$$ /$$$$$$  /$$$$$$  /$$   /$$  /$$$$$$
//  | $$_____/| $$  | $$| $$$ | $$ /$$__  $$|__  $$__/|_  $$_/ /$$__  $$| $$$ | $$ /$$__  $$
//  | $$      | $$  | $$| $$$$| $$| $$  \__/   | $$     | $$  | $$  \ $$| $$$$| $$| $$  \__/
//  | $$$$$   | $$  | $$| $$ $$ $$| $$         | $$     | $$  | $$  | $$| $$ $$ $$|  $$$$$$
//  | $$__/   | $$  | $$| $$  $$$$| $$         | $$     | $$  | $$  | $$| $$  $$$$ \____  $$
//  | $$      | $$  | $$| $$\  $$$| $$    $$   | $$     | $$  | $$  | $$| $$\  $$$ /$$  \ $$
//  | $$      |  $$$$$$/| $$ \  $$|  $$$$$$/   | $$    /$$$$$$|  $$$$$$/| $$ \  $$|  $$$$$$/
//  |__/       \______/ |__/  \__/ \______/    |__/   |______/ \______/ |__/  \__/ \______/

    
    
    func presentOutput(_ text: String, _ DISPLAY_TIME: Double = 1, _ desiredAlignment: NSTextAlignment = .center) {
        outputText.alignment = desiredAlignment
        lastOutputText = text
        outputText.stringValue = text
        outputView.isHidden = false
        titleTextField.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: DISPLAY_TIME, repeats: false) { Timer in
            self.outputView.isHidden = true
            self.titleTextField.isEnabled = true
            self.titleTextField.becomeFirstResponder()
        }
        //            messageEnabled.acceptsFirstMouse // capture click and hide output
    }

    func exitCommand() {
        /// I want to hook this into the preferences window closing
        passTextField.stringValue = ""
        titleTextField.stringValue = ""
        titleLabel.stringValue = "Title"
        userPassTabView.selectTabViewItem(at: 0)
        passwordAuthenticated = false
    }
    
    func executeCommands() {
        let command = titleTextField.stringValue
        
        titleTextField.stringValue = ""
        passTextField.stringValue = ""
        titleLabel.stringValue = "Command"

        if command == "exit" {
            exitCommand()
        } else if command == "ju" {
            if ju_mode {
                ju_mode = false
                print("Ju_mode disabled")
                presentOutput("Ju_mode disabled")
            } else {
                ju_mode = true
                print("Ju_mode enabled")
                presentOutput("Ju_mode enabled")
            }
        } else if command == "holberton" {
            if holberton_mode {
                holberton_mode = false
                print("Holberton_mode disabled")
                presentOutput("Holberton_mode disabled")
            } else {
                holberton_mode = true
                print("Holberton_mode enabled")
                presentOutput("Holberton_mode enabled")
            }
        } else if command == "fidget" {
            if window.isMovableByWindowBackground {
                pieChartViewer.dragDecelerationFrictionCoef = 0.9
                pieChartViewer.rotationEnabled = true
                window.isMovableByWindowBackground = false
                print("Fidget spinner enabled")
                presentOutput("Fidget spinner enabled")
            } else {
                pieChartViewer.rotationEnabled = false
                window.isMovableByWindowBackground = true
                print("Fidget spinner disabled")
                presentOutput("Fidget spinner disabled")
            }
        } else if command == "otc" {
            /// override time constraints
            if overrideTimeConstraintDisabled {
                overrideTimeConstraintDisabled = false
                print("Time constraints disabled")
                presentOutput("Time constraints disabled")
            } else {
                overrideTimeConstraintDisabled = true
                print("Time constraints enabled")
                presentOutput("Time constraints enabled")
            }
        } else if command == "last" {
            presentOutput(lastOutputText, 2)
        } else if command == "commands" {
            ju_mode = false
            presentOutput("commands;  ju;  holberton;\necho;  echo $$;  exit", 4)
        } else if command.starts(with: "echo") {
            if command == "echo" || command == "echo " {
                presentOutput("")
            } else {
                let start = String.Index.init(encodedOffset: 5)
                let end = command.index(command.endIndex, offsetBy: -1)
                let echoText = String(command[start...end])
                
                if echoText == "$$" {
                    presentOutput(String(getpid()))
                } else {
                    presentOutput(echoText)
                }
            }
            //                presentOutput(String(echoText[1...5]))
        }

    }
    
    func validatePassword() {
        if passTextField.stringValue == DEV_PASSWORD {
            passTextField.stringValue = ""
            titleTextField.stringValue = ""
            titleLabel.stringValue = "Command"
            userPassTabView.selectTabViewItem(at: 0)
            titleTextField.becomeFirstResponder()
            passwordAuthenticated = true
            userAuthenticated = false
        } else {
            passTextField.stringValue = ""
            titleTextField.stringValue = ""
            titleLabel.stringValue = "Title"
            userPassTabView.selectTabViewItem(at: 0)
            titleTextField.becomeFirstResponder()
            userAuthenticated = false
        }
    }
    
    @IBAction func titleTextFieldEntered(_ sender: Any) {
        /// DON'T FORGET TO RESET VALUES, OR MAYBE IT DON'T MATTER CAUSE IT'S ALL TITLE HMMM
        if passwordAuthenticated {
            executeCommands()
        } else if userAuthenticated {
            validatePassword()
        } else if titleTextField.stringValue == DEV_USERNAME {
            titleLabel.stringValue = "Password"
            userPassTabView.selectTabViewItem(at: 1)
            passTextField.becomeFirstResponder()
            userAuthenticated = true
        }
    }
    
    func optionalNotificationImage() -> NSImage? {
        let percent = percentInt()

        if ju_mode {
            if doneImage {
                return #imageLiteral(resourceName: "ju_done")
            } else if percent < 50 {
                return #imageLiteral(resourceName: "ju_bad")
            } else {
                return #imageLiteral(resourceName: "ju_good")
            }
        } else {
            if doneImage {
                return #imageLiteral(resourceName: "thumbs_up")
            } else if percent < 50 {
                return NSImage(named: NSImage.Name(rawValue: "NSCaution"))
            }
        }
        return nil
    }
    
    func optionalNotificationLeftImage() -> String {
        if holberton_mode {
            return "holberton_logo"
        } else {
            return ""
        }
    }
    
    func optionalNotificationSound() -> String? {
        let soundIsSwitchedOff = onOffNotificationSound.isSelected(forSegment: 1)
        
        if soundIsSwitchedOff {
            return nil
        } else {
            return notificationSoundName
        }
    }

    
    @IBAction func onOffNotificationSoundSelected(_ sender: Any) {
        let onOption = 0
        let offOption = 1
        onOffCount += 1

        if onOffCount % 2 == 0 {
            onOffNotificationSound.setWidth(45, forSegment: onOption)
            onOffNotificationSound.setWidth(25, forSegment: offOption)
            onOffNotificationSound.setSelected(true, forSegment: onOption)
        } else {
            onOffNotificationSound.setWidth(25, forSegment: onOption)
            onOffNotificationSound.setWidth(45, forSegment: offOption)
            onOffNotificationSound.setSelected(true, forSegment: offOption)
        }
    }
    
    // OLD method required clicking on desired option
//    @IBAction func onOffNotificationSoundSelected(_ sender: Any) {
//        let soundIsSwitchedOff = onOffNotificationSound.isSelected(forSegment: 1)
//        let onOption = 0
//        let offOption = 1
//
//        if soundIsSwitchedOff {
//            onOffNotificationSound.setWidth(25, forSegment: onOption)
//            onOffNotificationSound.setWidth(45, forSegment: offOption)
//        } else {
//            onOffNotificationSound.setWidth(45, forSegment: onOption)
//            onOffNotificationSound.setWidth(25, forSegment: offOption)
//        }
//    }
    
    func showWarningRequestedIntervalNotAllowed (_ boolVal: Bool) {
        // I invert the Boolean value here to make the function more intuitve to use
        warningIntervalTooShort.isHidden = !boolVal
        warningInvisableButton.isHidden = !boolVal
    }
    
    @IBAction func warningClicked(_ sender: Any) {
        intervalInMinutesTextField.doubleValue = intervalInMinutesTextField!.doubleValue < 0.5 ? 0.5 : 90
        showWarningRequestedIntervalNotAllowed(false)
    }
    
    @IBAction func restoreDefaultsButtonSelected(_ sender: Any) {
        titleTextField.stringValue = "Are you on task?"
        informationTextField.stringValue = "I only ask because you wanted me to check on you."
        intervalInMinutesTextField.doubleValue = 4.2
        onOffCount = 1
        onOffNotificationSoundSelected(self)
    }
    
    @IBAction func previewButtonSelected(_ sender: Any) {
        iCanActMultiClickProtection = false
        notifyUser(title: titleTextField!.stringValue, subtitle: subtitleTextField!.stringValue, informative: informationTextField!.stringValue)
    }
    
    /// Retrieves data from text fields and sets appropriate variables
    @IBAction func preferencesSaveButtonSelected(_ sender: Any) {
        let THIRTY_SECONDS: Double = 0.5
        let NINETY_MINUTES: Double = 90
        let interValue = intervalInMinutesTextField!.doubleValue
        
        // LOGIC yeah... SET VALUES DUDE wwoooooooottt YEeeeEEeeeEEEeEeeHAAAAAAAAAa
        if overrideTimeConstraintDisabled && interValue != 0.0 && interValue < THIRTY_SECONDS {
            cautionTextField.stringValue = "Too Short"
            warningIntervalTooShort.toolTip = "Studies have shown, using Focus with an interval less than thirty seconds, to be counterproductive, downright irritating in fact."
            showWarningRequestedIntervalNotAllowed(true)
        } else if overrideTimeConstraintDisabled && interValue > NINETY_MINUTES {
            cautionTextField.stringValue = "Too Long"
            warningIntervalTooShort.toolTip = "Yeesh, how long ya think it's gonna take you??"
            showWarningRequestedIntervalNotAllowed(true)
        } else {
            showWarningRequestedIntervalNotAllowed(false)
            
            /// Clean up
            noCount = 0
            yesCount = 1
            dataYes.value = yesCount
            dataNo.value = noCount
            
            notificationTitle = titleTextField!.stringValue
            notificationSubtitle = subtitleTextField!.stringValue
            notificationInformativeText = informationTextField!.stringValue
            desiredTimerInterval = interValue == 0.0 ? DEFAULTdesiredTimerInterval : interValue * 60

            /// Present customized notification settings
            outputText.alignment = NSTextAlignment.left
            outputText.stringValue = "Title: " + notificationTitle + "\nSubtitle: " + notificationSubtitle + "\nInformation: " + notificationInformativeText + "\nInterval: " + String(Int(desiredTimerInterval / 60)) + " minutes and " + String(Int(desiredTimerInterval) % 60) + " seconds"
            outputView.isHidden = false
            titleTextField.isEnabled = false
            subtitleTextField.isEnabled = false
            informationTextField.isEnabled = false
            intervalInMinutesTextField.isEnabled = false
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { Timer in
                self.preferencesWindow.setIsVisible(false)
                
                self.outputView.isHidden = true
                self.titleTextField.isEnabled = true
                self.subtitleTextField.isEnabled = true
                self.informationTextField.isEnabled = true
                self.intervalInMinutesTextField.isEnabled = true
                self.titleTextField.becomeFirstResponder()
                self.exitCommand()
            }
            setStartTime()
            updateChartData()
            stopTimer()
            startTimer()
        }
//        intervalInMinutesTextField.doubleValue += 0.1
    }
    
    func resetENV() {
        noCount = 0
        yesCount = 1
        dataYes.value = yesCount
        dataNo.value = noCount
        notificationSoundName = "Purr"

/// Perhapse create a default reset that puts back time and strings
//        desiredTimerInterval = DEFAULTdesiredTimerInterval
        
//        notificationTitle = nil
//        notificationSubtitle = nil
//        notificationInformativeText = nil
    }
    
    func setBoolValue(_ arrayOfLabels: NSTextField..., boolValue: Bool) {
        for label in arrayOfLabels {
            label.isHidden = boolValue
        }
    }
    
    /// Toggles extra info
    func infoHideShow() {
        if (clickHereClickCount % 2) == 0 {
            setBoolValue(infoPercent, infoResponses, infoStart, boolValue: true)
        } else {
            setBoolValue(infoPercent, infoResponses, infoStart, boolValue: false)
        }
        
//        if (clickHereClickCount % 2) == 0 {
//            infoPercent.isHidden = true
//            infoResponses.isHidden = true
//            infoStart.isHidden = true
//        } else {
//            infoPercent.isHidden = false
//            infoResponses.isHidden = false
//            infoStart.isHidden = false
//        }

//        infoPercent.isHidden ? (infoPercent.isHidden = false) : (infoPercent.isHidden = true)
//        infoResponses.isHidden ? (infoResponses.isHidden = false) : (infoResponses.isHidden = true)
//        infoStart.isHidden ? (infoStart.isHidden = false) : (infoStart.isHidden = true)
    }
    
    @IBAction func clickHereButtonClicked(_ sender: Any) {
        clickHereClickCount += 1
        clickHereButton.title = ""
        infoHideShow()
    }
    
    func percentInt() -> Int {
        return Int(100 / ((yesCount + noCount) / yesCount))
    }
    
    /// Updates pie chart
    func updateChartData() {
        let totalCount = Int(yesCount + noCount)
        let percentNumber = percentInt()
        
//        var changingYesColor = CGFloat(Float(percentNumber + 800) / 1500)
        
        let changingSaturation = CGFloat(Float(percentNumber + 100) / 200)
        //        print(changingSaturation)
        // Change color from RED bad to PURPLE meh to BLUE good
        let chartDataSet = PieChartDataSet(values: numberOfResponseEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [NSColor(named: NSColor.Name(rawValue: "noColor")), NSColor.init(hue: blueHue, saturation: changingSaturation, brightness: 1, alpha: 1)]
        chartDataSet.colors = colors as! [NSUIColor]
        
        /// Hides values (numbers)
        chartDataSet.drawValuesEnabled = false
        /// Prevents chart from expanding on click
        chartDataSet.selectionShift = 0
        
        pieChartViewer.animate(xAxisDuration: 1, yAxisDuration: 0.5)
        pieChartViewer.data = chartData
        
        /// Update info
        infoPercent.stringValue = String(percentNumber) + "%"
//        infoPercent.toolTip = String(percentNumber) + "%"
        /// Display fraction; alternate to percent
//        infoPercent.stringValue = String(Int(yesCount)) + "/" + String(totalCount)
        infoResponses.stringValue = "Responses: " + String(totalCount)
//        infoResponses.toolTip = "Responses: " + String(totalCount)
        infoHideShow()
    }
    
    func setUpPieChart() {
        /// Hides labels
        pieChartViewer.drawEntryLabelsEnabled = false
        /// Hides description
        pieChartViewer.chartDescription?.text = ""
        /// Hides legend
        pieChartViewer.legend.enabled = false
        /// Prevents chart from being draggable
        pieChartViewer.rotationEnabled = false
        ///       Hides hole
        //        pieChart.drawHoleEnabled = false
        //        pieChart.usePercentValuesEnabled = true
        pieChartViewer.holeRadiusPercent = 0.6
        pieChartViewer.holeColor = NSColor(named: NSColor.Name(rawValue: "holeColor"))
        
        dataYes.label = "Yes"
        dataNo.label = "No"
        
        numberOfResponseEntries = [dataNo, dataYes]
        
        updateChartData()
    }
    
    func incrementYes() {
        yesCount += 1
        dataYes.value = yesCount
        incrementDesiredTimerInterval()
        updateChartData()
    }
    
    func incrementNo() {
        noCount += 1
        dataNo.value = noCount
        decrementDesiredTimerInterval()
        updateChartData()
    }

    func incrementDesiredTimerInterval() {
        desiredTimerInterval *= desiredTimerIntervalWeight
        print("Notification interval: " + String(desiredTimerInterval))
        stopTimer()
        startTimer()
    }

    func decrementDesiredTimerInterval() {
        desiredTimerInterval /= desiredTimerIntervalWeight
        print("Notification interval: " + String(desiredTimerInterval))
        stopTimer()
        startTimer()
    }

    
    func setStartTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let startTime = formatter.string(from: Date())
        
        infoStart.stringValue = "Start: " + startTime
        infoStart.toolTip = "Start Time: " + Date().description(with: Locale.autoupdatingCurrent)
    }
    
    
//   /$$   /$$  /$$$$$$  /$$$$$$$$ /$$$$$$ /$$$$$$$$ /$$     /$$
//  | $$$ | $$ /$$__  $$|__  $$__/|_  $$_/| $$_____/|  $$   /$$/
//  | $$$$| $$| $$  \ $$   | $$     | $$  | $$       \  $$ /$$/
//  | $$ $$ $$| $$  | $$   | $$     | $$  | $$$$$     \  $$$$/
//  | $$  $$$$| $$  | $$   | $$     | $$  | $$__/      \  $$/
//  | $$\  $$$| $$  | $$   | $$     | $$  | $$          | $$
//  | $$ \  $$|  $$$$$$/   | $$    /$$$$$$| $$          | $$
//  |__/  \__/ \______/    |__/   |______/|__/          |__/
    
    /**
     Sends A notification to the user
     - TODO:
     - Maybe pass in strings for subtitle and informative
     - Send different message based on yes/no ratio
     - 80% you're doing well; 60% focus; 20% what the $&*@# are you doing?!
     */
    func notifyUser(title: String? = nil, subtitle: String? = nil, informative: String? = nil) {
        /// REMOVED @objc preface to func
        let notificationUniqueID = NSUUID().uuidString
        let customNotification = NSUserNotification()
        let noteCenter = NSUserNotificationCenter.default
        
        /// Build notification
        customNotification.identifier = notificationUniqueID
        customNotification.title = title == nil ? notificationTitle : title!
        customNotification.subtitle = subtitle == nil ? notificationSubtitle : subtitle!
        customNotification.informativeText = informative == nil ? notificationInformativeText : informative!

        // Not sure how to get custom sounds in
//        customNotification.soundName = NSSound(named: NSSound.Name(rawValue: "clearThroat"))
        customNotification.soundName = optionalNotificationSound()
//        customNotification.hasActionButton = true
//        customNotification.actionButtonTitle = "aB"
//        customNotification.otherButtonTitle = "oB"
        // Displays image in on right
//        customNotification.contentImage = NSImage(named: NSImage.Name(rawValue:"AppIcon")) // set to Thumbs up
        // if less than 50% add Caution sign!

        customNotification.contentImage = optionalNotificationImage()
        customNotification.setValue(NSImage(named: NSImage.Name(rawValue: optionalNotificationLeftImage())), forKey: "_identityImage")
        // Displays image in place of icon (on left), icon is then shifted up by app name
//        customNotification.setValue(NSImage(named: NSImage.Name(rawValue:"AppIcon")), forKey: "_identityImage")

        /// Send notification to Notification Center
        noteCenter.delegate = self
        noteCenter.deliver(customNotification)
        
        /// Tells the dev the notification was sent
        print("Notification sent!")
    }
    
    /// Shows notification even when focus is on app
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    /// Notification actions
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        // build in protection against multiple clicks // DONE
        // This is triggered if the user clicks the notification
        if iCanActMultiClickProtection == true && notification.activationType.rawValue == 1 {
            yesCount -= 1
            dataYes.value = yesCount
            decrementDesiredTimerInterval()
            incrementNo()
            iCanActMultiClickProtection = false
        }
    }

    func mainSetUp() {
        /// Makes window super draggable
        window.isMovableByWindowBackground = true
        /// Makes click here button appear greyer
        clickHereButton.alphaValue = 0.5
        /// Set Default time
        desiredTimerInterval = DEFAULTdesiredTimerInterval
    }
    
    func stopTimer() {
        if timmy != nil {
            timmy?.invalidate()
            timmy = nil
        }
    }
    
    func startTimer() {
        if timmy == nil {
            timmy = Timer.scheduledTimer(withTimeInterval: desiredTimerInterval, repeats: true) { Timer in
                self.iCanActMultiClickProtection = true
                self.doneImage = false
                self.notifyUser()
                /// We increment yes every time a notification is delivered
                /// but if said notification is clicked we decrement yes and increment no
                self.incrementYes()
            }
        }
    }


//   /$$$$$$$  /$$   /$$ /$$   /$$
//  | $$__  $$| $$  | $$| $$$ | $$
//  | $$  \ $$| $$  | $$| $$$$| $$
//  | $$$$$$$/| $$  | $$| $$ $$ $$
//  | $$__  $$| $$  | $$| $$  $$$$
//  | $$  \ $$| $$  | $$| $$\  $$$
//  | $$  | $$|  $$$$$$/| $$ \  $$
//  |__/  |__/ \______/ |__/  \__/

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        mainSetUp()
        startTimer()
        setStartTime()
        infoHideShow()
        setUpPieChart()
        window.setIsVisible(true)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        pieChartViewer.isHidden = true
    }
}


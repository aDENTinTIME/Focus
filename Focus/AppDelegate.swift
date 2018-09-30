//
//  AppDelegate.swift
//  Focus
//
//  Created by Arik on 09/29/18.
//  Copyright © 2018 Arik. All rights reserved.
//

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



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
// Added NSUserNotificationCenterDelegate to classes
    
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
    var iCanAct: Bool = true
//    var noCountWeight: Double = 1 // set in preferences to desired weight i.e. 1.5 or 2
//    var noCount: Double = noCountWeight
    var clickHereClickCount = 0
    var percentNumber = 100
    let blueHue = CGFloat(0.57)
    let greenHue = CGFloat(0.38)
    let desiredTimerIntervalWeight = 1.2
    let DEFAULTdesiredTimerInterval: Double = 4 // 180 for 3 minutes
    var desiredTimerInterval: Double = 4
    var notificationTitle: String? = nil
    var notificationSubtitle: String? = nil
    var notificationInformativeText: String? = nil
    var notificationSoundName: String? = nil
    var timmy: Timer? = nil

    
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    /////////                                                         /////////
    /////////                        FUNCTIONS                        /////////
    /////////                                                         /////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////

    
    @IBAction func yesMenuItemSelected(_ sender: Any) {
        incrementYes()
    }
    @IBAction func noMenuItemSelected(_ sender: Any) {
        incrementNo()
    }
    @IBAction func doneMenuItemSelected(_ sender: Any) {
        percentNumber = percentInt()

        notifyUser(title: "Well done!", informativeText: "You were " + String(percentNumber) + "% focused", soundName: NSUserNotificationDefaultSoundName)

        infoPercent.stringValue = "Done!"
        clickHereButtonClicked(self)
        infoPercent.isHidden = false
//        infoPercent.font = NSFont(name: "SignPainter", size: 80)
        infoResponses.isHidden = true
        infoStart.isHidden = true
        
        clickHereClickCount = 0
        
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

        stopTimer()
        /// Prevents user clicking on notification changing data
        iCanAct = false
    }
    @IBAction func restartMenuItemSelected(_ sender: Any) {
        setStartTime()
        resetENV()
        updateChartData()
        startTimer()
    }

    func resetENV() {
        noCount = 0
        yesCount = 1
        dataYes.value = yesCount
        dataNo.value = noCount
        desiredTimerInterval = DEFAULTdesiredTimerInterval
        
        notificationTitle = nil
        notificationSubtitle = nil
        notificationInformativeText = nil
        notificationSoundName = nil
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
        percentNumber = percentInt()
        
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
        print(desiredTimerInterval)
        stopTimer()
        startTimer()
    }

    func decrementDesiredTimerInterval() {
        desiredTimerInterval /= desiredTimerIntervalWeight
        print(desiredTimerInterval)
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
    
    
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    /////////                                                         /////////
    /////////                      NOTIFICATIONS                      /////////
    /////////                                                         /////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////

    
    
    /**
     Sends A notification to the user
     - TODO:
     - Maybe pass in strings for subtitle and informative
     - Send different message based on yes/no ratio
     - 80% you're doing well; 60% focus; 20% what the $&*@# are you doing?!
     */
    func notifyUser(title: String = "Are you on task?", subtitle: String = "", informativeText: String = "I only ask because you wanted me to check on you.", soundName: String = "Purr") {
        /// REMOVED @objc preface to func
        let notificationUniqueID = NSUUID().uuidString
        let customNotification = NSUserNotification()
        let noteCenter = NSUserNotificationCenter.default
        iCanAct = true
        
        /// Build notification
        customNotification.identifier = notificationUniqueID
        customNotification.title = title
        customNotification.subtitle = subtitle
        customNotification.informativeText = informativeText
//        customNotification.title = "myTitle"
//        customNotification.subtitle = "mySubTitle: " + String(yesCount - noCount)
//        customNotification.informativeText = "myInformative"

        // Not sure how to get custom sounds in
//        customNotification.soundName = NSSound(named: NSSound.Name(rawValue: "clearThroat"))
        customNotification.soundName = soundName
        // Good sound
//        customNotification.hasActionButton = true
//        customNotification.actionButtonTitle = "aB"
//        customNotification.otherButtonTitle = "oB"
        // Displays image in on right
//        customNotification.contentImage = NSImage(named: NSImage.Name(rawValue:"AppIcon")) // set to Thumbs up
        // if less than 50% add Caution sign!
        if percentInt() < 50 {
            customNotification.contentImage = NSImage(named: NSImage.Name(rawValue: "NSCaution"))
        }
        // Displays image in place of icon (on left), icon is then shifted up by app name
//        customNotification.setValue(NSImage(named: NSImage.Name(rawValue:"AppIcon")), forKey: "_identityImage")

        /// Send notification to Notification Center
        noteCenter.delegate = self
        noteCenter.deliver(customNotification)
        
        /// We increment yes every time a notification is delivered
        /// but if said notification is clicked we decrement yes and increment no
        incrementYes()
        
        /// Tells the dev the notification was sent
        print("Notification sent!\n")
    }
    
    /// Shows notification even when focus is on app
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    /// Notification actions
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        // build in protection against multiple clicks // DONE
        // This is triggered if the user clicks the notification
        print("activationType: ", terminator: "")
        print(notification.activationType.rawValue)
        if iCanAct == true && notification.activationType.rawValue == 1 {
            yesCount -= 1
            dataYes.value = yesCount
            decrementDesiredTimerInterval()
            incrementNo()
            iCanAct = false
        }
    }

    func mainSetUp() {
        /// Makes window super draggable
        window.isMovableByWindowBackground = true
        /// Makes click here button appear greyer
        clickHereButton.alphaValue = 0.5
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
                self.notifyUser()
            }
        }
    }

    
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    /////////                                                         /////////
    /////////                          START                          /////////
    /////////                                                         /////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        startTimer()
        mainSetUp()
        setStartTime()
        infoHideShow()
        setUpPieChart()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


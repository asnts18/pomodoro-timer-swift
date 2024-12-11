//
//  ViewController.swift
//  Pomodoro
//
//  Created by Abegail Santos on 12/10/24.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let homeScreen = HomeView()
    
    // MARK: Define variables
    var remainingSeconds = 25 * 60 // Initial Pomodoro session in seconds
    var isBreakTime = false // To track if the current session is a break
    var pomodoroCount = 0 // Count the number of Pomodoros completed
    
    var timer: Timer?
    
    
    override func loadView() {
        view = homeScreen
    }
    
    override func viewDidLoad() {
        title = "Pomodoro Timer"
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        homeScreen.startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        
        requestNotificationPermission()

        
    }
    
    /* request permission for notifications */
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permission granted for notifications")
            } else {
                print("Permission denied")
            }
        }
    }
    
    /* Starts and updates the timer */
    @objc func startTimer() {
        timer?.invalidate() // Stop any previous timer
                
        // 25 mins for work, 5 mins for short break, 15 mins for long break
        remainingSeconds = isBreakTime ? (pomodoroCount == 4 ? 15 * 60 : 5 * 60) : 25 * 60
        
        // Update the UI with the formatted time
        homeScreen.timerLabel.text = formatTime(remainingSeconds)
        
        // Create a Timer that calls the update method every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    

    /* Decrements the remaining time by one second */
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            homeScreen.timerLabel.text = formatTime(remainingSeconds) // Update the timer label
        } else {
            timer?.invalidate() // Stop the timer when it reaches zero
            sendNotif() // Send a notification

            handleTimerCompletion()
        }
    }
    
    /* Handle what happens when the session ends */
    func handleTimerCompletion() {
        if isBreakTime {
            // If it's break time, set the session back to work and increment Pomodoro count
            isBreakTime = false
            pomodoroCount = (pomodoroCount + 1) % 4 // Reset to 0 after every 4 Pomodoros
        } else {
            // If it's work time, switch to break time
            isBreakTime = true
        }

        // Start the next timer (either work or break session)
        startTimer()
    }
    
    /* Format UILabel */
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func sendNotif() {
        let content = UNMutableNotificationContent()
        
        // Set the title and body of the notification depending on whether it's break or work time
        content.title = "Pomodoro Timer"
        
        if isBreakTime {
            content.body = "Take a break!" // Message for break time
        } else {
            content.body = "Back to work!" // Message for work time
        }
        
        // Set the notification sound
        content.sound = UNNotificationSound.default
        
        if isBreakTime {
            // Define actions for the break session
            let continueAction = UNNotificationAction(identifier: "CONTINUE", title: "Continue", options: [])
            let stopAction = UNNotificationAction(identifier: "STOP", title: "Stop", options: [.destructive])
            
            // Create a notification category to hold these actions
            let category = UNNotificationCategory(identifier: "POMODORO_CATEGORY", actions: [continueAction, stopAction], intentIdentifiers: [], options: [])
            
            // Register the category with the notification center
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            // Assign the category to the notification content
            content.categoryIdentifier = "POMODORO_CATEGORY"
        }
        
        let timeInterval: TimeInterval = max(1, TimeInterval(remainingSeconds)) // Ensure non-zero interval
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            } else {
                print("Notification added successfully")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the response
        if response.actionIdentifier == "CONTINUE" {
            // Continue the Pomodoro session
            startTimer()
        } else if response.actionIdentifier == "STOP" {
            // Stop the Pomodoro session
            timer?.invalidate()
        }

        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle foreground presentation options
        completionHandler([.banner, .sound, .badge])
    }
    
    
}

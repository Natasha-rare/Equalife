//
//  SpeedingVC.swift
//  Equalife
//
//  Created by Kostya Bunsberry on 20.07.2021.
//

import UIKit
import Foundation

class SpeedingVC: UIViewController {
    var timer: Timer?
    var timeCreated:Date = Date()
    var timerStarted:Bool = false
    var timerLastTime:TimeInterval = TimeInterval()
    
    @IBOutlet var timeLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "infoShow", sender: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelTask(_ sender: Any) {
        cancelTimer()
    }
    
    @IBOutlet var PlayBtn: UIBarButtonItem!
    
    
    func toggleStart(){
        if (!timerStarted){
            print("starteed")
            self.PlayBtn.image = UIImage(systemName: "stop")
            timerStarted = true
        }
        else{
            print("stoppde")
            timerStarted = false
            self.PlayBtn.image = UIImage(systemName: "play")
            pauseTimer()
        }
    }
    
    @IBAction func startTimer(_ sender: Any) {
        createTimer()
        toggleStart()
    }
    
    
    func updateTime(){
        let time = Date().timeIntervalSince(self.timeCreated) + timerLastTime
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var times: [String] = []
        if hours > 0 {
          times.append("\(hours)h")
        }
        if minutes > 0 {
          times.append("\(minutes)m")
        }
        times.append("\(seconds)s")
        
        timeLabel.text = times.joined(separator: " ")
    }

}

extension SpeedingVC{
    func createTimer() {
        print("here")
          if timer == nil {
            print("nfnfnfnf")
            let timer = Timer(timeInterval: 1.0,
              target: self,
              selector: #selector(updateTimer),
              userInfo: nil,
              repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
            self.timeCreated = Date()
          }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        timeLabel.text = ""
        timerLastTime = TimeInterval()
    }
    
    func pauseTimer(){
        timer?.invalidate()
        timer = nil
        timerLastTime = Date().timeIntervalSince(self.timeCreated)
    }
    
    @objc func updateTimer(){
        self.updateTime()
    }
}

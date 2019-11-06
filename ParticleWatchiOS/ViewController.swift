//
//  ViewController.swift
//  ParticleWatchiOS
//
//  Created by AJAY BAJWA on 2019-11-03.
//  Copyright © 2019 lambton. All rights reserved.
//

import UIKit
import Particle_SDK
import WatchConnectivity

class ViewController: UIViewController,WCSessionDelegate {
    var dateTime:Float!
    var temp:Float!
    var tempTom:Float!
    var precip:Float!
    var hour:String!
    var minute:String!
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if (message.keys.contains("temp")){
                print("Weather data recieved from Watch")
                
                self.dateTime = message["time"] as! Float
                self.temp = message["temp"] as! Float
                self.tempTom = message["tempTomorrow"] as! Float
                self.precip = message["precip"] as! Float
                
                
                let date = NSDate(timeIntervalSince1970: TimeInterval(self.dateTime!))
                let hourFormat = DateFormatter()
                let minuteFormat = DateFormatter()
                // Set the current timezone to .current
                hourFormat.timeZone = .current
                minuteFormat.timeZone = .current
            
//                format.dateFormat = "h:mm a '' dd-MM-yyyy"
                hourFormat.dateFormat = "h"
                minuteFormat.dateFormat = "mm"
                
                // Set the current date, altered by timezone.
                let hourString = hourFormat.string(from: date as Date)
                self.hour = hourFormat.string(from: date as Date)
                self.minute = minuteFormat.string(from: date as Date)
                print("Hour: \(self.hour!)")
                print("Minute:\(self.minute!)")
                
                self.sendHourToParticle()
                self.sendMinuteToParticle()
                self.sendTempToParticle()
                self.sendTempTomToParticle()
                self.sendPrecipToParticle()
            }
        }

    }
    
    
    // MARK: User variables
    let USERNAME = ""
    let PASSWORD = ""
    
    // MARK: Device
    let DEVICE_ID = ""
    var myPhoton : ParticleDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            // 1. Check if phone supports WCSessions
            print("Phone view loaded")
            if WCSession.isSupported() {
                print("Phone supports WCSession")
                WCSession.default.delegate = self
                WCSession.default.activate()
                print("Session Activated")
            }
            else {
                print("Phone does not support WCSession")
            }
        }
        
        // 1. Initialize the SDK
        ParticleCloud.init()
        
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.USERNAME, password: self.PASSWORD) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")
            }
        }// end login
        
        self.getDeviceFromCloud()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gets the device from the Particle Cloud
    // and sets the global device variable
    func getDeviceFromCloud() {
        ParticleCloud.sharedInstance().getDevice(self.DEVICE_ID) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon: \(device!.id)")
                self.myPhoton = device
            }
            
        }
    }
    
    
    func sendHourToParticle(){
        let funcArgs = [self.hour!] as [Any]
        let task = self.myPhoton!.callFunction("setHour", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent hour to particle")
            }
            else{
                print("Error sending hour")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        //print("\(bytesToReceive)")
        
    }
    
    func sendMinuteToParticle(){
        let funcArgs = [self.minute!] as [Any]
        let task = self.myPhoton!.callFunction("setMinute", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent minute to particle")
            }
            else{
                print("Error sending minute")
            }
        }
        
    }
    
    func sendTempToParticle(){
        let funcArgs = [self.temp!] as [Any]
        let task = self.myPhoton!.callFunction("setTemp", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent temp to particle")
            }
            else{
                print("Error sending temp")
            }
        }
        
    }

    func sendTempTomToParticle(){
        let funcArgs = [self.tempTom!] as [Any]
        let task = self.myPhoton!.callFunction("setTempTom", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent tempTom to particle")
            }
            else{
                print("Error sending tempTom")
            }
        }
        
    }
    
    func sendPrecipToParticle(){
        let funcArgs = [self.precip!] as [Any]
        let task = self.myPhoton!.callFunction("setPrecip", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("sent precip to particle")
            }
            else{
                print("Error sending precip")
            }
        }
        
    }
    
}


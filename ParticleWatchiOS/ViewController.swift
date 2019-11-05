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
                
                
            }
        }

    }
    
//    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//
//        DispatchQueue.main.async {
//            if (message.keys.contains("temp")){
//                print("Weather data recieved from Watch")
//
//            }
//        }
//    }
    
    
    // MARK: User variables
    let USERNAME = "letv5050@gmail.com"
    let PASSWORD = "passion100"
    
    // MARK: Device
    let DEVICE_ID = "38002a000247363333343435"
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
    
    func turnOnLights(){
        let funcArgs = ["lights on"] as [Any]
        let task = self.myPhoton!.callFunction("lightsOnOff", withArguments: funcArgs) { (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("LEDs successfully turned on")
            }
            else{
                print("Error turning on lights")
            }
        }
        var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        print("\(bytesToReceive)")
        
    }
    
    @IBAction func btnLightsOn(_ sender: Any) {
        self.turnOnLights()
    }
    
}


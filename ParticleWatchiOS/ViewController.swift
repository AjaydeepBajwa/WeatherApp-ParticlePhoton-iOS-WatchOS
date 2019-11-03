//
//  ViewController.swift
//  ParticleWatchiOS
//
//  Created by AJAY BAJWA on 2019-11-03.
//  Copyright © 2019 lambton. All rights reserved.
//

import UIKit
import Particle_SDK

class ViewController: UIViewController {
    
    // MARK: User variables
    let USERNAME = "letv5050@gmail.com"
    let PASSWORD = "passion100"
    
    // MARK: Device
    let DEVICE_ID = "38002a000247363333343435"
    var myPhoton : ParticleDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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


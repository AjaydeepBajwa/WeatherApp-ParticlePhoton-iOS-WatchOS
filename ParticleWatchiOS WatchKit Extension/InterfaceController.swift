//
//  InterfaceController.swift
//  ParticleWatchiOS WatchKit Extension
//
//  Created by AJAY BAJWA on 2019-11-03.
//  Copyright © 2019 lambton. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON
import WatchConnectivity


class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @IBOutlet weak var lblCityName: WKInterfaceLabel!
    
    @IBOutlet weak var lblTime: WKInterfaceLabel!
    @IBOutlet weak var lblTemperature: WKInterfaceLabel!
    @IBOutlet weak var lblTomTemperature: WKInterfaceLabel!
    @IBOutlet weak var lblPrecipitation: WKInterfaceLabel!
    var lat:String!
    var lng:String!
    var dateTime:Float!
    var tempToday:Float!
    var tempTomorrow:Float!
    var precip:Float!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if WCSession.isSupported() {
            print("Watch supports WCSession")
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("Session Activated")
        }
        else {
            print("Watch does not support WCSession")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let userDefaults = UserDefaults.standard
        var city = userDefaults.string(forKey: "city")
        
        if (city == nil) {
            
            city = "Toronto"
            print("Set default city Toronto, as no city was selected")
        }
        else {
            print("Got city: \(city)")
        }
        
        // update the label to show the current city
        self.lblCityName.setText(city!)
        
        //lat long
        self.lat = userDefaults.string(forKey: "latitude")
        self.lng = userDefaults.string(forKey: "longitude")
        
        if (self.lat == nil || self.lng == nil) {
            // set lat long to toronto's lat long if they are nil.
            self.lat = "43.653963"
            self.lng = "-79.387207"
        }
        print(self.lat!)
        print(self.lng!)
        
        self.getCurrentWeather()
        self.getForecast()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    public func getCurrentWeather(){
        
        let URL = "https://api.openweathermap.org/data/2.5/weather?lat=\(self.lat!)&lon=\(self.lng!)&appid=8eb59ef603c67740b0e5b7b8725d2ff3"
        
        Alamofire.request(URL).responseJSON{
            response in
            guard let apiData = response.result.value else{
                print("Error getting response from url")
                return
            }
            //print(apiData)
            
            let jsonResponse = JSON(apiData)
            let weatherDescription = jsonResponse["weather"].array![0]["description"].string
            let temperature = jsonResponse["main"]["temp"].float
            let tempCelcius = temperature! - 273.15
            let pressure = jsonResponse["main"]["pressure"].float
            let humidity = jsonResponse["main"]["humidity"].float
            let precipitation = jsonResponse["main"]["humidity"].float
            let country = jsonResponse["sys"]["country"].string
            let currentTime = jsonResponse["dt"].float
            
            let date = NSDate(timeIntervalSince1970: TimeInterval(currentTime!))
            let format = DateFormatter()
            // Set the current timezone to .current
            format.timeZone = .current
            // Set the format of the altered date.
            //            format.dateFormat = "yyyy-MM-dd' 'HH:mm:ssZ"
            // use MMMM for month String
            format.dateFormat = "h:mm a '' dd-MM-yyyy"
            // Set the current date, altered by timezone.
            let dateString = format.string(from: date as Date)
            
            self.dateTime = currentTime!
            self.tempToday = tempCelcius
            self.precip = precipitation!
            
            self.lblTemperature.setText("\(tempCelcius) °C")
            self.lblPrecipitation.setText("\(precipitation!) %")
            self.lblTime.setText("\(dateString)")
            
            print("Weather description : \(weatherDescription!)")
            print("Temperature : \(temperature!)")
            print("Temperature :\(tempCelcius) °C")
            print("Pressure: \(pressure!)")
            print("Humidity: \(humidity!)")
            print("Country: \(country!)")
            print("Current Date: \(dateString)")
        }
    }
    
    public func getForecast(){
        //api.openweathermap.org/data/2.5/forecast?lat=35&lon=139
        
        //URL to get weather forecast
        let URL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(self.lat!)&lon=\(self.lng!)&appid=8eb59ef603c67740b0e5b7b8725d2ff3"
        
        Alamofire.request(URL).responseJSON{
            response in
            guard let apiData = response.result.value else{
                print("Error getting response from url")
                return
            }
            //print(apiData)
            
            let jsonResponse = JSON(apiData)
            
            let tomorrowDescription = jsonResponse["list"].array![0]["weather"].array![0]["description"].string
            let tomorrowTemp = jsonResponse["list"].array![0]["main"]["temp"].float
            let tomorrowTempCelcius = tomorrowTemp! - 273.15
            
            self.lblTomTemperature.setText("\(tomorrowTempCelcius) °C")
            self.tempTomorrow = tomorrowTempCelcius
            
            
            print("Tomorrow Weather description : \(tomorrowDescription!)")
            print("Tomorrow Temperature : \(tomorrowTempCelcius) °C")
        }
    }

    @IBAction func btnShowOnParticle() {
        if (WCSession.default.isReachable) {
                print("phone reachable")
            let message = ["time": self.dateTime,"temp":self.tempToday,"tempTomorrow":self.tempTomorrow,"precip":precip]
            WCSession.default.sendMessage(message as [String : Any], replyHandler: nil)
                // output a debug message to the console
                print("sent weather data request to phone")
            }
            else {
                    print("WATCH: Cannot reach phone")
                }
    }
    @IBAction func btnChangeCity() {
    }
}

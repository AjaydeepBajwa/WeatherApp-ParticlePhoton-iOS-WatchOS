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


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //let URL = "https://api.sunrise-sunset.org/json?lat=\(lat!)&lng=\(lng!)&date=today"
        let URL = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=8eb59ef603c67740b0e5b7b8725d2ff3"
        
        Alamofire.request(URL).responseJSON{
            response in
            guard let apiData = response.result.value else{
                print("Error getting response from url")
                return
            }
            print(apiData)
            
            let jsonResponse = JSON(apiData)
            let weatherDescription = jsonResponse["weather"].array![0]["description"].string
            let temperature = jsonResponse["main"]["temp"].float
            let pressure = jsonResponse["main"]["pressure"].float
            let humidity = jsonResponse["main"]["humidity"].float
            let country = jsonResponse["sys"]["country"].string
            
            print("Weather description : \(weatherDescription!)")
            print("Temperature : \(temperature!)")
            print("Pressure: \(pressure!)")
            print("Humidity: \(humidity!)")
            print("Country: \(country!)")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

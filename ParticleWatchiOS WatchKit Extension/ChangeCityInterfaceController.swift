//
//  ChangeCityInterfaceController.swift
//  APIDemo WatchKit Extension
//
//  Created by AJAY BAJWA on 2019-10-30.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON


class ChangeCityInterfaceController: WKInterfaceController {

    let API_KEY = "e1dbc808f1aa9f"
    
    @IBOutlet var imgloading: WKInterfaceImage!
    @IBOutlet var lblCurrentCity: WKInterfaceLabel!
     
    var cityName = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    @IBAction func btnPickcity() {
        let suggestedResponses = ["Toronto", "Montreal", "Paris", "Rome"]

        presentTextInputController(withSuggestions: suggestedResponses, allowedInputMode: .plain) {
           
            (results) in
            
            if (results != nil && results!.count > 0) {
                // 2. write your code to process the person's response
                let userResponse = results?.first as? String
                self.lblCurrentCity.setText(userResponse)
                
                // 3. also save the user's choice to the cityName variable
                self.cityName = userResponse!
    
            }

    }
    }
    @IBAction func btnSavecity() {
     // save the city to shared preferences
     let sharedPreferences = UserDefaults.standard
     sharedPreferences.set(self.cityName, forKey:"city")
     print("Saved \(self.cityName) to user defaults!")
     
        self.imgloading.setImageNamed("Progress")
             self.imgloading.startAnimatingWithImages(in: NSMakeRange(0, 10), duration: 2, repeatCount: 0)
     // send the person back to previous screen
        self.convertToLatLng(city: self.cityName)
                       print("Done")
     self.popToRootController()
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func convertToLatLng(city:String) {
        //  Make an api call to LocationIQ.com
        
        
        let URL = "https://us1.locationiq.com/v1/search.php?key=\(API_KEY)&q=\(city)&format=json&limit=1"
        Alamofire.request(URL).responseJSON {
       
            response in
            
        
            guard let apiData = response.result.value else {
                print("Error getting data from the URL")
                return
            }

           
            let jsonResponse = JSON(apiData)
            print(jsonResponse.rawValue)
            
            let firstItem = jsonResponse.array?.first
            print(firstItem?.rawValue)
            
    
            let cityInformation = firstItem?.dictionary
            let lat = cityInformation?["lat"]!.string
            let lng = cityInformation?["lon"]!.string
            print("Latitude: \(lat!)")
            print("Longitude: \(lng!)")
            
            //Save data to userDefaults
            let userDefaults = UserDefaults.standard
            userDefaults.set(lat, forKey:"latitude")
            userDefaults.set(lng, forKey:"longitude")
            print("Done lat/long saved to userDefaults!")
            
    }

}
}

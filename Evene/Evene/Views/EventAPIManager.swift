//
//  EventAPIManager.swift
//  Evene
//
//  Created by Alfie on 2024/3/10.
//

import Foundation

class EventAPIManager : ObservableObject{
    
    @Published var eventsList : [Event] = []
    var clientId: String = "NDAzMTI4NDd8MTcwOTk2MTU3Ni40Nzc1Mzk4"
    var lat: Double = 45.5019
    var lon: Double = -73.5674
    
    func loadDataFromAPI() {
        print("Getting data from API")
        
        let websiteAddress:String
            = "https://api.seatgeek.com/2/events?lat=\(lat)&lon=\(lon)&client_id=\(clientId)"
        
        guard let apiURL = URL(string: websiteAddress) else {
            print("ERROR: Cannot convert api address to an URL object")
            return
        }
        
        let request = URLRequest(url:apiURL)
        
        let task = URLSession.shared.dataTask(with: request) {
            (data:Data?, response, error:Error?) in

   
            if let error = error {
                print("ERROR: Network error: \(error)")
                return
            }
            

            if let jsonData = data {
                print("data retreived")
                
                if let decodedResponse
                    = try? JSONDecoder().decode(EventsResponseObject.self, from:jsonData) {
                    
                    // if conversion successful, then output it to the console
                    DispatchQueue.main.async {
                        print(decodedResponse)
                        let recipes = decodedResponse.events
                        
                        self.eventsList = recipes
                        
                    }
                }
                else {
                    print("ERROR: Error converting data to JSON")
                }
            }
            else {
                print("ERROR: Did not receive data from the API")
            }
        }
        task.resume()
    }
    
}

//
//  WeatherMenager.swift
//  Clima
//
//  Created by Farrel hasyidan on 23/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherMenagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateWeather(_ weatherMenager: WeatherMenager, weather: WeatherModel)
}

struct WeatherMenager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=982cb5024981329891661c932331d190&units=metric"
    
    var delegate: WeatherMenagerDelegate?
    
    func fetcWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchhWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    //networking
    func performRequest(urlString: String){
        //1.create url
        if let url = URL(string: urlString){
            //2.create url session
            let session = URLSession(configuration: .default)
            //3.give task for session
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{ //jika ada error
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.perseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                    
                }
            }
            
            //4.start task
            task.resume()
        }
    }
    func perseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(condition: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

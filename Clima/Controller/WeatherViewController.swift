//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController
{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextFeild: UITextField!
    
    var weatherMenager = WeatherMenager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherMenager.delegate = self
        searchTextFeild.delegate = self
    }
    
}


// UITextdelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchButton(_ sender: UIButton) {
        print(searchTextFeild.text!) //buat nutup keyboard
        searchTextFeild.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextFeild.text!)
        searchTextFeild.endEditing(true) //buat nutup ketboard
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextFeild.text {
            weatherMenager.fetcWeather(cityName: city)
        }
        searchTextFeild.text = "" //untuk menghapus text search
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Wajib isi"
            return false
        }
    }
}


extension WeatherViewController: WeatherMenagerDelegate{
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherMenager: WeatherMenager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
    }
    
    
    
}
extension WeatherViewController: CLLocationManagerDelegate{
    @IBAction func locationPressed(_ sender: UIButton){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherMenager.fetchhWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



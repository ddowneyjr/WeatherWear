//
//  WeatherSingleton.swift
//  WeatherWear
//
//  Created by Derrell Downey on 11/30/23.
//

import Foundation
import CoreLocation

class WeatherSingleton: NSObject, CLLocationManagerDelegate {
    
    private static var myInstance = WeatherSingleton()
    
    

    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var currentWeather: CurrentDataItem?
    var currentTemp: Double?
    var forecast: Root?
    var models = [WeatherData]()
    
    private override init() {
        super.init()
        setupLocation()
        
    }
    
    public static func getInstance() -> WeatherSingleton {
        
        return myInstance
    }
    
    // Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation() {
                print("Got weather")
            }
        }
    }
    
    func requestWeatherForLocation(completion: @escaping () -> Void) {
        
        guard let currentLocation = currentLocation else {
            return
        }
        
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        print("\(lon) | \(lat)")
        
        let key = "4103885f8dc34c5b8374feaf9ba81ecf"
        
        let currenturl = "https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\(lon)&key=\(key)&units=I"
        let url = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(lat)&lon=\(lon)&key=\(key)&units=I"
        print(url)
        
        let currentApiService = CurrentAPIService(url: URL(string: currenturl))
        currentApiService.fetchData { (root) in
            guard let root = root else {
                print("Error fetching data")
                return
            }
            
            print(root.data[0].temp)
            print("______")
            
            self.currentWeather = root.data[0]
            self.currentTemp = self.currentWeather?.temp
            print(self.currentTemp!)
            print(self.currentWeather!)
            
            
        }
        
        let apiService = APIService(url: URL(string: url))
        apiService.fetchData { (root) in
            guard let root = root else {
                print("Error fetching data")
                return
            }
            
            print(root.data[0].temp)
            
            self.forecast = root
            
            self.models = self.forecast!.data
            
            completion()
            
            
        }
        
        
    }
}

struct APIService {
    let url: URL?

    func fetchData(completion: @escaping (Root?) -> Void) {
        guard let url = url else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let root = try JSONDecoder().decode(Root.self, from: data)
                completion(root)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
    

struct CurrentAPIService {
    let url: URL?

    func fetchData(completion: @escaping (CurrentRoot?) -> Void) {
        guard let url = url else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let root = try JSONDecoder().decode(CurrentRoot.self, from: data)
                completion(root)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}


struct Root: Codable {
    let city_name: String
    let country_code: String
    let data: [WeatherData]
    let lat: Double
    let lon: Double
    let state_code: String
    let timezone: String
}

struct WeatherData: Codable {
    let app_max_temp: Double
    let app_min_temp: Double
    let clouds: Double
    let clouds_hi: Double
    let clouds_low: Double
    let clouds_mid: Double
    let datetime: String
    let dewpt: Double
    let high_temp: Double
    let low_temp: Double
    let max_dhi: Double?
    let max_temp: Double
    let min_temp: Double
    let moon_phase: Double
    let moon_phase_lunation: Double
    let moonrise_ts: Double
    let moonset_ts: Double
    let ozone: Double
    let pop: Double
    let precip: Double
    let pres: Double
    let rh: Double
    let slp: Double
    let snow: Double
    let snow_depth: Double
    let sunrise_ts: Double
    let sunset_ts: Double
    let temp: Double
    let ts: Double
    let uv: Double
    let valid_date: String
    let vis: Double
    let weather: Weather
    let wind_cdir: String
    let wind_cdir_full: String
    let wind_dir: Double
    let wind_gust_spd: Double
    let wind_spd: Double
}

struct Weather: Codable {
    let description: String
    let code: Double
    let icon: String
}


// Structs for the current day weather

struct CurrentWeather: Codable {
    let code: Int
    let icon: String
    let description: String
}

struct CurrentDataItem: Codable {
    let app_temp: Double
    let aqi: Double
    let city_name: String
    let clouds: Double
    let country_code: String
    let datetime: String
    let dewpt: Double
    let dhi: Double
    let dni: Double
    let elev_angle: Double
    let ghi: Double
    let gust: Double?
    let h_angle: Double
    let lat: Double
    let lon: Double
    let ob_time: String
    let pod: String
    let precip: Double
    let pres: Double
    let rh: Double
    let slp: Double
    let snow: Double
    let solar_rad: Double
    let sources: [String]
    let state_code: String
    let station: String
    let sunrise: String
    let sunset: String
    let temp: Double
    let timezone: String
    let ts: Double
    let uv: Double
    let vis: Double
    let weather: Weather
    let wind_cdir: String
    let wind_cdir_full: String
    let wind_dir: Double
    let wind_spd: Double
}

struct CurrentRoot: Codable {
    let count: Int
    let data: [CurrentDataItem]
}

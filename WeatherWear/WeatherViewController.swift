//
//  WeatherViewController.swift
//  NewWeather
//
//  Created by Derrell Downey on 11/25/23.
//

import UIKit
import CoreLocation


// Important Bug:
// Currently the displayed weather for the day is the weather at 12 am not current time
// After weekly forecast is displayed add another api call to get the current temp using the other link
// Then display this information in the header to get the proper current data

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let table: UITableView = {
        let table = UITableView()
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier )
        return table
    }()
    
    var models = [WeatherData]()
//    var weekly = [DayWeather]()
    
    var weatherSingleton: WeatherSingleton? = nil
    
    
    private var currentWeather: CurrentDataItem?
    private var currentTemp: Double?
    private var forecast: Root?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register 2 cells
        
        weatherSingleton = WeatherSingleton.getInstance()
        
        
        
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        self.view.addSubview(table)
        table.frame = view.bounds
        
        table.delegate = self
        table.dataSource = self
   
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
        weatherSingleton?.requestWeatherForLocation {
            // Access the weather data inside the completion handler
            self.currentWeather = self.weatherSingleton?.currentWeather
            self.currentTemp = self.weatherSingleton?.currentTemp
            self.forecast = self.weatherSingleton?.forecast
            self.models = self.forecast!.data
                
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }
        
        
    }
    
    
    
//    // Location
//    func setupLocation() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if !locations.isEmpty, currentLocation == nil {
//            currentLocation = locations.first
//            locationManager.stopUpdatingLocation()
//            requestWeatherForLocation()
//        }
//    }
//    
//    func requestWeatherForLocation() {
//        
//        guard let currentLocation = currentLocation else {
//            return
//        }
//        
//        let lon = currentLocation.coordinate.longitude
//        let lat = currentLocation.coordinate.latitude
//        
//        print("\(lon) | \(lat)")
//        
//        let key = "4103885f8dc34c5b8374feaf9ba81ecf"
//        
//        let currenturl = "https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\(lon)&key=\(key)&units=I"
//        let url = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(lat)&lon=\(lon)&key=\(key)&units=I"
//        print(url)
//        
//        let currentApiService = CurrentAPIService(url: URL(string: currenturl))
//        currentApiService.fetchData { (root) in
//            guard let root = root else {
//                print("Error fetching data")
//                return
//            }
//            
//            print(root.data[0].temp)
//            print("______")
//            
//            self.currentWeather = root.data[0]
//            self.currentTemp = self.currentWeather?.temp
//            print(self.currentTemp!)
//            print(self.currentWeather!)
//            
//            
//        }
//        
//        let apiService = APIService(url: URL(string: url))
//        apiService.fetchData { (root) in
//            guard let root = root else {
//                print("Error fetching data")
//                return
//            }
//            
//            print(root.data[0].temp)
//            
//            self.forecast = root
//            
//            self.models = self.forecast!.data
//            
////            for day in self.forecast!.data {
////                self.weekly.append(DayWeather(highTemp: day.high_temp, lowTemp: day.low_temp, date: day.datetime))
////            }
//            
//            print(self.models)
//            
//            DispatchQueue.main.async {
//                self.table.reloadData()
//
//                self.table.tableHeaderView = self.createTableHeader()
//            }
//            
//        }
//        
//        
//    }
    
    func createTableHeader() -> UIView {
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))

        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let cityLabel = UILabel(frame: CGRect(x: 10, y: 50, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
    
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))

        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(cityLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)

        tempLabel.textAlignment = .center
        cityLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        locationLabel.text = "Current Location"
        

//        guard let currentWeather = self.forecast else {
//            return UIView()
//        }
        
        
        
        cityLabel.text = forecast?.city_name
        
        tempLabel.text = "\(self.currentTemp!)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = models[0].weather.description

        return headerVIew
    }
    
    
    
//    func toFahrenheit(temperature: Double) -> Double {
//        return ((9/5) * temperature) + 32
//    }
    
    // Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//                    // 1 cell that is collectiontableviewcell
//                    return 1
//            }
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }

    
//struct APIService {
//    let url: URL?
//
//    func fetchData(completion: @escaping (Root?) -> Void) {
//        guard let url = url else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            do {
//                let root = try JSONDecoder().decode(Root.self, from: data)
//                completion(root)
//            } catch {
//                print("Error decoding JSON: \(error)")
//                completion(nil)
//            }
//        }.resume()
//    }
//}
//    
//
//struct CurrentAPIService {
//    let url: URL?
//
//    func fetchData(completion: @escaping (CurrentRoot?) -> Void) {
//        guard let url = url else {
//            print("Invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            do {
//                let root = try JSONDecoder().decode(CurrentRoot.self, from: data)
//                completion(root)
//            } catch {
//                print("Error decoding JSON: \(error)")
//                completion(nil)
//            }
//        }.resume()
//    }
//}

}

//struct DayWeather {
//    let highTemp: Double
//    let lowTemp: Double
//    let date: String
//
//}


// Structs for the week forecast

//struct Root: Codable {
//    let city_name: String
//    let country_code: String
//    let data: [WeatherData]
//    let lat: Double
//    let lon: Double
//    let state_code: String
//    let timezone: String
//}
//
//struct WeatherData: Codable {
//    let app_max_temp: Double
//    let app_min_temp: Double
//    let clouds: Double
//    let clouds_hi: Double
//    let clouds_low: Double
//    let clouds_mid: Double
//    let datetime: String
//    let dewpt: Double
//    let high_temp: Double
//    let low_temp: Double
//    let max_dhi: Double?
//    let max_temp: Double
//    let min_temp: Double
//    let moon_phase: Double
//    let moon_phase_lunation: Double
//    let moonrise_ts: Double
//    let moonset_ts: Double
//    let ozone: Double
//    let pop: Double
//    let precip: Double
//    let pres: Double
//    let rh: Double
//    let slp: Double
//    let snow: Double
//    let snow_depth: Double
//    let sunrise_ts: Double
//    let sunset_ts: Double
//    let temp: Double
//    let ts: Double
//    let uv: Double
//    let valid_date: String
//    let vis: Double
//    let weather: Weather
//    let wind_cdir: String
//    let wind_cdir_full: String
//    let wind_dir: Double
//    let wind_gust_spd: Double
//    let wind_spd: Double
//}
//
//struct Weather: Codable {
//    let description: String
//    let code: Double
//    let icon: String
//}
//
//
//// Structs for the current day weather
//
//struct CurrentWeather: Codable {
//    let code: Int
//    let icon: String
//    let description: String
//}
//
//struct CurrentDataItem: Codable {
//    let app_temp: Double
//    let aqi: Double
//    let city_name: String
//    let clouds: Double
//    let country_code: String
//    let datetime: String
//    let dewpt: Double
//    let dhi: Double
//    let dni: Double
//    let elev_angle: Double
//    let ghi: Double
//    let gust: Double?
//    let h_angle: Double
//    let lat: Double
//    let lon: Double
//    let ob_time: String
//    let pod: String
//    let precip: Double
//    let pres: Double
//    let rh: Double
//    let slp: Double
//    let snow: Double
//    let solar_rad: Double
//    let sources: [String]
//    let state_code: String
//    let station: String
//    let sunrise: String
//    let sunset: String
//    let temp: Double
//    let timezone: String
//    let ts: Double
//    let uv: Double
//    let vis: Double
//    let weather: Weather
//    let wind_cdir: String
//    let wind_cdir_full: String
//    let wind_dir: Double
//    let wind_spd: Double
//}
//
//struct CurrentRoot: Codable {
//    let count: Int
//    let data: [CurrentDataItem]
//}

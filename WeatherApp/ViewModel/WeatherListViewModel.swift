//
//  WeatherListViewModel.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import Foundation
import Alamofire
import RealmSwift

class WeatherListViewModel {
    
    var delegate : WeatherListProtocol?
    var weatherListModel = [WeatherListModel]()
    
    func getWeatherList(lat: Double, long: Double, count: Int) {
        if let delegate = delegate {
            delegate.startLoader()
            let url = "\(ApiUrl.OPEN_WEATHER_URL)?lat=\(lat)&lon=\(long)&cnt=\(count)&appid=d150841691f8332137a99035e60907ed"
            print(url)
            let parameters: [String: Any] = [
                "lat": lat,
                "lon": long,
                "cnt": count,
                "appid": Constant.OPEN_WEATHERMAP_API
            ]
            
            print(parameters)
            
            AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(_):
                        DBManager.sharedInstance.deleteFromDb(object: self.weatherListModel)
                        delegate.stopLoader()
                        if let json = response.value {
                            let data = json as! [String:AnyObject]
                            
                            let message = data["message"] as? String ?? ""
                            let cod = data["cod"] as? String ?? ""
                            let count = data["count"] as? Int ?? 0
                            let list = data["list"] as? [NSDictionary]
                            let listModel = List<WeatherList>()
                            if cod == "200" {
                                for item in list! {
                                    let id = item.value(forKey: "id") as? Int ?? 0
                                    let name = item.value(forKey: "name") as? String ?? ""
                                    
                                    let coord = item.value(forKey: "coord") as? NSObject
                                    let coordModel = List<Coordination>()
                                    let lat = coord?.value(forKey: "lat") as? Double ?? 0.0
                                    let lon = coord?.value(forKey: "lon") as? Double ?? 0.0
                                    let newCoord = Coordination(lat: lat, lon: lon)
                                    coordModel.append(newCoord)
                                    
                                    let main = item.value(forKey: "main") as? NSObject
                                    let mainModel = List<Main>()
                                    let temp = main?.value(forKey: "temp") as? Double ?? 0.0
                                    let feels_like = main?.value(forKey: "feels_like") as? Double ?? 0.0
                                    let temp_min = main?.value(forKey: "temp_min") as? Double ?? 0.0
                                    let temp_max = main?.value(forKey: "temp_max") as? Double ?? 0.0
                                    let pressure = main?.value(forKey: "pressure") as? Int ?? 0
                                    let humidity = main?.value(forKey: "humidity") as? Int ?? 0
                                    let sea_level = main?.value(forKey: "sea_level") as? Int ?? 0
                                    let grnd_level = main?.value(forKey: "grnd_level") as? Int ?? 0
                                    let newMain = Main(temp: temp, feels_like: feels_like, temp_min: temp_min, temp_max: temp_max, pressure: pressure, humidity: humidity, sea_level: sea_level, grnd_level: grnd_level)
                                    mainModel.append(newMain)
                                    
                                    let dt = item.value(forKey: "dt") as? Int ?? 0
                                    
                                    let wind = item.value(forKey: "wind") as? NSObject
                                    let windModel = List<Wind>()
                                    let speed = wind?.value(forKey: "speed") as? Double ?? 0.0
                                    let deg = wind?.value(forKey: "deg") as? Int ?? 0
                                    let newWind = Wind(speed: speed, deg: deg)
                                    windModel.append(newWind)
                                    
                                    let sys = item.value(forKey: "sys") as? NSObject
                                    let sysModel = List<Sys>()
                                    let country = sys?.value(forKey: "country") as? String ?? ""
                                    let newSys = Sys(country: country)
                                    sysModel.append(newSys)
                                    
                                    let clouds = item.value(forKey: "clouds") as? NSObject
                                    let cloudsModel = List<Clouds>()
                                    let all = clouds?.value(forKey: "all") as? Int ?? 0
                                    let newClouds = Clouds(all: all)
                                    cloudsModel.append(newClouds)
                                    
                                    let weather = item.value(forKey: "weather") as? [NSDictionary]
                                    let weatherModel = List<Weather>()
                                    for item in weather! {
                                        let weatherId = item.value(forKey: "id") as? Int ?? 0
                                        let weatherMain = item.value(forKey: "main") as? String ?? ""
                                        let description = item.value(forKey: "description") as? String ?? ""
                                        let icon = item.value(forKey: "icon") as? String ?? ""
                                        let newWeather = Weather(id: weatherId, main: weatherMain, weatherDescription: description, icon: icon)
                                        weatherModel.append(newWeather)
                                    }
                                    
                                    let newListModel = WeatherList(id: id, name: name, dt: dt, coord: coordModel, main: mainModel, wind: windModel, sys: sysModel, clouds: cloudsModel, weather: weatherModel)
                                    print("List Model: \(newListModel)")
                                    listModel.append(newListModel)
                                }
                                
                                var weatherListModel = [WeatherListModel]()
                                
                                let newweatherListModel = WeatherListModel(message: message, cod: cod, count: count, weatherList: listModel)
                                print("Weather List Model: \(newweatherListModel)")
                                weatherListModel.append(newweatherListModel)
                                
                                DBManager.sharedInstance.addData(objs: weatherListModel)
                                
                            }
                            
                            let realmEntries = DBManager.sharedInstance.database.objects(WeatherListModel.self)
                            
                            print("weather list count")
                            print(realmEntries.count)
                            delegate.loadData()
                            
                        }
                        break
                    case .failure(let error):
                        delegate.stopLoader()
                        print(error.localizedDescription)
                        break
                    }

            }
        }
        
    }
}

protocol WeatherListProtocol {
    func startLoader()
    func stopLoader()
    func loadData()
}

//
//  WeatherListModel.swift
//  WeatherApp
//
//  Created by Suraj Kumar Mandal on 15/06/22.
//

import Foundation
import RealmSwift

class WeatherListModel : Object {
    
    @objc dynamic var message : String?
    @objc dynamic var cod : String?
    @objc dynamic var count : Int = 0
    
    // Create your Realm List.
    var weatherList = List<WeatherList>()
    
    override class func primaryKey() -> String? {
        return "cod"
    }
    
    convenience init(message:String, cod:String, count:Int, weatherList:List<WeatherList>) {
        self.init()

        self.message = message
        self.cod = cod
        self.count = count
        self.weatherList = weatherList
    }
    
}

class WeatherList : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String?
    @objc dynamic var dt : Int = 0
    
    var coord = List<Coordination>()
    var main = List<Main>()
    var wind = List<Wind>()
    var sys = List<Sys>()
    var clouds = List<Clouds>()
    var weather = List<Weather>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id:Int, name:String, dt:Int, coord:List<Coordination>, main:List<Main>, wind:List<Wind>, sys:List<Sys>, clouds:List<Clouds>, weather:List<Weather>) {
        self.init()

        self.id = id
        self.name = name
        self.dt = dt
        self.coord = coord
        self.main = main
        self.wind = wind
        self.sys = sys
        self.clouds = clouds
        self.weather = weather
    }
}

class Coordination : Object {
    @objc dynamic var lat : Double = 0.0
    @objc dynamic var lon : Double = 0.0
    
    convenience init(lat:Double, lon:Double) {
        self.init()

        self.lat = lat
        self.lon = lon
    }
}

class Main : Object {
    @objc dynamic var temp : Double = 0.0
    @objc dynamic var feels_like : Double = 0.0
    @objc dynamic var temp_min : Double = 0.0
    @objc dynamic var temp_max : Double = 0.0
    @objc dynamic var pressure : Int = 0
    @objc dynamic var humidity : Int = 0
    @objc dynamic var sea_level : Int = 0
    @objc dynamic var grnd_level : Int = 0
    
    convenience init(temp:Double, feels_like:Double, temp_min:Double, temp_max:Double, pressure:Int, humidity:Int, sea_level:Int, grnd_level:Int) {
        self.init()

        self.temp = temp
        self.feels_like = feels_like
        self.temp_max = temp_max
        self.temp_min = temp_min
        self.pressure = pressure
        self.humidity = humidity
        self.sea_level = sea_level
        self.grnd_level = grnd_level
    }
}

class Wind : Object {
    @objc dynamic var speed : Double = 0.0
    @objc dynamic var deg : Int = 0
    
    convenience init(speed:Double, deg:Int) {
        self.init()

        self.speed = speed
        self.deg = deg
    }
}

class Sys : Object {
    @objc dynamic var country : String?
    
    convenience init(country:String) {
        self.init()

        self.country = country
    }
}

class Clouds : Object {
    @objc dynamic var all : Int = 0
    
    convenience init(all:Int) {
        self.init()

        self.all = all
    }
}

class Weather : Object {
    @objc dynamic var id : Int = 0
    @objc dynamic var main : String?
    @objc dynamic var weatherDescription : String?
    @objc dynamic var icon : String?
    
    convenience init(id:Int, main:String, weatherDescription:String, icon:String) {
        self.init()

        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

//
//  ListingsEntity.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import RealmSwift

class ListingsModel: Object {
    
    @Persisted(primaryKey: true) var date: String = ""
    @Persisted var city: String
    @Persisted var main: SubObj?
    @Persisted var weather: List<SubObj>
    @Persisted var wind: SubObj?

    override class func primaryKey() -> String? {
        return "date"
    }
    
    override init() {
        super.init()
    }

    init(data: [String: Any], city: String) {
        date = data["dt_txt"] as? String ?? ""
        self.city = city
        main = SubObj(data: data["main"] as! [String : Any])
        let weatherModel = List<SubObj>()
        let weatherArray = data["weather"] as? [[String : Any]]
        for jsonData in weatherArray ?? [] {
            let weather = SubObj(data: jsonData )
            weatherModel.append(weather)
        }
        weather = weatherModel
        wind = SubObj(data: data["wind"] as? [String : Any] ?? [:])
    }
}

class SubObj: Object {
    @Persisted var temperature: Double?
    @Persisted var windSpeed: Double?
    @Persisted var humidity: Int?
    @Persisted var weatherDescription: String?
    
    override init() {
        super.init()
    }
    
    init(data: [String: Any]) {
        temperature = data["temp"] as? Double ?? 0
        windSpeed = data["speed"] as? Double ?? 0
        humidity = data["humidity"] as? Int ?? 0
        weatherDescription = data["description"] as? String ?? ""
    }
}


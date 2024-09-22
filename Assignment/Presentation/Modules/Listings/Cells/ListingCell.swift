//
//  ListingCell.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import UIKit

class ListingCell: UITableViewCell {

    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var vuMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        vuMain.slightRound()
        vuMain.addDropShadow()
    }
    
    func setupData(data: ListingsModel) {
        lblCity.text = "Date: \(data.date)"
        lblTemperature.text = "Temperature: \(data.main?.temperature ?? 0)"
        lblHumidity.text = "Humidity: \(data.main?.humidity ?? 0)"
        lblWindSpeed.text = "Wind speed: \(data.wind?.windSpeed ?? 0)"
        lblDesc.text = "Wether decsription: \(data.weather.first?.weatherDescription ?? "")"
    }
}

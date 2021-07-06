//
//  WeatherTableViewCell.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 6/07/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    public static let identifier: String = "WeatherTableViewCell"
    
    @IBOutlet var temperatureLabel: UILabel! = {
        let label = UILabel()
        return label
    }()
    @IBOutlet var weatherDateLabel: UILabel! = {
        let label = UILabel()
        return label
    }()
    @IBOutlet var minTemperatureLabel: UILabel! = {
        let label = UILabel()
        return label
    }()
    @IBOutlet var maxTemperatureLabel: UILabel! = {
        let label = UILabel()
        return label
    }()
    @IBOutlet var weatherImageView: UIImageView! = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    @IBOutlet var weatherDescriptionLabel: UILabel! = {
        let label = UILabel()
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func config(model: ConsolidatedWeather) {
        
        self.maxTemperatureLabel.text     = String(format: "Max. %.1f ºC", model.max_temp!)
        self.minTemperatureLabel.text     = String(format: "Min. %.1f ºC", model.min_temp!)
        self.temperatureLabel.text        = String(format: "%.1f ºC", model.the_temp!)
        self.weatherDateLabel.text        = model.applicable_date!
        self.weatherDescriptionLabel.text = model.weather_state_name!.capitalized
        
        DispatchQueue.main.async {
            let url: URL = URL(string: model.image_url!)!
            self.weatherImageView.downloaded(from: url)

        }
    }
}

//
//  WeatherViewController.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 5/07/21.
//

import UIKit

class WeatherViewController: UIViewController, WeatherPresenterDelegate {

    @IBOutlet var tableViewWeathers: UITableView!
    private let presenter = WeatherPresenter()
    var scSearchController = UISearchController(searchResultsController: nil)
    var weathers: [ConsolidatedWeather] = [] {
        didSet {
            if let tvWeathers = self.tableViewWeathers {
                tvWeathers.reloadData()
            }
        }
    }
    var weatherFiltered: [ConsolidatedWeather] = []
    var city: City?
    var weather: ConsolidatedWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\nviewDidLoad... ")
        
        initTableView(tableView: self.tableViewWeathers, backgroundColor: UIColor.clear)
        print("\ninitTableView... done!")

        configSearchBar(tableView: self.tableViewWeathers)
        print("\nconfigSearchBar... done!")
        
        self.presenter.setViewDelegate(delegate: self)
        
        guard let woeid = self.city?.woeid else { return }
        
        DispatchQueue.main.async {
            self.presenter.getWeathers(cityId: woeid)
        }
        
        title = self.city?.title.capitalized
        
        print("\nviewDidLoadr... done!")
    }
    
    //MARK: - Carga el resultado de climas al arreglo local y recarga la collection view que mostrará la información.
    func presentGet(weathers: [ConsolidatedWeather]) {
        self.weathers = weathers
    }

    func presentAlert(title: String, message: String) {
        showCustomAlert(self, titleApp: title, strMensaje: message, toFocus: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Extension for UISearchBar
extension WeatherViewController: UISearchBarDelegate, UISearchResultsUpdating {

    // MARK: - Configuración de la UISearchBar
    func configSearchBar(tableView: UITableView) {
        // Carga un controlador de búsqueda para implementar una barra de búsqueda de presupuestos.

        self.automaticallyAdjustsScrollViewInsets = true

        self.extendedLayoutIncludesOpaqueBars = true

        scSearchController.searchResultsUpdater = self

        scSearchController.dimsBackgroundDuringPresentation = false

        definesPresentationContext = true

        self.scSearchController.searchBar.placeholder = "Buscar ciudad..."

        //scSearchController.searchBar.scopeButtonTitles = ["Actives", "All", "Preserveds"]

        scSearchController.searchBar.delegate = self

        scSearchController.searchBar.sizeToFit()

        scSearchController.searchBar.showsCancelButton = true

        tableView.tableHeaderView = scSearchController.searchBar

        self.scSearchController.hidesNavigationBarDuringPresentation = false

        self.scSearchController.searchBar.searchBarStyle = .prominent

        self.scSearchController.searchBar.barStyle = .default

        //self.navigationItem. = self.scSearchController.searchBar

        let bottom: CGFloat = 0
        let top: CGFloat = 0
        let left: CGFloat = 0
        let right: CGFloat = 0

        tableView.contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)

        //self.tableView.tableHeaderView?.contentMode = .scaleToFill

        let coordY = 0
        let initCoord: CGPoint = CGPoint(x:0, y:coordY)

        tableView.setContentOffset(initCoord, animated: true)
    }

    // MARK: - Procedimientos para la UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.scSearchController.searchBar.resignFirstResponder()
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        if !searchText.isEmpty {
            self.weatherFiltered = self.weathers.filter {
                weather in return ((weather.applicable_date! + weather.weather_state_name!.lowercased() +  String(format: "%f", weather.the_temp!)).contains(searchText) )
            }
        }
        DispatchQueue.main.async {
            self.tableViewWeathers.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: scSearchController)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// MARK: - Extensión para UITableView
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Inicializador de la tableView de la vista
    func initTableView(tableView: UITableView, backgroundColor color: UIColor) {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.flexibleWidth]

        tableView.backgroundColor = color

        //let identifier = "cityViewCell"
        //let myBundle = Bundle(for: CityViewController.self)
        //let nib = UINib(nibName: "cityViewCell", bundle: myBundle)

        //tableView.register(nib, forCellReuseIdentifier: identifier)

        tableView.allowsMultipleSelectionDuringEditing = false
        tableView.allowsSelectionDuringEditing = true

        initTableViewRowHeight(tableView: tableView)
    }

    func initTableViewRowHeight(tableView: UITableView) {
        tableView.rowHeight = 70.0
    }

    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.weatherFiltered.count > 0 {
                return self.weatherFiltered.count
            }
        } else {
            if self.weathers.count > 0 {
                return self.weathers.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: WeatherTableViewCell? = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier) as? WeatherTableViewCell

        //var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: WeatherTableViewCell.identifier) as! WeatherTableViewCell
        }

        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.weatherFiltered.count > 0 {
                self.weather = self.weatherFiltered[indexPath.row]
            }
        } else {
            if self.weathers.count > 0 {
                self.weather = self.weathers[indexPath.row]
            }
        }

        cell?.config(model: self.weather!)
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.weatherFiltered.count > 0 {
                self.weather = self.weatherFiltered[indexPath.row]
            }
        } else {
            if self.weathers.count > 0 {
                self.weather = self.weathers[indexPath.row]
            }
        }
    }

    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

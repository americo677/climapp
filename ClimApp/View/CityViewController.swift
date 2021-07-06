//
//  CityViewController.swift
//  ClimApp
//
//  Created by Américo Cantillo Gutiérrez on 4/07/21.
//

import UIKit

class CityViewController: UIViewController, CityPresenterDelegate {
    
    @IBOutlet weak var tableViewCities: UITableView!
    
    private var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    private let presenter = CityPresenter()
    var scSearchController = UISearchController(searchResultsController: nil)
    var city: City?
    var cities: [City] = [] {
        didSet {
            if let tvCities = self.tableViewCities {
                tvCities.reloadData()
            }
        }
    }
    var citiesFiltered: [City] = []
    var weathers: [ConsolidatedWeather] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("\nviewDidLoad... ")
        
        title = "City Weather"

        initTableView(tableView: self.tableViewCities, backgroundColor: UIColor.clear)
        print("\ninitTableView... done!")

        configSearchBar(tableView: self.tableViewCities)
        print("\nconfigSearchBar... done!")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        _ = reachability?.startNotifier()
        
        self.checkReachability()

        self.presenter.setViewDelegate(delegate: self)
        self.presenter.getCities(searchText: "bogo")
        print("\npresenter?.getCities()... done!")

        print("\nviewDidLoadr... done!")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        reachability?.stopNotifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.checkReachability()
    }

    // MARK: - Verifica que el dispositivo se encuentre conectado a la red de datos o wifi.
    func checkReachability() {
        guard let r = reachability else { return }
        if r.isReachable  {
            //self.ivSignal.image = UIImage.init(named: "signal")
            //self.isOnline = true
            print("We are online ;)")
        } else {
            //self.ivSignal.image = UIImage.init(named: "nosignal")
            //self.isOnline = false
            //print("We are offline :(")
            self.showCustomAlert(self, titleApp: "Aviso ClimApp", strMensaje: "El dispositivo perdió la conexión a internet.  Por favor verifica que estés conectado a una red.", toFocus: nil)
        }
    }

    // MARK: - Observador que identifica cambios en las conexiones de red del dispositivo.
    @objc func reachabilityDidChange(_ notification: Notification) {
        self.checkReachability()
    }

    //MARK: - Carga el resultado de ciudades al arreglo local y recarga la table view que mostrará la información.
    func presentGet(cities: [City]) {
        self.cities = cities
        DispatchQueue.main.async {
            self.tableViewCities.reloadData()
        }
    }
    
    func presentAlert(title: String, message: String) {
        showCustomAlert(self, titleApp: title, strMensaje: message, toFocus: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCityToWeather" {
            let weatherViewController = segue.destination as! WeatherViewController
            weatherViewController.city = self.city
        }
    }

}

// MARK: - Extension for UISearchBar
extension CityViewController: UISearchBarDelegate, UISearchResultsUpdating {

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
        
        self.presenter.getCities(searchText: searchText)

        if !searchText.isEmpty {
            self.citiesFiltered = self.cities.filter {
                city in return (city.title.lowercased().contains(searchText.lowercased()))
            }
        }
        self.tableViewCities.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: (searchController.searchBar.text?.lowercased())!)
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: scSearchController)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        self.checkReachability()
    }
}

// MARK: - Extensión para UITableView
extension CityViewController: UITableViewDelegate, UITableViewDataSource {

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
        tableView.rowHeight = 45.0
            //Global.tableView.MAX_ROW_HEIGHT_TARJETAS
    }

    // MARK: - TableView functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections exec...")
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.citiesFiltered.count > 0 {
                return self.citiesFiltered.count
            }
        } else {
            if self.cities.count > 0 {
                return self.cities.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = "cityViewCell"

        //var cell: CellViewCity? = tableView.dequeueReusableCell(withIdentifier: identifier) as? CellViewCity

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)

        if cell == nil {
            //cell = UITableViewCell(style: .default, reuseIdentifier: identifier) as? CellViewCity
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier) as UITableViewCell
        }

        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.citiesFiltered.count > 0 {
                self.city = self.citiesFiltered[indexPath.row]
            }
        } else {
            if self.cities.count > 0 {
                self.city = self.cities[indexPath.row]
            }
        }

        cell?.textLabel?.text       = (self.city?.title.capitalized)!
        cell?.detailTextLabel?.text = (self.city?.location_type.capitalized)!

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.scSearchController.isActive && self.scSearchController.searchBar.text != "" {
            if self.citiesFiltered.count > 0 {
                self.city = self.citiesFiltered[indexPath.row]
            }
        } else {
            if self.cities.count > 0 {
                self.city = self.cities[indexPath.row]
            }
        }
        
        //DispatchQueue.main.async {
        //    self.presenter.getWeathers(cityId: (self.city?.woeid)!)
        //}
        
        self.performSegue(withIdentifier: "segueCityToWeather", sender: self)
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

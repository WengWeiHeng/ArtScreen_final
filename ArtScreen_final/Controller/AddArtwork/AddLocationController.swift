//
//  AddLocationController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/27.
//

import UIKit
import CoreLocation
import MapKit

protocol AddLocationControllerDelegate: class {
    func sendLocationData(name: String, address: String, lat: Double, log: Double)
}

private let reuseIdentifier = "AddLocationCell"

class AddLocationController: UITableViewController {
    
    //MARK: - Properties
    weak var delegate: AddLocationControllerDelegate?
    
    private let locationManager = CLLocationManager()
    private let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))

    var searchQuery: String?
    var searchResults = [MKPlacemark]()
    var searchAllResults = [MKPlacemark]()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func takeUserLocationNow() {
        print("DEBUG: Loading User Location Now..")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .black
        configureNavigationBar()
        configureTableView()
        configureLocationManager()
        
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.placeholder = "Search your artwork Location"
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Add Location"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismissal))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddLocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.tableHeaderView = searchBar
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func searchBy(naturalLanguageQuery: String, completion: @escaping([MKPlacemark]) -> Void){
        var results = [MKPlacemark]()
        let request = MKLocalSearch.Request()
        guard let coordinate = locationManager.location?.coordinate else{ return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
        request.region = region
        request.naturalLanguageQuery = naturalLanguageQuery

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            response.mapItems.forEach({ item in
                results.append(item.placemark)
            })
            completion(results)
        }
    }
}

//MARK: - LocationMenegerDelegate
extension AddLocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.delegate = nil
//        guard let searchQuery = searchQuery else { return }
//
//        let request = MKLocalSearch.Request()
//        request.region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
//        request.naturalLanguageQuery = searchQuery
//
//        let search = MKLocalSearch(request: request)
//        search.start { (response, error) in
//            guard let response = response else { return }
//            response.mapItems.forEach({ item in
//                self.searchAllResults.append(item.placemark)
//                self.searchResults = self.searchAllResults
//            })
//
//            print("DEBUG: in locationDelegate \(self.searchResults)")
//            self.tableView.reloadData()
//        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: Error is \(error.localizedDescription)")
    }
}

//MARK: - SearchBarDelegate
extension AddLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            searchResults = searchAllResults
//        } else {
//            searchQuery = searchText
//            var temp = [MKPlacemark]()
//            for result in searchResults {
//                if (result.name?.lowercased().hasPrefix(searchText.lowercased()))! {
//                    temp.append(result)
//                }
//            }
//
//            self.searchResults = []
//            self.searchResults = temp
//            print("DEBUG: in searchDelegate \(self.searchResults)")
//
//        }
//
//        tableView.reloadData()
        
        searchBy(naturalLanguageQuery: searchText) { (results) in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchQuery = ""
        searchResults = searchAllResults
        tableView.reloadData()
    }
}

//MARK: - TableViewDataSource
extension AddLocationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddLocationCell
        cell.locationNameLabel.text = searchResults[indexPath.row].name
        cell.addressLabel.text = searchResults[indexPath.row].title
        
        return cell
    }
}

//MARK: - TableviewDelegate
extension AddLocationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        guard let locationName = result.name else { return }
        guard let locationAddress = result.title else { return }
        let locationLat = result.coordinate.latitude
        let locationLog = result.coordinate.longitude
        
        dismiss(animated: true) {
            self.delegate?.sendLocationData(name: locationName, address: locationAddress, lat: locationLat, log: locationLog)
        }
    }
}

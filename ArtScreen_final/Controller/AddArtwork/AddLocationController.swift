//
//  AddLocationController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/27.
//

import UIKit
import CoreLocation
import MapKit

private let reuseIdentifier = "AddLocationCell"

class AddLocationController: UITableViewController {
    
    //MARK: - Properties
    let locationManager = CLLocationManager()
    
    let searchQuerys = ["store", "shop", "coffee", "restaurant", "hospital"]
    var searchResults = [MKMapItem]()
    var searchAllResults = [MKMapItem]()
    
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
        view.backgroundColor = .mainDarkGray
        configureNavigationBar()
        configureTableView()
//        configureLocationManager()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Add Location"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDismissal))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(takeUserLocationNow))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddLocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
//    func configureLocationManager() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestLocation()
//    }
}

extension AddLocationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AddLocationCell
        cell.locationNameLabel.text = searchResults[indexPath.row].name
        cell.addressLabel.text = searchResults[indexPath.row].placemark.title
        
        return cell
    }
}

extension AddLocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.delegate = nil
        let request = MKLocalSearch.Request()
        request.region = MKCoordinateRegion(center: locations[0].coordinate, latitudinalMeters: 50, longitudinalMeters: 50)
        
        for searchQuery in searchQuerys {
            request.naturalLanguageQuery = searchQuery
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let searchResponse = response else { return }
                self.searchAllResults.append(contentsOf: searchResponse.mapItems)
                self.searchResults = self.searchAllResults
                self.tableView.reloadData()
            }
        }
    }
}

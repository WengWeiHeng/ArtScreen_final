//
//  ArtMapController.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/10/25.
//

import UIKit
import GoogleMaps
import CoreLocation

class ArtMapController: UIViewController {
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    
    lazy var mapView = GMSMapView()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        navigationController?.navigationBar.isHidden = true
        
        setupMapView()
        setupMarker()
        
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view)
        
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        setMapStyle(mapView: self.mapView)
        
        // user Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func setupMarker() {
        let position = CLLocationCoordinate2D(latitude: 35.6981313, longitude: 139.6941118)
        let marker = GMSMarker(position: position)
        marker.title = "Hey"
        marker.map = mapView
    }
}

//MARK: - CLLocationManagerDelegate
extension ArtMapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // get user location LatLog now
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        // set camera Zoom
        let camera = GMSCameraPosition.camera(withLatitude: locationValue.latitude, longitude: locationValue.longitude, zoom: 15.0)
        self.mapView.animate(to: camera)
        locationManager.stopUpdatingLocation()
    }
}

extension ArtMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("DEBUG: Marker tapped..")
    }
}

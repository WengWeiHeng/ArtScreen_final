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
    var artworks = [Artwork]()
    private let locationManager = CLLocationManager()
    
    lazy var mapView = GMSMapView()
    private let mapInfoView = MapInfoInputView(frame: .zero)
    private var mapInfoViewBottom = NSLayoutConstraint()
    private let mapInfoViewHeight: CGFloat = 300
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArtwork()
        configureUI()
        
        print("DEBUG: artworks count is \(artworks.count)")
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.mapInfoViewBottom.constant = self.mapInfoViewHeight
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleShowInputView() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.mapInfoViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleCloseMap() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    func fetchArtwork() {
        ArtworkService.shared.fetchArtwork { artworks in
            self.artworks = artworks
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        configureNavigationBar()
        
        setupMapView()
        setupMarker()
        configureInfoInputView()
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseMap))
    }
    
    func configureInfoInputView() {
        view.addSubview(mapInfoView)
        mapInfoView.translatesAutoresizingMaskIntoConstraints = false
        mapInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapInfoViewBottom = mapInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: mapInfoViewHeight)
        mapInfoViewBottom.isActive = true
        mapInfoView.heightAnchor.constraint(equalToConstant: mapInfoViewHeight).isActive = true
        mapInfoView.layer.cornerRadius = 24
//        mapInfoView.delegate = self
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissal))
        swipeDown.direction = .down
        mapInfoView.addGestureRecognizer(swipeDown)
        
    }
    
    //MARK: - MapView Setting function
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

//MARK: - GMSMapViewDelegate
extension ArtMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        handleShowInputView()
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("DEBUG: Marker title tapped..")
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

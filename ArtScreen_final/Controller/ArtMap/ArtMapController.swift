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
    var artworks = [ArtworkDetail]() {
        didSet {
            DispatchQueue.main.async {
                for index in 0..<self.artworks.count {
                    self.setupMarker(artwork: self.artworks[index])
                }
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    
    lazy var mapView = GMSMapView()
    private let mapInfoView = MapInfoInputView(frame: .zero)
    private var mapInfoViewBottom = NSLayoutConstraint()
    private let mapInfoViewHeight: CGFloat = 300
    
    private let markerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        
        return label
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArtwork()
        configureUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func fetchArtwork(withPosition position: CLLocationCoordinate2D) {
        ArtworkService.shared.fetchArtworkWithPosition(withPosition: position) { artwork in
            self.mapInfoView.artwork = artwork
            
            DispatchQueue.main.async {
                self.handleShowInputView()
            }
        }
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        configureNavigationBar()
        
        setupMapView()
        configureInfoInputView()
        
    }
    
    func configureNavigationBar() {
        navigationBarRightItem(selector: #selector(handleCloseMap), buttonColor: .mainPurple)
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
        mapInfoView.delegate = self
        
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
    
    func setupMarker(artwork: ArtworkDetail) {
        let position = CLLocationCoordinate2D(latitude: artwork.locationLat, longitude: artwork.locationLng)
        let marker = GMSMarker(position: position)
        
        let iconImageView = UIImageView()
        iconImageView.image = #imageLiteral(resourceName: "mapIcon")
        iconImageView.setDimensions(width: 22, height: 15)
        
        let artworkImageView = UIImageView()
        artworkImageView.clipsToBounds = true
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.setDimensions(width: 50, height: 50)
        artworkImageView.backgroundColor = .mainBackground
        artworkImageView.layer.cornerRadius = 50 / 2
        artworkImageView.layer.borderWidth = 3
        artworkImageView.layer.borderColor = UIColor.mainPurple.cgColor
        artworkImageView.sd_setImage(with: artwork.path)
        
        let markerView = UIView()
        markerView.setDimensions(width: 50, height: 65)
        
        markerView.addSubview(iconImageView)
        iconImageView.centerX(inView: markerView)
        iconImageView.anchor(bottom: markerView.bottomAnchor)
        
        markerView.addSubview(artworkImageView)
        artworkImageView.centerX(inView: markerView)
        artworkImageView.centerY(inView: markerView)
        
        
        
 
        marker.iconView = markerView
        marker.map = self.mapView
        
    }
}

//MARK: - GMSMapViewDelegate
extension ArtMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let position = marker.position
        fetchArtwork(withPosition: position)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {

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

//MARK: - MapInfoInputViewDelegate
extension ArtMapController: MapInfoInputViewDelegate {
    func handleReadMore(user: User, artwork: ArtworkDetail) {
        let controller = ArtworkDetailController(user: user, artwork: artwork)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

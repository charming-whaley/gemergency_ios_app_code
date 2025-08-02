import SwiftUI
import Observation
import MapKit


@Observable
final class LocationController: NSObject, CLLocationManagerDelegate {
    
    var isPermissionDenied: Bool?
    var currentRegion: MKCoordinateRegion?
    var position: MapCameraPosition = .automatic
    var currentCoordinates: CLLocationCoordinate2D?
    
    private var locationManager: CLLocationManager = .init()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        guard status != .notDetermined else {
            return
        }
        
        isPermissionDenied = status == .denied
        if status != .denied {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else {
            return
        }
        
        currentCoordinates = coordinates
        position = .region(MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        ))
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}

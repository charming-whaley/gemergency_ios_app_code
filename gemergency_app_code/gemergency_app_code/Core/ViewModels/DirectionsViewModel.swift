import SwiftUI
import MapKit
import Observation
import Combine

@Observable
final class DirectionsViewModel {
    
    var route: MKRoute?
    var destination: MKMapItem?
    var isSettingsMenuExpanded: Bool = false
    var isDirectionsMenuExpanded: Bool = false
    var pathType: PathType = .walking
    var wrongPathCreationError: Bool = false
    
    public func getDirection(to direction: DestinationPlaces, from coordinates: CLLocationCoordinate2D) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = direction.query
        searchRequest.region = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard
                let self,
                let response = response,
                let closestPoint = response.mapItems.first
            else {
                print("[Fatal error]: couldn't get direction!")
                return
            }
            
            self.destination = closestPoint
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            directionRequest.destination = closestPoint
            directionRequest.transportType = pathType == .walking ? .walking : pathType == .automobile ? .automobile : .transit
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { [weak self] routeResponse, error in
                guard
                    let self,
                    let route = routeResponse?.routes.first
                else {
                    withAnimation(.smooth) {
                        self?.wrongPathCreationError = true
                    }
                    
                    print("[Fatal error]: couldn't create a route!")
                    return
                }
                
                DispatchQueue.main.async {
                    self.route = route
                }
            }
        }
    }
    
    public func clearRoute() {
        self.route = nil
        self.destination = nil
    }
}

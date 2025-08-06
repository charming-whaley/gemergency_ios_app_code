import Foundation
import MapKit

@frozen public enum PathType: String, CaseIterable {
    
    case walking, automobile, transit
    
    var transportType: MKDirectionsTransportType {
        switch self {
        case .walking:
            return .walking
        case .automobile:
            return .automobile
        case .transit:
            return .transit
        }
    }
    
    var symbol: String {
        switch self {
        case .walking:
            return "figure.walk"
        case .automobile:
            return "car.2.fill"
        case .transit:
            return "bus"
        }
    }
}

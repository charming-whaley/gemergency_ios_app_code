import Foundation
import SwiftUI
import MapKit

@frozen public enum DestinationPlaces: String, CaseIterable {
    
    case hospital, police, fireStation
    
    var query: String {
        switch self {
        case .hospital:
            return "hospital_prompt"
        case .police:
            return "police_prompt"
        case .fireStation:
            return "fire_station_prompt"
        }
    }
}

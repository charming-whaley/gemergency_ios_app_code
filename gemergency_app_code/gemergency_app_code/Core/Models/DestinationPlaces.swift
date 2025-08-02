@frozen public enum DestinationPlaces: String, CaseIterable {
    
    case hospital, police, fireStation
    
    var query: String {
        switch self {
        case .hospital:
            return "hospital"
        case .police:
            return "police station"
        case .fireStation:
            return "fire station"
        }
    }
}

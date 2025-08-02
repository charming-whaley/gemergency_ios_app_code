@frozen public enum PathType: String, CaseIterable {
    case walking, automobile, transit
    
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

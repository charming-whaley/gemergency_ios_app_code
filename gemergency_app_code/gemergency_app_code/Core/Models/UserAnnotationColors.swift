import SwiftUI

@frozen public enum UserAnnotationColors: String, CaseIterable {
    
    case red = "Red"
    case yellow = "Yellow"
    case blue = "Blue"
    case green = "Green"
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .yellow:
            return .yellow
        case .blue:
            return .blue
        case .green:
            return .green
        }
    }
    
    static func getColor(_ value: String) -> Color {
        switch value {
        case "Red":
            return .red
        case "Blue":
            return .blue
        case "Yellow":
            return .yellow
        case "Green":
            return .green
        default:
            return .clear
        }
    }
}

import Foundation

@frozen public enum NavigationTabs: String, CaseIterable {
    
    case directions = "Directions"
    case chat = "Help chat"
    
    var navigationTabSymbol: String {
        switch self {
        case .directions:
            return "map.fill"
        case .chat:
            return "bubble.left.fill"
        }
    }
    
    var idx: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }
}

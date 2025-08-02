import SwiftUI
import Combine

public struct Message: Identifiable, Equatable {
    
    enum Sender {
        case user, gemma
    }
    
    public var id = UUID().uuidString
    let sender: Sender
    var content: String
}

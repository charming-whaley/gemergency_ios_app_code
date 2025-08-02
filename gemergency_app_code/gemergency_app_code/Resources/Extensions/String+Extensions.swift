import Foundation

extension String {
    
    public func getDestinationPlace() -> DestinationPlaces? {
        let current = self.lowercased()
        
        if current.contains("hospital") || current.contains("er") || current.contains("medical help") || current.contains("ambulance") {
            return .hospital
        }
        
        if current.contains("police") || current.contains("cop") || current.contains("law enforcement") {
            return .police
        }
        
        if current.contains("fire") || current.contains("firefighters") || current.contains("fire station") {
            return .fireStation
        }
        
        return nil
    }
}

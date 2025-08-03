import Foundation

extension String {
    
    static var hospitalKeywords: [String] {
        return [
            "help", "ambulance", "emergency", "hospital", "doctor", "nurse", "injured",
            "accident", "pain", "bleeding", "urgent", "door", "address", "near", "left",
            "right", "straight", "floor", "heart", "attack", "stroke", "breathing",
            "unconscious", "broken", "fracture", "burn", "fever", "cold", "allergy",
            "collapse", "severe", "shock", "pulse", "dizziness", "vomit", "child", "senior",
            "pregnant", "baby", "blood", "infection", "clinic", "sick", "medication",
            "transport", "ICU", "ER", "urgentcare", "response", "critical"
        ]
    }
    
    static var policeKeywords: [String] {
        return [
            "crime", "robbery", "assault", "report", "theft", "suspicious", "help",
            "officer", "station", "witness", "victim", "emergency", "urgent", "arrest",
            "stolen", "gun", "weapon", "fight", "domestic", "breakin", "missing",
            "kidnap", "fraud", "identity", "carjacking", "vandalism", "disturbance",
            "traffic", "ticket", "investigation", "reporting", "safe", "danger", "call",
            "911", "backup", "evidence", "statement", "followup", "suspect", "description",
            "badge", "patrol", "safety", "alarm", "witnesses", "reporter", "license",
            "licenseplate", "harassment", "intimidation"
        ]
    }
    
    static var fireKeywords: [String] {
        return [
            "fire", "smoke", "burning", "alarm", "evacuate", "help", "emergency", "flames",
            "heat", "danger", "building", "rescue", "trapped", "call", "911", "firetruck",
            "hose", "hydrant", "explosion", "sparks", "wildfire", "kitchen", "electrical",
            "short", "gas", "leak", "roof", "collapse", "sirens", "water", "extinguish",
            "burn", "injured", "evacuation", "stairs", "exit", "safe", "neighbor", "smokealarm",
            "flare", "responder", "controlled", "alarmbell", "urgent", "rescueteam", "firefighter",
            "contain", "spread", "smolder"
        ]
    }
    
    static let hospitalSet: Set<String> = Set(Self.hospitalKeywords.map({ $0.lowercased() }))
    static let policeSet: Set<String> = Set(Self.policeKeywords.map({ $0.lowercased() }))
    static let fireSet: Set<String> = Set(Self.fireKeywords.map({ $0.lowercased() }))
    
    public func getDestinationPlace() -> DestinationPlaces? {
        var hospitalCount = 0, policeCount = 0, fireCount = 0
        
        let tokens = self.lowercased().components(separatedBy: CharacterSet.alphanumerics.inverted).filter({ !$0.isEmpty })
        for token in tokens {
            if Self.hospitalSet.contains(token) {
                hospitalCount += 1
            }
            
            if Self.policeSet.contains(token) {
                policeCount += 1
            }
            
            if Self.fireSet.contains(token) {
                fireCount += 1
            }
        }
        
        let result: [(DestinationPlaces, Int)] = [(.hospital, hospitalCount), (.police, policeCount), (.fireStation, fireCount)]
        let nonZeroResult = result.filter({ $0.1 > 0 })
        guard !nonZeroResult.isEmpty else {
            return nil
        }
        
        return nonZeroResult.sorted {
            if $0.1 != $1.1 {
                return $0.1 > $1.1
            }
            
            let order: [DestinationPlaces] = [.hospital, .police, .fireStation]
            return order.firstIndex(of: $0.0)! < order.firstIndex(of: $1.0)!
        }.first?.0
    }
}

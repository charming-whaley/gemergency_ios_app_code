import SwiftUI

public struct RootView: View {
    
    @EnvironmentObject var llamaState: LlamaState
    @State private var currentNavigationTab: NavigationTabs = .chat
    
    private var chatViewScreen: ChatView = .init()
    private var directionsViewScreen: DirectionsView = .init()
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            directionsViewScreen
                .environmentObject(llamaState)
                .opacity(currentNavigationTab == .directions ? 1 : 0)
                .allowsHitTesting(currentNavigationTab == .directions)
            
            chatViewScreen
                .environmentObject(llamaState)
                .opacity(currentNavigationTab == .chat ? 1 : 0)
                .allowsHitTesting(currentNavigationTab == .chat)
                        
            CustomNavigationTabBarSubview(currentNavigationTab: $currentNavigationTab)
            
            if #available(iOS 26, *) {
                
            } else {
                
            }
        }
    }
}

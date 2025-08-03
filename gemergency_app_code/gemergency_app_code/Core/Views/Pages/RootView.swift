import SwiftUI

public struct RootView: View {
    
    @EnvironmentObject var llamaState: LlamaState
    @State private var currentNavigationTab: NavigationTabs = .chat
    
    @AppStorage("isOnBoardingSheetOpen") private var isOnBoardingSheetOpen: Bool = true
    
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
        }
        .sheet(isPresented: $isOnBoardingSheetOpen) {
            CustomOnBoardingSubview(tint: .blue, title: "Gemergency") {
                Image("app_main_icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(.rect(cornerRadius: 30))
                    .padding()
                    .padding(.top, 15)
            } cards: {
                CustomOnBoardingCard(
                    symbol: "bubble.left.and.bubble.right",
                    title: "Chat with Gemma 3n",
                    description: "Need advice in case when you have health problems? Ask Google Gemma 3n for that advice!"
                )
                
                CustomOnBoardingCard(
                    symbol: "map",
                    title: "Get directions",
                    description: "Strive to get to the emergency place? With the help of Google Gemma 3n, you can easily make a route"
                )
                
                CustomOnBoardingCard(
                    symbol: "wifi.slash",
                    title: "Offline mode",
                    description: "Ask Google Gemma 3n for help in any time or situation: no need for Internet connection"
                )
            } onContinue: {
                isOnBoardingSheetOpen = false
            }
        }
    }
}

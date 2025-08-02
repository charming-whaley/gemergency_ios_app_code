import SwiftUI

@main
struct gemergency_app_codeApp: App {
    
    @StateObject private var llamaState: LlamaState = .init()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if llamaState.isModelReadyToUse {
                    RootView()
                        .environmentObject(llamaState)
                        .overlay {
                            GeometryReader { proxy in
                                CustomNotificationSubview(size: proxy.size)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            }
                            .ignoresSafeArea()
                        }
                } else {
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(.black.opacity(0.467))
                        
                        VStack(spacing: 16) {
                            ProgressView()
                            
                            Text("Preparing Google Gemma 3n for use...")
                                .font(.callout)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            .task {
                await llamaState.prepare()
            }
            .animation(.easeInOut, value: llamaState.isModelReadyToUse)
            .preferredColorScheme(.dark)
        }
    }
}

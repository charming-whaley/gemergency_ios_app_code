import SwiftUI
import AVKit

public struct ChatView: View {
    
    @EnvironmentObject var llamaState: LlamaState
    
    private static let player = createPlayer()
    @State private var userInput: String = ""
    @State private var isMenuExpanded: Bool = false
    
    @State private var isNearBottom: Bool = false
    
    public var body: some View {
        ZStack {
            ChatBackgroundView(player: Self.player)
                .ignoresSafeArea()
            
            ZStack {
                Rectangle()
                    .fill(.background.opacity(0.5))
                
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .compositingGroup()
            .ignoresSafeArea()
            .onTapGesture {
                hideKeyboard()
                
                if isMenuExpanded {
                    withAnimation(.smooth) {
                        isMenuExpanded = false
                    }
                }
            }
            
            ScrollViewReader { proxy in
                if llamaState.messages.isEmpty {
                    ContentUnavailableView(
                        "No Messages",
                        systemImage: "bubble.left.and.exclamationmark.bubble.right.fill",
                        description: Text("If you need any help, just start a conversation with Google Gemma 3n")
                    )
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(llamaState.messages) { message in
                                ChatBubbleSubview(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .contentMargins(.top, 50)
                    .contentMargins(.bottom, 180)
                    .scrollIndicators(.hidden)
                    .onChange(of: llamaState.messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo(llamaState.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
                
                if isMenuExpanded {
                    withAnimation(.smooth) {
                        isMenuExpanded = false
                    }
                }
            }
            
            VStack(spacing: 12) {
                ChatHeaderSubview(isMenuExpanded: $isMenuExpanded)
                    .onTapGesture {
                        hideKeyboard()
                    }
                
                Spacer(minLength: 0)
                
                ChatInputFieldSubview(userPrompt: $userInput)
                    .padding(.horizontal, 25)
                    .offset(y: -90)
            }
        }
        .overlay(alignment: .bottom) {
            HStack {
                Spacer(minLength: 0)
                
                Button {
                    if llamaState.isCurrentlyGenerating {
                        llamaState.stop()
                    } else {
                        if !userInput.isEmpty {
                            hideKeyboard()
                            
                            if let service = userInput.getDestinationPlace() {
                                llamaState.routeRequest.send(service)
                            }
                            
                            Task {
                                await llamaState.complete(text: userInput)
                                userInput = ""
                            }
                        }
                    }
                } label: {
                    Image(systemName: llamaState.isCurrentlyGenerating ? "button.horizontal.fill" : "location.north.fill")
                        .rotationEffect(.degrees(llamaState.isCurrentlyGenerating ? 180 : 85))
                        .font(.title3)
                        .foregroundStyle(llamaState.isCurrentlyGenerating ? Color.black : Color.white)
                        .frame(width: 56, height: 56)
                        .background {
                            if llamaState.isCurrentlyGenerating {
                                Circle()
                                    .fill(.white)
                            }
                        }
                }
                .buttonStyle(SquishyButtonStyle(squishDimensions: 1.3))
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 15)
        }
        .onAppear {
            Self.player.play()
        }
        .onDisappear {
            Self.player.pause()
        }
    }
    
    @ViewBuilder private func HeaderMenuSubview() -> some View {
        VStack(spacing: 12) {
            MenuControlSubview(title: "Archive chat", systemImage: "tray.full.fill") {
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    isMenuExpanded = false
                }
            }
            
            MenuControlSubview(title: "Delete chat", systemImage: "trash.fill") {
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    isMenuExpanded = false
                }
            }
        }
        .padding(20)
    }
}

fileprivate func createPlayer() -> AVPlayer {
    guard let url = Bundle.main.url(forResource: "a", withExtension: "mp4") else {
        fatalError("Video file a.mp4 not found in bundle.")
    }
    
    let player = AVPlayer(url: url)
    player.isMuted = true
    player.actionAtItemEnd = .none
    
    NotificationCenter.default.addObserver(
        forName: .AVPlayerItemDidPlayToEndTime,
        object: player.currentItem,
        queue: .main
    ) { _ in
        player.seek(to: .zero)
        player.play()
    }
    
    return player
}

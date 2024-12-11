import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var isLogoVisible = false
    
    var body: some View {
        ZStack {
            // Background
            Color.main
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(isLogoVisible ? 1 : 0)
                    .opacity(isLogoVisible ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(1.0), value: isLogoVisible)
                
                VStack(spacing: 1) {
                    HStack(spacing: 4) {
                        Text("Smart")
                            .bold()
                            .offset(y: isAnimating ? 0 : -200) // Come from top
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isAnimating)
                        
                        Text("English")
                            .bold()
                            .offset(y: isAnimating ? 0 : -200)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: isAnimating)
                    }
                    .font(.title)
                    
                    Text("Improve your english every day!")
                        .italic()
                        .foregroundStyle(.secondary)
                        .offset(y: isAnimating ? 0 : 50)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeInOut(duration: 0.6).delay(1.0), value: isAnimating)
                }
                
                // Loading indicator
                VStack {
                    Image(systemName: "circle.dotted")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .symbolEffect(.rotate.clockwise)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn.delay(1.5), value: isAnimating)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .onAppear {
            isAnimating = true
            isLogoVisible = true
        }
    }
}

#Preview {
    LoadingView()
}

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding public var navigationPath: NavigationPath
    let pages = [
        PageData(title: "Learn new words", subtitle: "Learn thousands of new words in real-life contexts.", image: "boarding1"),
        PageData(title: "Expand Vocabulary", subtitle: "Discover the meaning and usage of unique words.", image: "boarding2"),
        PageData(title: "Real-life Examples", subtitle: "See how words are used in sentences.", image: "boarding3"),
        PageData(title: "Interactive Practice", subtitle: "Test your knowledge with fun exercises.", image: "boarding4"),
        PageData(title: "Test Your English", subtitle: "Test your english level.", image: "boarding5"),
    ]
    
    var body: some View {
        ZStack {
            Color.main.edgesIgnoringSafeArea(.all)
            VStack {
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack {
                            Spacer()
                            
                            // Illustration
                            Image(pages[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400)
                                .padding()
                            
                            // Title and Subtitle
                            Text(pages[index].title)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.top)
                            
                            Text(pages[index].subtitle)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Page Indicators
                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(index == currentPage ? Theme.purple : Color.gray.opacity(0.5))
                    }
                }
                .padding(.bottom, 20)
                
                // Continue Button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    } else {
                        navigationPath.append(Routes.quiz)
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Take A Quiz")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.purple)
                        .foregroundColor(.main)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)
            }
        }
        
    }
}

struct PageData {
    let title: String
    let subtitle: String
    let image: String
}

#Preview {
    @Previewable @State var previewNavigationPath = NavigationPath()
    OnboardingView(navigationPath: $previewNavigationPath)
}

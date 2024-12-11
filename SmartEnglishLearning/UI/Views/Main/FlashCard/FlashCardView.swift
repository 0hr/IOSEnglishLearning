//
//  FlashCardView.swift
//  SmartEnglishLearning
//
//  Created by Harun Rasit Pekacar on 12/8/24.
//

import SwiftUI

struct DefinitionCard: Identifiable {
    let id = UUID()
    let word: String
    let pronunciation: String
    let definition: String
    let example: String
    let similarWords: [String]
}

struct SwipableDefinitionView: View {
    @State private var cards: [DefinitionCard] = [
        DefinitionCard(
            word: "invigorating",
            pronunciation: "/ɪnˈvɪɡəˌreɪtɪŋ/",
            definition: "making one feel full of strength and vitality",
            example: "The brisk morning jog through the crisp autumn air was invigorating, leaving me feeling refreshed and energized for the day ahead.",
            similarWords: ["refreshing", "energizing"]
        ),
        DefinitionCard(
            word: "serenity",
            pronunciation: "/səˈrɛnɪti/",
            definition: "the state of being calm, peaceful, and untroubled",
            example: "Sitting by the lake at dusk filled me with serenity as the world grew quiet.",
            similarWords: ["peace", "tranquility"]
        ),
        DefinitionCard(
            word: "ephemeral",
            pronunciation: "/ɪˈfɛmərəl/",
            definition: "lasting for a very short time",
            example: "The ephemeral beauty of a sunset reminds us to appreciate fleeting moments.",
            similarWords: ["transient", "momentary"]
        ),
        DefinitionCard(
            word: "Deneme",
            pronunciation: "/ɪˈfɛmərəl/",
            definition: "lasting for a very short time",
            example: "The ephemeral beauty of a sunset reminds us to appreciate fleeting moments.",
            similarWords: ["transient", "momentary"]
        ),
    ]
    
    @State private var translation: CGSize = .zero
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color.main.edgesIgnoringSafeArea(.all)
            
            if currentIndex < cards.count {
                ZStack {
                    
                    ForEach(cards.indices, id: \.self) { index in
                        cardView(for: cards[index])
                            .rotationEffect(
                                .degrees(index == 1 ? 0 : (index > 1 ? (index % 2 == 0 ? -5 : 5) : 0))
                            )
                            .zIndex(Double(cards.count - index))
                            .allowsHitTesting(false)
                            .opacity(index == currentIndex ? 0 : 1)
                    }
                    
                               
                    
                    cardView(for: cards[currentIndex])
                        .offset(x: translation.width, y: translation.height)
                        .rotationEffect(.degrees(Double(translation.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    translation = value.translation
                                }
                                .onEnded { value in
                                    let swipeThreshold: CGFloat = 150
                                    if abs(value.translation.width) > swipeThreshold {
                                        currentIndex += 1
                                        print("Current Index \(currentIndex)")
                                        translation = .zero
                                        if currentIndex >= cards.count {
                                            currentIndex = 0
                                        }
                                
                                    } else {
                                        withAnimation(.spring()) {
                                            translation = .zero
                                        }
                                    }
                                }
                        )
                        .zIndex(Double(cards.count + 1))
                }
            } else {
                // No more cards
                Text("No more cards!")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var backgroundView: some View {
        GeometryReader { geo in
            Image("autumn_background") // Replace with your background image.
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
    
    private func cardView(for card: DefinitionCard) -> some View {
        VStack(spacing: 20) {
            Text(card.word)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(card.pronunciation)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(card.definition)
                .font(.body)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            Text("Example:")
                .font(.headline)
                .foregroundColor(.black)
            
            Text(card.example)
                .font(.body)
                .italic()
                .foregroundColor(.black)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Similar Words")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    ForEach(card.similarWords, id: \.self) { synonym in
                        Text(synonym)
                            .font(.subheadline)
                            .padding(6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal)
            
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity, maxHeight: 450)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 30)
    }
}

struct FlashCardView: View {
    var body: some View {
        SwipableDefinitionView()
    }
}

#Preview {
    FlashCardView()
}

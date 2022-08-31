//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by e.lezov on 26.07.2022.
//

import SwiftUI

struct ContentView: View {
    
    private enum Constants {
        static let countOfQuestions = 8
        static let finalTitle = "Your result is"
    }
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var scoreCount = 0
    
    @State private var finalAlert = false
    
    
    @State private var currentNumberQuestion = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswerPosition = Int.random(in: 0...2)
    private var correctAnswer: String {
        self.countries[self.correctAnswerPosition]
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: .red, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(correctAnswer)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .shadow(radius: 5)
                            
                        }
                        .border(.foreground, width: 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(self.scoreCount)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Continue", action: handleContinue)
        } message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if currentNumberQuestion == Constants.countOfQuestions {
            alertTitle = "The End"
            alertMessage = "Your result is \(self.scoreCount)"
        } else if number == correctAnswerPosition {
            scoreCount += 1
            alertTitle = "Correct"
            alertMessage = "Your score is \(self.scoreCount)"
        } else {
            let userAnswer = countries[number]
            alertTitle = "Wrong! That’s the flag of \(userAnswer)"
            alertMessage = "Your score is \(self.scoreCount)"
        }
        showingAlert = true
    }
    
    func handleContinue() {
        if currentNumberQuestion == Constants.countOfQuestions {
            reset()
        } else {
            askQuestion()
        }
    }
    
    func askQuestion() {
        currentNumberQuestion += 1
        countries.shuffle()
        correctAnswerPosition = Int.random(in: 0...2)
    }
    
    func reset() {
        currentNumberQuestion = 0
        scoreCount = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

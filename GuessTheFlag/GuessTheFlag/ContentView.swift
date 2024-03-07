//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Harshit Agarwal on 21/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var alertIsShown = false
    @State private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State var flagTappedNumber: Int = 0
    @State var noOfQuestionsAsked: Int = 1
    
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.teal,.white], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack(spacing:100){
            
                VStack(spacing:30){
                    Text("Guess the Flag")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                            flagTappedNumber = number
                        }label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                VStack{
                    Text("Score: \(score)").foregroundStyle(.black)
                    Text("No of questions remaining: \(8-noOfQuestionsAsked)").foregroundStyle(.black)
                }
            }
        }.alert(scoreTitle, isPresented: $showingScore){
            
            Button("Reset Game", role: .destructive){
                score = 0
                askQuestion()
                noOfQuestionsAsked = 1
            }
            Button("Continue", role: .cancel, action: askQuestion)
        }message: {
            Text("That is the flag of \(countries[flagTappedNumber])")
            Text("Your score is \(score)")
        }
        .alert("Game Over", isPresented: $showingFinalScore){
            
            Button("New game"){
                score = 0
                askQuestion()
                noOfQuestionsAsked = 1
            }
        }message: {
            Text("Your Final score is \(score)/8")
        }
    }
    func flagTapped(_ number: Int){
        
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        } else{
            scoreTitle = "Wrong"
        }
        
        
        if noOfQuestionsAsked<8{
            
            showingScore = true
            showingFinalScore = false
        }
        else{
            showingScore = false
            showingFinalScore = true
        }
        
    }
    func askQuestion(){
        noOfQuestionsAsked+=1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}

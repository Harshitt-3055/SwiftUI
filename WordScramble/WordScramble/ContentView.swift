//
//  ContentView.swift
//  WordScramble
//
//  Created by Harshit Agarwal on 27/02/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var buttonValue = ""
    @State private var showingError = false
    @State private var showingError2 = false
    
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Create a word with '\(rootWord)' letters", text: $newWord).textInputAutocapitalization(.never).autocorrectionDisabled()
                        
                }
                Section{
                    ForEach(usedWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)}
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button(buttonValue){ }
            }message: {
                Text(errorMessage)
            }
            .toolbar{
                HStack{
                    Text("Score - \(score)")
                    Button(action: startGame, label: {
                        Text("New Word")
                    })
                    
                }
                    
                
            }
        }
        
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isStartWord(word: answer) else {
            wordError(title: "Seriously?!", message: "You that dumb?", button: "Yes I am")
            return
        }
        
        guard isOrignal(word: answer) else{
            wordError(title: "Word used already", message: "Try to be more original!", button: "Ok, I'll try")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that from '\(rootWord)'!", button: "haha ik")
            return
            
        }
        
        guard isReal(word: answer) else {
            wordError(title: "That's not even a word!", message: "Where did you get your dictionary from?", button: "from Aliexpress")
            return
        }
        
        
        withAnimation{
            usedWords.insert(answer, at: 0)
            score+=1
        }
        newWord = ""
    }
    
    func startGame(){
        usedWords = [String]()
        score = 0
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load file from bundle")
    }
    
    func isOrignal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isStartWord(word: String) -> Bool {
        if(word==rootWord){
            return false
        } else {
            return true
        }
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String, button: String) {
        errorTitle = title
        errorMessage = message
        buttonValue = button
        showingError = true
    }
}


#Preview {
    ContentView()
}

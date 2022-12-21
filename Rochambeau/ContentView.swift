//
//  ContentView.swift
//  Rochambeau
//
//  Created by Ярослав Грогуль on 20.12.2022.
//


import SwiftUI


struct ContentView: View {
    @State private var computerPick = Int.random(in: 0...2)
    @State private var userPick = 0
    @State private var score = 0
    @State private var currentRound = 1
    
    @State private var userOptsToWin = false
    
    @State private var showAlert = true
    @State private var alertTitle = "Your turn"
    @State private var alertMessage = ""
    @State private var showRetry = false
    
    private var shapes = ["Rock", "Paper", "Scissors"]
    private var shapesEmoji = ["🤜", "🖐️", "✌️"]
    private var maxRound = 10
    
    
    
    private let results = [
        "RockPaper": "lose",
        "RockScissors": "win",
        "PaperRock": "win",
        "PaperScissors": "lose",
        "ScissorsRock": "lose",
        "ScissorsPaper": "win"
    ]
    
    func ButtonWinLose(win: Bool) -> some View {
        return Button(win ? "Win" : "Lose") {
            userOptsToWin = win
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                    Color(red: 0.5-(Double(score)*0.035), green: 0.5+(Double(score)*0.035), blue: 0),
                    Color(red: 0.5-(Double(score)*0.035), green: 0.5+(Double(score)*0.035), blue: 0.1)
            ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Rochambeau")
                    .font(.largeTitle.weight(.light))
                    .foregroundColor(.white)
                Text("Playing round \(currentRound) of \(maxRound)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Current Score is: \(score)")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                HStack {
                    Text("Your objective is to")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(userOptsToWin ? "WIN" : "LOSE")")
                        .font(.headline.weight(.heavy))
                        .foregroundColor(.white)
                    
                    
                        

                }
                Text(shapesEmoji[computerPick])
                    .font(.system(size: 200))
                
                Spacer()
                VStack{
                    ForEach(0..<3) {
                        let pick = $0
    //                    Button("\(shapes[$0])") {
                        Button {

                            if currentRound == maxRound {
                                alertTitle = "Game over!"
                                alertMessage = "Your score is \(score) out of \(maxRound)!"
                                showRetry = true
                                showAlert = true
                            } else {
                                userPick = pick
                                if userPick == computerPick {
                                    alertTitle = "You wanted to \(userOptsToWin ? "win" : "lose") and you tied!"
                                    score -= 1
                                    currentRound += 1
                                } else {
                                    let result = results[shapes[userPick] + shapes[computerPick]]
                                    alertTitle = (result == "win" && userOptsToWin) || (result == "lose" && !userOptsToWin) ? "You wanted to \(userOptsToWin ? "win" : "lose") and you won!" : "You wanted to \(userOptsToWin ? "win" : "lose") and you lost!"
                                    
                                    if (result == "win" && userOptsToWin) || (result == "lose" && !userOptsToWin) {
                                        score += 1
                                    } else {
                                        score -= 1
                                    }
                                    
                                    currentRound += 1
                                }
                                alertMessage = "What will be your next turn?"
                                showAlert = true
                                computerPick = Int.random(in: 1...2)
                            }
                        } label: {
                            Text("\(shapes[pick]+" "+shapesEmoji[pick])")
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        }
                        .buttonStyle(.borderedProminent)
                        
                    }
                }
                .padding()
                
            }
            .alert(alertTitle, isPresented: $showAlert) {
                if showRetry {
                    Button("Retry") {
                        currentRound = 1
                        score = 0
                        computerPick = Int.random(in: 1...2)
                        alertTitle = "Your turn"
                        alertMessage = ""
                        showRetry = false
                    }
                } else {
                    ButtonWinLose(win: true)
                    ButtonWinLose(win: false)
                }
            } message: {
                Text(alertMessage)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

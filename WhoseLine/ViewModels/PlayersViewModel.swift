//
//  PlayersViewModel.swift
//  WhoseLine
//
//  Created by Klaudiusz Mękarski on 18/02/2024.
//

import Foundation
import SwiftUI

final class PlayersViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var tempPlayers: [Player] = []
    @Published var currentPlayers: [Player] = []
    @Published var gameMode: GameMode?
    @Published var currentQuestionIndex = 0
    @Published var currentQuestion = ""
    @Published var questions = [
        "Question 1",
        "Question 2",
        "Question 3",
        "Question 4",
        "Question 5"
    ]
    @Published var gameIsOn: Bool = true
    
    @Published var playersQueue: [Player] = []
    
    @Published var removedPlayers: [Player] = []
    
    @Published var navPath: [String] = [] {
        didSet {
            print(navPath)
            print("currentPlayersCount: ", currentPlayers.count)
        }
    }
    
    func goBack() {
        navPath.removeLast()
    }
    
    func goToMainMenu() {
        navPath.removeAll()
    }
    
    var topPlayers: [Player] {
        return removedPlayers.suffix(3).reversed()
    }
    
    func addPlayer(name: String, theme: PlayerTheme) {
        let newPlayer = Player(id: UUID().uuidString, name: name, theme: theme, lives: 3)
        tempPlayers.append(newPlayer)
    }
    
    func deletePlayer(id: String) {
        tempPlayers.removeAll { player in
            player.id == id
        }
    }
    
    func setGameMode(_ gameMode: GameMode) {
        self.gameMode = gameMode
    }
    
    func decreasePlayerLives(playerNumber: Int) {
        let currentPlayer = currentPlayers[playerNumber]
        guard let currentPlayerIndex = players.firstIndex(where: { player in
            player.id == currentPlayer.id
        }) else { return }
        if currentPlayer.lives > 0 {
            currentPlayers[playerNumber].lives -= 1
            players[currentPlayerIndex].lives -= 1
        }
        
        if currentPlayers[playerNumber].lives == 0 {
            removePlayerFromGame(currentPlayer)
        }
        
        if players.count == 1 {
            endGame()
        }
        
        print("players count: ", players.count)
    }
    
    func removePlayerFromGame(_ playerToRemove: Player) {
        players.removeAll { player in
            player.id == playerToRemove.id
        }
        removedPlayers.append(playerToRemove)
    }
    
    func nextPlayer(playerNumber: Int) {
        if let firstInQueue = playersQueue.first {
            let currentPlayer = currentPlayers[playerNumber]
            currentPlayers[playerNumber] = firstInQueue
            playersQueue.append(currentPlayer)
            playersQueue.remove(at: 0)
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
        } else {
            endGame()
        }
    }
    
    func startGame() {
        guard let gameMode = gameMode else { return }
        withAnimation(.spring()) {
            gameIsOn = true
        }
        resetPlayers()
        players = tempPlayers
        players.shuffle()
        currentPlayers = Array(players.prefix(upTo: gameMode.playersOnScreen))
        playersQueue = Array(players.suffix(from: gameMode.playersOnScreen))
        
        switch gameMode {
        case .neverHaveIEver:
            questions.shuffle()
            currentQuestion = questions.first!
            currentQuestionIndex = 0
        case .scenesFromAHat:
            break
        }
    }
    
    func endGame() {
        if let lastPlayer = players.first {
            removedPlayers.append(lastPlayer)
        }
        withAnimation(.spring()) {
            gameIsOn = false
        }
        navPath.append(AppState.gameOver.rawValue)
    }
    
    func resetPlayers() {
        players = []
        currentPlayers = []
        removedPlayers = []
    }
}

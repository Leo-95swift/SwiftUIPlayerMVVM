//
//  PlayerViewModel.swift
//  SwiftUIPlayerMVVM
//
//  Created by Levon Shaxbazyan on 02.05.24.
//

import AVFoundation

/// Класс для бизнес логики приложения
final class PlayerViewModel: ObservableObject {
    
    // MARK: - Public Properties

    @Published public var maxDuration: Float = 0.0
    @Published var isPlaying = false
    @Published public var currentTime: TimeInterval = 0
    
    // MARK: -  Private Properties

    private var player: AVAudioPlayer?
    
    // MARK: -  Public Methods
    
    public func play() {
        playSong(name: "beggin")
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }

    public func stop() {
        player?.stop()
    }
    
    public func setTime(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        player?.play()
    }
    
    public func rewindTo(value: Float) {
        guard let time = TimeInterval(exactly: value) else { return }
        player?.currentTime = time
        player?.play()
    }
    
    // MARK: -  Private Methods
    
    private func playSong(name: String) {
        if player != nil { return }
        
        guard let audioPath = Bundle.main.path(
            forResource: name,
            ofType: "mp3") else { return }
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            maxDuration = Float(player?.duration ?? 0.0)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if let currentTime = self.player?.currentTime {
                    self.currentTime = currentTime
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

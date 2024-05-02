//
//  ContentView.swift
//  SwiftUIPlayerMVVM
//
//  Created by Levon Shaxbazyan on 02.05.24.
//

import SwiftUI

/// Предстовление экрана плеера
struct ContentView: View {
    
    // MARK: - Constants
    
    enum Constants {
        // Image names
        static let mainImageName = "spring"
        static let smallImageName = "waterfall"
        
        // Button image names
        static let downloadButton = "download"
        static let shareButton = "share"
        static let previousButton = "previous"
        static let nextButton = "next"
        static let playButton = "play"
        static let pauseButton = "pause"

        // Label names
        static let singerName = "Неизвестный исполнитель"
        static let songName = "Звуки природы"
    }
    
    // MARK: - @State Private Properties
    
    @State private var progress: Float = 0
    @State private var showActionSheet = false
    @State private var showAlert = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.viewBackground
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 48) {
                    Image(Constants.mainImageName)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    VStack {
                        musicInfoView
                        Slider(value: Binding(get: {
                            Float(viewModel.currentTime)
                        }, set: { newValue in
                            viewModel.currentTime = TimeInterval(newValue)
                            viewModel.rewindTo(value: newValue)
                        }), in: 0...100)
                            .padding()
                    }
                }
                buttonsView
            }.padding()
        }
        
    }
    
    // MARK: - Private Properties
    
   @ObservedObject private var viewModel = PlayerViewModel()
    
    // MARK: - Visual Elements
    
    private var buttonsView: some View {
        HStack(spacing: 40) {
            Button {
                print("Previous button tapped")
            } label: {
                Image(Constants.previousButton)
            }
            
            Button {
                viewModel.play()
            } label: {
                let imageName = viewModel.isPlaying
                ? Constants.pauseButton
                : Constants.playButton
                Image(imageName)
            }
            
            Button {
                print("Next button tapped")
            } label: {
                Image(Constants.nextButton)
            }
        }
    }
    
    private var musicInfoView: some View {
        HStack {
            Image(Constants.smallImageName)
            VStack(alignment: .leading) {
                HStack {
                    Text(Constants.singerName)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        showActionSheet = true
                    }, label: {
                        Image(Constants.downloadButton)
                    })
                    .confirmationDialog(
                        "Песня \(Constants.songName) сохранена в папку загрузки",
                        isPresented: $showActionSheet,
                        titleVisibility: .visible, actions: {})
                    
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Image(Constants.shareButton)
                    })
                    .alert(isPresented: $showAlert, content: {
                        Alert(title: Text("Поделиться"), primaryButton: .default(Text("Нет")), secondaryButton: .default(Text("Да")))
                    })
                }
                Text(Constants.songName)
                    .foregroundColor(.descriptionText)
            }
        }
    }

}

#Preview {
    ContentView()
}

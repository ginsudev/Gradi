//
//  GRMediaModel.swift
//  
//
//  Created by Noah Little on 21/7/2022.
//

import GradiC
import UIKit

final class GRMediaModel: ObservableObject {
    static let sharedInstance = GRMediaModel()
    
    //Now playing app
    @Published var routeName = "Gradi"
    @Published var nowPlayingAppIcon = UIImage(systemName: "airplayaudio")!
    
    //Current track info
    @Published var trackName = ""
    @Published var artistName = ""
    @Published var albumArtwork = UIImage(systemName: "music.note")! {
        didSet {
            artworkColour = albumArtwork.dominantColour()
        }
    }
    
    @Published var trackLength: Float = 0.0
    @Published var elapsedTime: Float = 0.0
    
    //Dynamic icons
    @Published var playPauseIcon = UIImage(named: "\(GRManager.sharedInstance.themePath())pause.png")

    //Colours
    @Published var artworkColour: UIColor = .black {
        didSet {
            foregroundColour = artworkColour.suitableForegroundColour()
        }
    }
    
    @Published var foregroundColour: UIColor = .white
    
    //Lock screen visible state
    @Published var screenOn = false
    
    private init() {}
}

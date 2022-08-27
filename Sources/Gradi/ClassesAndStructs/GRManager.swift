//
//  GRManager.swift
//  
//
//  Created by Noah Little on 24/7/2022.
//

import GradiC

final class GRManager: NSObject {
    static let sharedInstance = GRManager()
    private var timer = Timer()
    var timerRunning = false
    
    public func updateInfo() {
        //Update track info (Artwork, title, artist, etc..).
        MRMediaRemoteGetNowPlayingInfo(.main, { information in
            guard let dict = information as? [String: AnyObject] else {
                return
            }
            
            guard let contentItem = MRContentItem(nowPlayingInfo: dict) else {
                return
            }
            
            //Track name & artist
            GRMediaModel.sharedInstance.trackName = contentItem.metadata.title ?? ""
            GRMediaModel.sharedInstance.artistName = contentItem.metadata.trackArtistName ?? ""
            
            //Album artwork
            if let data = dict["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                GRMediaModel.sharedInstance.albumArtwork = UIImage(data: data)!
            }
            
            //Playing status
            self.togglePlayPause(shouldPlay: (contentItem.metadata.playbackRate > 0))
            
        })
    }
    
    @objc private func updateTimeline() {
        //Update track progress & length.
        MRMediaRemoteGetNowPlayingInfo(.main, { information in
            guard let dict = information as? [String: AnyObject] else {
                return
            }
            
            guard let contentItem = MRContentItem(nowPlayingInfo: dict) else {
                return
            }
            
            let playbackPosition = contentItem.metadata.calculatedPlaybackPosition
            GRMediaModel.sharedInstance.elapsedTime = Float(playbackPosition < 0 ? 0 : playbackPosition)
            
            
            //Track length
            let duration = contentItem.metadata.duration
            GRMediaModel.sharedInstance.trackLength = Float(duration < 0 ? 0 : duration)
        })
    }
    
    public func toggleTimer(on enable: Bool) {
        //Disable the timer if requested.
        guard enable else {
            if self.timer.isValid {
                self.timer.invalidate()
                timerRunning = false
            }
            return
        }
        
        //One timer only
        guard !self.timer.isValid else {
            return
        }
        
        //Only start timer if media is playing.
        guard SBMediaController.sharedInstance().nowPlayingApplication() != nil && !SBMediaController.sharedInstance().isPaused() else {
            return
        }
        
        //Start timer.
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTimeline),
                                     userInfo: nil,
                                     repeats: true)
        
        //Update timer status.
        timerRunning = true
    }
    
    public func togglePlayPause(shouldPlay play: Bool) {
        let iconPath = "\(themePath())\(play ? "pause": "play").png"
        GRMediaModel.sharedInstance.playPauseIcon = UIImage(named: iconPath)
    }
    
    public func setElapsedTime(_ time: Double) {
        MRMediaRemoteSetElapsedTime(time)
    }
    
    public func openNowPlayingApp() {
        guard let nowPlayingApp = SBMediaController.sharedInstance().nowPlayingApplication() else {
            return
        }
        
        let bundleID = nowPlayingApp.bundleIdentifier
        
        let launchOptions = [
            FBSOpenApplicationOptionKeyPromptUnlockDevice: NSNumber(value: 1),
            FBSOpenApplicationOptionKeyUnlockDevice: NSNumber(value: 1)
        ]
        
        let service = FBSSystemService.sharedService() as! FBSSystemService
        service.openApplication(bundleID, options: launchOptions, withResult: nil)
    }
    
    public func themePath() -> String {
        return "\(GSUtilities.sharedInstance().rootPrefix()!)Library/Application Support/Gradi/Themes/\(Settings.themeName!)/"
    }
    
    private override init() {}
}

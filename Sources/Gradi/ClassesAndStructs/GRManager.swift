//
//  GRManager.swift
//  
//
//  Created by Noah Little on 24/7/2022.
//

import GradiC

final class GRManager: NSObject {
    static let sharedInstance = GRManager()
    var timer = Timer()
    var timerRunning = false
    
    public func updateInfo() {
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
        MRMediaRemoteGetNowPlayingInfo(.main, { information in
            guard let dict = information as? [String: AnyObject] else {
                return
            }
            
            guard let contentItem = MRContentItem(nowPlayingInfo: dict) else {
                return
            }
            
            if !(contentItem.metadata.playbackRate > 0) {
                self.timer.invalidate()
                self.timerRunning = false
            }
            
            let playbackPosition = contentItem.metadata.calculatedPlaybackPosition
            GRMediaModel.sharedInstance.elapsedTime = Float(playbackPosition < 0 ? 0 : playbackPosition)
            
            
            //Track length
            let duration = contentItem.metadata.duration
            GRMediaModel.sharedInstance.trackLength = Float(duration < 0 ? 0 : duration)
        })
    }
    
    public func toggleTimer(on enable: Bool) {
        guard enable else {
            if self.timer.isValid {
                self.timer.invalidate()
                timerRunning = false
            }
            return
        }
        
        //One timer only
        if self.timer.isValid {
            self.timer.invalidate()
            timerRunning = false
        }
        
        guard !SBMediaController.sharedInstance().isPaused() else {
            return
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTimeline),
                                     userInfo: nil,
                                     repeats: true)
        
        timerRunning = true
    }
    
    public func togglePlayPause(shouldPlay play: Bool) {
        let iconPath = "/Library/Application Support/Gradi/\(play ? "pause": "play").png"
        GRMediaModel.sharedInstance.playPauseIcon = UIImage(named: iconPath)
    }
    
    public func setElapsedTime(_ time: Double) {
        MRMediaRemoteSetElapsedTime(time)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //Resume timer if still playing...
            
            guard !SBMediaController.sharedInstance().isPaused() else {
                return
            }
            
            self.toggleTimer(on: true)
        }
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
    
    private override init() {}
}

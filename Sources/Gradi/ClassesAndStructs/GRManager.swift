//
//  GRManager.swift
//  
//
//  Created by Noah Little on 24/7/2022.
//

import GradiC

final class GRManager: NSObject {
    static let sharedInstance = GRManager()
    
    public func togglePlayPause(shouldPlay play: Bool) {
        let iconPath = "/Library/Application Support/Gradi/\(play ? "pause": "play").png"
        GRMediaModel.sharedInstance.playPauseIcon = UIImage(named: iconPath)
    }
    
    public func updateInfo() {
        MRMediaRemoteGetNowPlayingInfo(.main, { information in
            guard let dict = information as? [String: AnyObject] else {
                return
            }
            
            //Track name & artist
            GRMediaModel.sharedInstance.trackName = dict["kMRMediaRemoteNowPlayingInfoTitle"] as? String ?? ""
            GRMediaModel.sharedInstance.artistName = dict["kMRMediaRemoteNowPlayingInfoArtist"] as? String ?? ""
            
            //Album artwork
            if let data = dict["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data {
                GRMediaModel.sharedInstance.albumArtwork = UIImage(data: data)!
            }
            
            //Playing status
            if let playbackRate = dict["kMRMediaRemoteNowPlayingInfoPlaybackRate"] as? Float {
                let playing = playbackRate > 0.0
                self.togglePlayPause(shouldPlay: playing)
            }
            
        })
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

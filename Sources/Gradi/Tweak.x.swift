import Orion
import GradiC
import CoreGraphics
import SwiftUI

//MARK: - Settings
struct Settings {
    static var isEnabled: Bool!
    static var height: Double!
    static var cornerRadius: CGFloat!
    static var fontType: Font.Design!
}

struct tweak: HookGroup {}

//MARK: - Gradi media player initialisation.
class CSAdjunctItemView_Hook: ClassHook<CSAdjunctItemView> {
    typealias Group = tweak

    func _updateSizeToMimic() {
        orig._updateSizeToMimic()
        
        //Set height for our media player.
        target.heightAnchor.constraint(equalToConstant: Settings.height).isActive = true
    }
    
    func _setPlatterView(_ view: UIView) {
        /* We need to replace this view with a UIView subclass that conforms to the PLPlatter
           protocol, otherwise device will panic. */
        let base = GRMediaBaseView(frame: view.frame)
        orig._setPlatterView(base)
    }
    
    func didAddSubview(_ subview: UIView) {
        orig.didAddSubview(subview)
        
        //Remove stock player controls.
        guard subview is GRMediaBaseView else {
            subview.removeFromSuperview()
            return
        }
        
        //Set constraints for our media player
        subview.heightAnchor.constraint(equalTo: target.heightAnchor).isActive = true
        subview.widthAnchor.constraint(equalTo: target.widthAnchor).isActive = true
        subview.centerXAnchor.constraint(equalTo: target.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: target.centerYAnchor).isActive = true
    }
}

//MARK: - Updating route name on change
class MPAVRoutingController_Hook: ClassHook<MPAVRoutingController> {
    typealias Group = tweak

    func _scheduleSendDelegateRoutesChanged() {
        orig._scheduleSendDelegateRoutesChanged()
        //Update connected audio route name.
        GRMediaModel.sharedInstance.routeName = SBMediaController.sharedInstance().nameOfPickedRoute()
    }
}

//MARK: - Now playing app and currently playing track info.
class SBMediaController_Hook: ClassHook<SBMediaController> {
    typealias Group = tweak
    
    func _mediaRemoteNowPlayingApplicationIsPlayingDidChange(_ arg1: AnyObject) {
        orig._mediaRemoteNowPlayingApplicationIsPlayingDidChange(arg1)
        
        //Get the now playing app icon
        if let mediaApp = target.nowPlayingApplication() {
            GRMediaModel.sharedInstance.nowPlayingAppIcon = UIImage.appIcon(withBundleIdentifier: mediaApp.bundleIdentifier)
        } else {
            GRMediaModel.sharedInstance.nowPlayingAppIcon = UIImage(systemName: "airplayaudio")!
        }
        
        //Update play/pause button status.
        GRManager.sharedInstance.togglePlayPause(shouldPlay: !target.isPaused())
    }
    
    func _mediaRemoteNowPlayingInfoDidChange(_ info: NSDictionary) {
        orig._mediaRemoteNowPlayingInfoDidChange(info)
        //Update current track info.
        GRManager.sharedInstance.updateInfo()
    }
}

//MARK: - Refresh media info on SpringBoard launch.
class SpringBoard_Hook: ClassHook<SpringBoard> {
    typealias Group = tweak
    
    func applicationDidFinishLaunching(_ application: AnyObject) {
        orig.applicationDidFinishLaunching(application)
        
        /* If media plays through a respring, we need this code to update the media info when SpringBoard
         launches so that the play/pause button shows the correct image. */
        
        SBMediaController.sharedInstance().setNowPlayingInfo(0)
    }
}

//MARK: - Preferences
func readPrefs() {
    
    let path = "/var/mobile/Library/Preferences/com.ginsu.gradi.plist"
    
    if !FileManager().fileExists(atPath: path) {
        try? FileManager().copyItem(atPath: "Library/PreferenceBundles/gradi.bundle/defaults.plist", toPath: path)
    }
    
    guard let dict = NSDictionary(contentsOfFile: path) else {
        return
    }
    
    //Reading values
    Settings.isEnabled = dict.value(forKey: "isEnabled") as? Bool ?? true
    Settings.height = dict.value(forKey: "height") as? Double ?? 120.0
    Settings.cornerRadius = dict.value(forKey: "cornerRadius") as? CGFloat ?? 5.0
    
    let fontType = dict.value(forKey: "fontType") as? Int ?? 2
    switch fontType {
    case 1:
        Settings.fontType = .default
        break
    case 2:
        Settings.fontType = .rounded
        break
    case 3:
        Settings.fontType = .monospaced
        break
    case 4:
        Settings.fontType = .serif
        break
    default:
        Settings.fontType = .rounded
        break
    }
}

struct Gradi: Tweak {
    init() {
        readPrefs()
        if (Settings.isEnabled) {
            tweak().activate()
        }
    }
}
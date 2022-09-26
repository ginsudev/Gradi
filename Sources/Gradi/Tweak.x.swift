import Orion
import GradiC
import CoreGraphics
import SwiftUI

struct Main: HookGroup {}
struct LockscreenOberver: HookGroup {}

//MARK: - Gradi media player initialisation.
class CSAdjunctItemView_Hook: ClassHook<CSAdjunctItemView> {
    typealias Group = Main

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
    typealias Group = Main

    func _scheduleSendDelegateRoutesChanged() {
        orig._scheduleSendDelegateRoutesChanged()
        //Update connected audio route name.
        GRMediaModel.sharedInstance.routeName = SBMediaController.sharedInstance().nameOfPickedRoute()
    }
}

//MARK: - Now playing app and currently playing track info.
class SBMediaController_Hook: ClassHook<SBMediaController> {
    typealias Group = Main
    
    func _mediaRemoteNowPlayingApplicationIsPlayingDidChange(_ arg1: AnyObject) {
        orig._mediaRemoteNowPlayingApplicationIsPlayingDidChange(arg1)
        
        //Get the now playing app icon
        if let nowPlayingApp = target.nowPlayingApplication() {
            GRMediaModel.sharedInstance.nowPlayingAppIcon = UIImage(withBundleIdentifier: nowPlayingApp.bundleIdentifier)
        } else {
            GRMediaModel.sharedInstance.nowPlayingAppIcon = UIImage(systemName: "airplayaudio")!
        }
        
        //Update play/pause button status.
        GRManager.sharedInstance.togglePlayPause(shouldPlay: !target.isPaused())
        
        if !target.isPaused() {
            if !GRManager.sharedInstance.timerRunning {
                GRManager.sharedInstance.toggleTimer(on: true)
            }
        }
    }
    
    func setNowPlayingInfo(_ info: NSDictionary) {
        orig.setNowPlayingInfo(info)
        //Update current track info.
        GRManager.sharedInstance.updateInfo()
    }
}

//MARK: - Refresh media info on SpringBoard launch.
class SpringBoard_Hook: ClassHook<SpringBoard> {
    typealias Group = Main
    
    func applicationDidFinishLaunching(_ application: AnyObject) {
        orig.applicationDidFinishLaunching(application)
        
        /* If media plays through a respring, we need this code to update the media info when SpringBoard
         launches so that the play/pause button shows the correct image. */
        
        SBMediaController.sharedInstance().setNowPlayingInfo(0)
    }
}

class SBLockScreenManager_Hook: ClassHook<SBLockScreenManager> {
    typealias Group = LockscreenOberver
    
    func lockScreenViewControllerDidDismiss() {
        orig.lockScreenViewControllerDidDismiss()
        //Lock screen dismissed
        GRManager.sharedInstance.toggleTimer(on: false)
    }
    
    func lockScreenViewControllerDidPresent() {
        orig.lockScreenViewControllerDidPresent()
        
        guard GRMediaModel.sharedInstance.screenOn else {
            return
        }
        
        //Lock screen presented
        GRManager.sharedInstance.toggleTimer(on: true)
    }
    
    func _handleBacklightLevelWillChange(_ arg1: NSNotification) {
        orig._handleBacklightLevelWillChange(arg1)
        
        guard let userInfo = arg1.userInfo else {
            return
        }
        
        guard let updatedBacklightLevel = userInfo["SBBacklightNewFactorKey"] as? Int else {
            return
        }
        
        GRMediaModel.sharedInstance.screenOn = updatedBacklightLevel != 0
        
        //Screen turned on/off.
        GRManager.sharedInstance.toggleTimer(on: GRMediaModel.sharedInstance.screenOn)
    }
}

//MARK: - Preferences
fileprivate func prefsDict() -> [String : AnyObject]? {
    var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
    
    let path = "/var/mobile/Library/Preferences/com.ginsu.gradi.plist"
    
    if !FileManager().fileExists(atPath: path) {
        try? FileManager().copyItem(atPath: "Library/PreferenceBundles/gradi.bundle/defaults.plist",
                                    toPath: path)
    }
    
    let plistURL = URL(fileURLWithPath: path)

    guard let plistXML = try? Data(contentsOf: plistURL) else {
        return nil
    }
    
    guard let plistDict = try! PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String : AnyObject] else {
        return nil
    }
    
    return plistDict
}

fileprivate func readPrefs() {
    
    let dict = prefsDict() ?? [String : AnyObject]()
    
    //Reading values
    Settings.isEnabled = dict["isEnabled"] as? Bool ?? true
    Settings.height = dict["height"] as? Double ?? 120.0
    Settings.cornerRadius = dict["cornerRadius"] as? CGFloat ?? 5.0
    Settings.showTimeline = dict["showTimeline"] as? Bool ?? false
    Settings.showNPInfo = dict["showNPInfo"] as? Bool ?? true
    Settings.timelineHeight = dict["timelineHeight"] as? CGFloat ?? 5.0
    Settings.scrollingLabels = dict["scrollingLabels"] as? Bool ?? false
    Settings.themeName = dict["themeName"] as? String ?? "Sharp"

    let fontType = dict["fontType"] as? Int ?? 2
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
            Main().activate()
            
            if Settings.showTimeline || Settings.scrollingLabels {
                LockscreenOberver().activate()
            }
        }
    }
}

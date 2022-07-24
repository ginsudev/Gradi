#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "MediaRemote.h"

FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyUnlockDevice;
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyActivateSuspended;
FOUNDATION_EXPORT NSString *const FBSOpenApplicationOptionKeyPromptUnlockDevice;

struct SBIconImageInfo {
    struct CGSize size;
    double scale;
    double continuousCornerRadius;
};

@interface SBIcon : NSObject
@property (nonatomic,copy,readonly) NSString * displayName;
- (id)generateIconImageWithInfo:(struct SBIconImageInfo)arg1;
- (Class)iconImageViewClassForLocation:(id)arg1 ;
@end

@interface SBIconModel : NSObject
- (SBIcon *)expectedIconForDisplayIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject
@property (nonatomic,retain) SBIconModel * model;
+ (instancetype)sharedInstance;
@end

@interface FBSSystemService : NSObject
+ (id)sharedService;
- (void)openApplication:(NSString *)app options:(NSDictionary *)options withResult:(void (^)(void))result;
@end

@interface SpringBoard : UIApplication
@end

@protocol PLContentSizeManaging <NSObject>

@required
-(CGSize)contentSizeForSize:(CGSize)arg1;
-(CGSize)sizeThatFitsContentWithSize:(CGSize)arg1;
@end

@protocol PLPlatter <PLContentSizeManaging>

@property (nonatomic,readonly) UIView * customContentView;
@property (assign,nonatomic) BOOL hasShadow;
@property (assign,getter=isBackgroundBlurred,nonatomic) BOOL backgroundBlurred;
@required
-(UIView *)customContentView;
-(void)setBackgroundBlurred:(BOOL)arg1;
-(void)setHasShadow:(BOOL)arg1;
-(BOOL)isBackgroundBlurred;
-(BOOL)hasShadow;
@end

@interface PLPlatterView : UIView
@end

@interface CSMediaControlsView : UIView
@end

@interface CSAdjunctItemView : UIView
@end

@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * bundleIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end

@interface MPAVRoutingController : NSObject
@end

@interface MRContentItemMetadata : NSObject
@property (nonatomic,copy) NSString * title;
@end

@interface MRContentItem : NSObject
@property (nonatomic,copy) MRContentItemMetadata * metadata;
@end

@interface SBMediaController : NSObject
+ (instancetype)sharedInstance;
- (SBApplication *)nowPlayingApplication;
- (BOOL)isPaused;
- (NSString *)nameOfPickedRoute;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (void)setNowPlayingInfo:(id)arg1;

@end

@interface AVRoutePickerView (Private)
-(void)_routePickerButtonTapped:(id)arg1;
@end

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface UIViewController (Private)
- (BOOL)_canShowWhileLocked;
@end

//
//  AnimatingViewController.m
//  Fireworks
//
//  Created by Mo DeJong on 10/3/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "AnimatingViewController.h"

#import "AppDelegate.h"

#import "AutoTimer.h"

#import "MediaManager.h"

#import "AVAnimatorView.h"
#import "AVAnimatorMedia.h"
#import "AVAsset2MvidResourceLoader.h"
#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVMvidFrameDecoder.h"

@interface AnimatingViewController ()

@property (nonatomic, retain) IBOutlet UILabel *fireworksLabel;

@property (nonatomic, retain) AutoTimer *fireworksLabelTimer;

@property (nonatomic, retain) IBOutlet UIView *redContainer;

@property (nonatomic, retain) AVAnimatorView *redAnimatorView;

@property (nonatomic, retain) IBOutlet UIView *wheelContainer;

@property (nonatomic, retain) AVAnimatorView *wheelAnimatorView;

// The field is the extents of the (X,Y,W,H) where fireworks
// can explode. The upper right corner is (0.0, 0.0) and the
// lower right corner is at (1.0, 1.0)

@property (nonatomic, retain) IBOutlet UIView *fieldContainer;

@property (nonatomic, retain) AVAnimatorView *fieldSubview;

@end

@implementation AnimatingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
 
  NSAssert(self.wheelContainer, @"wheelContainer");
  NSAssert(self.redContainer, @"redContainer");
  NSAssert(self.fireworksLabel, @"fireworksLabel");
  
  self.fireworksLabel.hidden = TRUE;
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager = appDelegate.mediaManager;
  
  AVAsset2MvidResourceLoader *wheelLoader = mediaManager.wheelLoader;
  NSAssert(wheelLoader, @"wheelLoader");

  AVAnimatorMedia *wheelMedia = [AVAnimatorMedia aVAnimatorMedia];
  NSAssert(wheelMedia, @"wheelMedia");
  
  wheelMedia.animatorRepeatCount = 0xFFFF;
  
  mediaManager.wheelMedia = wheelMedia;
  
	wheelMedia.resourceLoader = wheelLoader;

  AVMvidFrameDecoder *frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  wheelMedia.frameDecoder = frameDecoder;

  //CGRect wheelFrame = self.wheelContainer.frame;
  CGRect wheelBounds = self.wheelContainer.bounds;
  AVAnimatorView *wheelAnimatorView = [AVAnimatorView aVAnimatorViewWithFrame:wheelBounds];
  self.wheelAnimatorView = wheelAnimatorView;
  
  [self.wheelContainer addSubview:wheelAnimatorView];
  
  // Create red animation
  
  AVAsset2MvidResourceLoader *redLoader = mediaManager.redLoader;
  NSAssert(redLoader, @"redLoader");
  
  AVAnimatorMedia *redMedia = [AVAnimatorMedia aVAnimatorMedia];
  
	redMedia.resourceLoader = redLoader;
  
  mediaManager.redMedia = redMedia;
  
  CGRect redBounds = self.redContainer.bounds;
  AVAnimatorView *redAnimatorView = [AVAnimatorView aVAnimatorViewWithFrame:redBounds];
  self.redAnimatorView = redAnimatorView;
  
  redMedia.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];

  [self.redContainer addSubview:redAnimatorView];
  
  // L112
  
  mediaManager.L112Media = [AVAnimatorMedia aVAnimatorMedia];
  
  mediaManager.L112Media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  mediaManager.L112Media.resourceLoader = mediaManager.L112Loader;

  [mediaManager.L112Media prepareToAnimate];
  
  // Invoke prepareToAnimate so that calling attachMedia will
  // set the image to the first frame in the already loaded media.
  
  [wheelMedia prepareToAnimate];
  [redMedia prepareToAnimate];
  
  // Link media to views
  
  [wheelAnimatorView attachMedia:wheelMedia];
  
  [redAnimatorView attachMedia:redMedia];
  
  return;
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // Kick off fireworks label animation
  
  self.fireworksLabelTimer = [AutoTimer autoTimerWithTimeInterval:1.0
                                                            target:self
                                                          selector:@selector(startAnimatingFireworkLabel)
                                                          userInfo:nil
                                                          repeats:FALSE];
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager = appDelegate.mediaManager;
  
  [mediaManager.wheelMedia startAnimator];
  [mediaManager.redMedia startAnimator];
}

- (void) startAnimatingFireworkLabel
{
  self.fireworksLabel.hidden = FALSE;
  
  self.fireworksLabelTimer = [AutoTimer autoTimerWithTimeInterval:2.5
                                                           target:self
                                                         selector:@selector(stopAnimatingFireworkLabel)
                                                         userInfo:nil
                                                          repeats:FALSE];
}

- (void) stopAnimatingFireworkLabel
{
  self.fireworksLabel.hidden = TRUE;
  self.fireworksLabelTimer = nil;
 
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager = appDelegate.mediaManager;

  // Put away the red opaque firework view
  
  [mediaManager.redMedia stopAnimator];
  [self.redContainer removeFromSuperview];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  
  NSLog(@"Touches Ended");
  
  if (self.fireworksLabel.hidden == FALSE) {
    // Do not allow until label is hidden
    return;
  }
  
  [self logTouchesFor:event];
  
  CGPoint location = [self firstTouchLocation:event];
  
  // Detemine rough (0.0, 0.0) -> (1.0, 1.0) coordinates
  
  CGRect bounds = self.fieldContainer.bounds;
  
  if (self.fieldSubview == nil) {
    AVAnimatorView *aVAnimatorView = [AVAnimatorView aVAnimatorViewWithFrame:bounds];
    self.fieldSubview = aVAnimatorView;
    [self.fieldContainer addSubview:self.fieldSubview];
  } else {
    [self.fieldSubview attachMedia:nil];
  }
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager = appDelegate.mediaManager;
  
  [self.fieldSubview attachMedia:mediaManager.L112Media];
  
  [mediaManager.L112Media startAnimator];
  
  return;
}

- (void) logTouchesFor:(UIEvent*)event
{
  int count = 1;
  
  for (UITouch* touch in event.allTouches) {
    CGPoint location = [touch locationInView:self.view];
    
    NSLog(@"%d: (%.0f, %.0f)", count, location.x, location.y);
    
//    CGPoint location = [touch locationInView:self.view];
    
    count++;
  }
}

- (CGPoint) firstTouchLocation:(UIEvent*)event
{
  for (UITouch* touch in event.allTouches) {
    CGPoint location = [touch locationInView:self.view];
    return location;
  }
  return CGPointMake(0, 0);
}

@end

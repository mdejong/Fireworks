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
#import "AVMvidFrameDecoder.h"

@interface AnimatingViewController ()

@property (nonatomic, retain) IBOutlet UILabel *fireworksLabel;

@property (nonatomic, retain) AutoTimer *fireworksLabelTimer;

@property (nonatomic, retain) IBOutlet UIView *wheelContainer;

@property (nonatomic, retain) AVAnimatorView *wheelAnimatorView;

@end

@implementation AnimatingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
 
  NSAssert(self.wheelContainer, @"wheelContainer");
  NSAssert(self.fireworksLabel, @"fireworksLabel");
  
  self.fireworksLabel.hidden = TRUE;
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager = appDelegate.mediaManager;
  
  AVAsset2MvidResourceLoader *wheelLoader = mediaManager.wheelLoader;
  NSAssert(wheelLoader, @"wheelLoader");

  AVAnimatorMedia *wheelMedia = [AVAnimatorMedia aVAnimatorMedia];
  
  mediaManager.wheelMedia = wheelMedia;
  
	wheelMedia.resourceLoader = wheelLoader;

  AVMvidFrameDecoder *frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  wheelMedia.frameDecoder = frameDecoder;
  
  [wheelMedia prepareToAnimate];

  //CGRect wheelFrame = self.wheelContainer.frame;
  CGRect wheelBounds = self.wheelContainer.bounds;
  AVAnimatorView *wheelAnimatorView = [AVAnimatorView aVAnimatorViewWithFrame:wheelBounds];
  self.wheelAnimatorView = wheelAnimatorView;
  
  [self.wheelContainer addSubview:wheelAnimatorView];
  
  // Note that attachMedia cannot be invoked here because view is being created now
  
  return;
}

- (void) viewDidAppear:(BOOL)animated
//- (void) viewWillAppear:(BOOL)animated
{
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager = appDelegate.mediaManager;

  AVAnimatorMedia *wheelMedia = mediaManager.wheelMedia;
  AVAnimatorView *wheelAnimatorView = self.wheelAnimatorView;
  
  NSAssert(wheelMedia.resourceLoader, @"wheelMedia.resourceLoader");
  NSAssert(wheelAnimatorView, @"wheelAnimatorView");
  
  [wheelAnimatorView attachMedia:wheelMedia];
  
  wheelMedia.animatorRepeatCount = 0xFFFF;
  
  [wheelMedia startAnimator];
  
  // Kick off fireworks label animation times
  
  self.fireworksLabelTimer = [AutoTimer autoTimerWithTimeInterval:0.5
                                                            target:self
                                                          selector:@selector(startAnimatingFireworkLabel)
                                                          userInfo:nil
                                                           repeats:FALSE];
}

- (void) startAnimatingFireworkLabel
{
  self.fireworksLabel.hidden = FALSE;
  
  self.fireworksLabelTimer = [AutoTimer autoTimerWithTimeInterval:1.5
                                                           target:self
                                                         selector:@selector(stopAnimatingFireworkLabel)
                                                         userInfo:nil
                                                          repeats:FALSE];
}

- (void) stopAnimatingFireworkLabel
{
  self.fireworksLabel.hidden = TRUE;
  self.fireworksLabelTimer = nil;
}

@end

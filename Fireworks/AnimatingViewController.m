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

@property (nonatomic, retain) IBOutlet UIView *redContainer;

@property (nonatomic, retain) AVAnimatorView *redAnimatorView;

@property (nonatomic, retain) IBOutlet UIView *wheelContainer;

@property (nonatomic, retain) AVAnimatorView *wheelAnimatorView;

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

@end

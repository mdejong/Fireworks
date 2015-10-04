//
//  LoadingViewController.m
//  Fireworks
//
//  Created by Mo DeJong on 10/3/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "LoadingViewController.h"

#import "AppDelegate.h"

#import "AutoTimer.h"

#import "AVFileUtil.h"

#import "MediaManager.h"

@interface LoadingViewController ()

@property (nonatomic, retain) IBOutlet UIButton *button;

@property (nonatomic, retain) AutoTimer *startLoadingTimer;

@property (nonatomic, retain) AutoTimer *checkLoadingTimer;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSAssert(self.button, @"button");
  
  [self.button setTitle:@"Loading" forState:UIControlStateDisabled];
  self.button.enabled = FALSE;
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager =appDelegate.mediaManager;
  
  [mediaManager makeLoaders];
  
  self.startLoadingTimer = [AutoTimer autoTimerWithTimeInterval:0.10
                                                         target:mediaManager
                                                       selector:@selector(startAsyncLoading)
                                                       userInfo:nil
                                                        repeats:FALSE];
  
  self.checkLoadingTimer = [AutoTimer autoTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(checkLoadingTimerCallback:)
                                                       userInfo:nil
                                                        repeats:TRUE];
  return;
}

// Invoked once a second until all resources has been loaded in the background

- (void) checkLoadingTimerCallback:(NSTimer*)timer
{
  NSLog(@"checkLoadingTimerCallback");
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  MediaManager *mediaManager =appDelegate.mediaManager;
  
  BOOL allReady = [mediaManager allLoadersReady];
  
  if (allReady) {
    [timer invalidate];
    
    [self.button setTitle:@"Ready" forState:UIControlStateNormal];
    
    self.button.enabled = TRUE;
  }
}

@end

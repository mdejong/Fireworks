//
//  LoadingViewController.m
//  Fireworks
//
//  Created by Mo DeJong on 10/3/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "LoadingViewController.h"

#import "AutoTimer.h"

#import "AVFileUtil.h"

// Specific kind of resource to mvid converter to use

#import "AVAsset2MvidResourceLoader.h"

@interface LoadingViewController ()

@property (nonatomic, retain) AutoTimer *startLoadingTimer;

@property (nonatomic, retain) AutoTimer *checkLoadingTimer;

@property (nonatomic, retain) AVAsset2MvidResourceLoader *wheelLoader;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSAssert(self.button, @"button");
  
  [self setupLoaders];
  
  self.startLoadingTimer = [AutoTimer autoTimerWithTimeInterval:0.10
                                                         target:self
                                                       selector:@selector(startLoadingTimerCallback)
                                                       userInfo:nil
                                                        repeats:FALSE];
  
  self.checkLoadingTimer = [AutoTimer autoTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(checkLoadingTimerCallback:)
                                                       userInfo:nil
                                                        repeats:TRUE];
  return;
}

- (void) setupLoaders
{
  AVAsset2MvidResourceLoader *wheelLoader = [AVAsset2MvidResourceLoader aVAsset2MvidResourceLoader];
  self.wheelLoader = wheelLoader;
}

- (void) startLoadingTimerCallback
{
  // Kick off async loading that will read .h264 and write .mvid to disk in tmp dir

  AVAsset2MvidResourceLoader *wheelLoader = self.wheelLoader;
  
  NSString *resFilename = @"Wheel.m4v";
  NSString *outFilename = @"Wheel.mvid";
  
  wheelLoader.movieFilename = resFilename;
  
  NSString *outPath = [AVFileUtil getTmpDirPath:outFilename];
  wheelLoader.outPath = outPath;

  // Start async loading, this will kick off mvid conversion without
  // blocking the main thread since decoding is done in the background
  
  [wheelLoader load];
}

// Invoked once a second until all resources has been loaded in the background

- (void) checkLoadingTimerCallback:(NSTimer*)timer
{
  NSLog(@"checkLoadingTimerCallback");
  
  BOOL allReady = TRUE;
  
  for (AVResourceLoader *loader in @[self.wheelLoader]) {
    if (loader.isReady == FALSE) {
      allReady = FALSE;
    }
  }
  
  if (allReady) {
    [timer invalidate];
    
    [self.button setTitle:@"Ready" forState:UIControlStateNormal];
  }
}

@end

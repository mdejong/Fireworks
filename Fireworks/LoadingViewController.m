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

@property (nonatomic, retain) AVAsset2MvidResourceLoader *redLoader;

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
  NSString *resFilename;
  NSString *outFilename;

  resFilename = @"Wheel.m4v";
  outFilename = @"Wheel.mvid";
  
  self.wheelLoader = [self loaderFor24BPPH264:resFilename outFilename:outFilename];
  
  resFilename = @"Red.m4v";
  outFilename = @"Red.mvid";
  
  self.redLoader = [self loaderFor24BPPH264:resFilename outFilename:outFilename];
}

- (AVAsset2MvidResourceLoader*) loaderFor24BPPH264:(NSString*)resFilename
                                       outFilename:(NSString*)outFilename
{
  AVAsset2MvidResourceLoader *loader = [AVAsset2MvidResourceLoader aVAsset2MvidResourceLoader];
  
  loader.movieFilename = resFilename;
  
  // Generate fully qualified path in tmp dir
  
  NSString *outPath = [AVFileUtil getTmpDirPath:outFilename];
  loader.outPath = outPath;
  
  return loader;
}

- (void) startLoadingTimerCallback
{
  // Kick off async loading that will read .h264 and write .mvid to disk in tmp dir

  for (AVResourceLoader *loader in @[self.wheelLoader, self.redLoader]) {
    [loader load];
  }
}

// Invoked once a second until all resources has been loaded in the background

- (void) checkLoadingTimerCallback:(NSTimer*)timer
{
  NSLog(@"checkLoadingTimerCallback");
  
  BOOL allReady = TRUE;
  
  for (AVResourceLoader *loader in @[self.wheelLoader, self.redLoader]) {
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

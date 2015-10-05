//
//  MediaManager.m
//  Fireworks
//
//  Created by Mo DeJong on 10/3/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "MediaManager.h"

#import "AutoTimer.h"

#import "AVFileUtil.h"

// Specific kind of resource to mvid converter to use

#import "AVAsset2MvidResourceLoader.h"

#import "AVAssetJoinAlphaResourceLoader.h"

@interface MediaManager ()

@end

@implementation MediaManager

+ (MediaManager*) mediaManager
{
  return [[MediaManager alloc] init];
}

- (void) makeH264Loaders
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

- (void) makeH264RGBAlphaLoaders
{
  NSString *rgbResourceName;
  NSString *alphaResourceName;
  NSString *rgbTmpMvidFilename;
  NSString *rgbTmpMvidPath;
  
  rgbResourceName = @"11_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"11_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"11_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  AVAssetJoinAlphaResourceLoader *resLoader;
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  
  self.L112Loader = resLoader;
}

- (void) makeLoaders
{
  [self makeH264Loaders];
  [self makeH264RGBAlphaLoaders];
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

// Return array of all active loader objects

- (NSArray*) getLoaders
{
  return @[self.wheelLoader, self.redLoader, self.L112Loader];
}

- (void) startAsyncLoading
{
  // Kick off async loading that will read .h264 and write .mvid to disk in tmp dir

  for (AVResourceLoader *loader in [self getLoaders]) {
    [loader load];
  }
}

// Check to see if all loaders are ready now

- (BOOL) allLoadersReady
{
  BOOL allReady = TRUE;
  
  for (AVResourceLoader *loader in [self getLoaders]) {
    if (loader.isReady == FALSE) {
      allReady = FALSE;
    }
  }
  
  return allReady;
}

@end

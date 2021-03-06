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

#import "AVMvidFrameDecoder.h"
#import "AVAnimatorMedia.h"

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
  
  AVAsset2MvidResourceLoader *resLoader;
  AVAnimatorMedia *media;
  
  // Create media object for "Wheel" animation
  
  resFilename = @"Wheel.m4v";
  outFilename = @"Wheel.mvid";
  
  resLoader = [self loaderFor24BPPH264:resFilename outFilename:outFilename];
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.wheelLoader = resLoader;
  self.wheelMedia = media;
  
  // Create media object for "Red" animation
  
  resFilename = @"Red.m4v";
  outFilename = @"Red.mvid";
  
  resLoader = [self loaderFor24BPPH264:resFilename outFilename:outFilename];
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.redLoader = resLoader;
  self.redMedia = media;
}

- (void) makeH264RGBAlphaLoaders
{
  NSString *rgbResourceName;
  NSString *alphaResourceName;
  NSString *rgbTmpMvidFilename;
  NSString *rgbTmpMvidPath;
  
  AVAssetJoinAlphaResourceLoader *resLoader;
  AVAnimatorMedia *media;
  
  // L12 : single firework
  
  rgbResourceName = @"1_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"1_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"1_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L12Loader = resLoader;
  self.L12Media = media;
  
  // L22 :
  
  rgbResourceName = @"2_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"2_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"2_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L22Loader = resLoader;
  self.L22Media = media;

  // L32 :
  
  rgbResourceName = @"3_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"3_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"3_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L32Loader = resLoader;
  self.L32Media = media;
  
  // L42 : Two explosions, roughly at same time, 2 fingers down on tap?
  
  rgbResourceName = @"4_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"4_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"4_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L42Loader = resLoader;
  self.L42Media = media;

  // L52 : Two explosions, roughly at same time, 2 fingers down on tap?
  
  rgbResourceName = @"5_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"5_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"5_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L52Loader = resLoader;
  self.L52Media = media;

  // L62 :
  
  rgbResourceName = @"6_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"6_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"6_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L62Loader = resLoader;
  self.L62Media = media;
  
  // L92 : Two explosions, one after another (perhaps double tap)
  
  rgbResourceName = @"9_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"9_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"9_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L92Loader = resLoader;
  self.L92Media = media;
  
  // L112 : large double explosion
  
  rgbResourceName = @"11_2_rgb_CRF_30_24BPP.m4v";
  alphaResourceName = @"11_2_alpha_CRF_30_24BPP.m4v";
  rgbTmpMvidFilename = @"11_2_CRF_30_24BPP.mvid";
  
  rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
  
  resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
  
  resLoader.movieRGBFilename = rgbResourceName;
  resLoader.movieAlphaFilename = alphaResourceName;
  resLoader.outPath = rgbTmpMvidPath;
  resLoader.alwaysGenerateAdler = TRUE;
  resLoader.serialLoading = TRUE;
  
  media = [AVAnimatorMedia aVAnimatorMedia];
  media.resourceLoader = resLoader;
  media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
  
  NSAssert(resLoader, @"resLoader");
  NSAssert(media, @"media");
  self.L112Loader = resLoader;
  self.L112Media = media;

  return;
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

// Return array of all active media objects

- (NSArray*) getAllMedia
{
  NSMutableArray *mArr = [NSMutableArray array];
  
  [mArr addObject:self.wheelMedia];
  [mArr addObject:self.redMedia];
  [mArr addObjectsFromArray:[self getFireworkMedia]];
  
  return mArr;
}

// Return array of all alpha channel fireworks media

- (NSArray*) getFireworkMedia
{
  return @[self.L12Media, self.L22Media, self.L32Media, self.L42Media, self.L52Media, self.L62Media, self.L92Media, self.L112Media];
}

- (void) startAsyncLoading
{
  // Kick off async loading that will read .h264 and write .mvid to disk in tmp dir.
  // Note that this method can kick off multiple pending timer events so it is useful
  // if this method is not invoked in the initial viewDidLoad or init logic for the
  // app startup.
  
  for (AVAnimatorMedia *media in [self getAllMedia]) {
    [media prepareToAnimate];
  }
}

// Check to see if all loaders are ready now

- (BOOL) allLoadersReady
{
  BOOL allReady = TRUE;
  
  for (AVAnimatorMedia *media in [self getAllMedia]) {
    AVResourceLoader *loader = media.resourceLoader;
    if (loader.isReady == FALSE) {
      allReady = FALSE;
    }
  }
  
  return allReady;
}

@end

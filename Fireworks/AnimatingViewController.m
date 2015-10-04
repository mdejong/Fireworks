//
//  AnimatingViewController.m
//  Fireworks
//
//  Created by Mo DeJong on 10/3/15.
//  Copyright © 2015 helpurock. All rights reserved.
//

#import "AnimatingViewController.h"

@interface AnimatingViewController ()

@property (nonatomic, retain) IBOutlet UIView *wheelContainer;

@end

@implementation AnimatingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
 
  NSAssert(self.wheelContainer, @"wheelContainer");
  
  return;
}

@end

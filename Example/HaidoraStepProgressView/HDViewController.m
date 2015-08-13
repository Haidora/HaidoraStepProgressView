//
//  HDViewController.m
//  HaidoraStepProgressView
//
//  Created by mrdaios on 08/12/2015.
//  Copyright (c) 2015 mrdaios. All rights reserved.
//

#import "HDViewController.h"
#import <HaidoraStepProgressView/HDStepProgressView.h>

@interface HDViewController ()

@property (weak, nonatomic) IBOutlet HDStepProgressView *stepProgressView;

@end

@implementation HDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _stepProgressView.trackColor = [UIColor colorWithRed:0.282 green:0.553 blue:0.984 alpha:1];
    _stepProgressView.progressColor = [UIColor whiteColor];
    _stepProgressView.textColor = [UIColor colorWithRed:0.282 green:0.553 blue:0.984 alpha:1];
    _stepProgressView.textFont = [UIFont boldSystemFontOfSize:16];
    _stepProgressView.currentIndex = 4;
    _stepProgressView.items = @[ @"A", @"B", @"C",@"D" ];
}

@end
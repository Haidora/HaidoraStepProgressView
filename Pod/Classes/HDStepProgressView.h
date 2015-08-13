//
//  HDStepProgressView.h
//  Pods
//
//  Created by Dailingchi on 15/8/12.
//
//

#import <UIKit/UIKit.h>

@interface HDStepProgressView : UIView

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
/**
 *  NSStrings.count>1
 */
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;

@end

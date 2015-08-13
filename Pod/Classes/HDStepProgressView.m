//
//  HDStepProgressView.m
//  Pods
//
//  Created by Dailingchi on 15/8/12.
//
//

#import "HDStepProgressView.h"
#import <math.h>

@interface HDStepProgressView ()

@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, strong) CALayer *progressLayer;

@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic, assign) CGFloat boardMargin;
/**
 *  Default is height/3.
 */
@property (nonatomic, assign) CGFloat separateLineHeight;

@end

@implementation HDStepProgressView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _textFont = [UIFont systemFontOfSize:16];
    _textColor = [UIColor whiteColor];
    _separateLineHeight = CGRectGetHeight(self.bounds) / 3;
    _currentIndex = 0;
    _boardMargin = 3;
    _trackColor = [UIColor colorWithRed:0.8549 green:0.8588 blue:0.8627 alpha:0.5];
    _progressColor = [UIColor colorWithRed:0.6078 green:0.8314 blue:0.2353 alpha:1.0];
    //背景
    _trackLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_trackLayer];
    //进度
    _progressLayer = [CALayer layer];
    _progressLayer.backgroundColor = _progressColor.CGColor;
    [_trackLayer addSublayer:_progressLayer];

    self.userInteractionEnabled = YES;
    [self updateItems];

    self.backgroundColor = _trackColor;
}

- (void)updateItems
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.labels removeAllObjects];
    NSInteger count = _items.count;
    for (int i = 0; i < count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        [self addSubview:label];
        [self.labels addObject:label];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_items.count > 0)
    {
        // set progress
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat radius = (CGRectGetHeight(self.bounds) - _boardMargin * 2) / 2;
        CGFloat count = _items.count;
        CGFloat seprateWidth = (width - radius * 2 * count - _boardMargin * 2) / (count - 1);

        CGRect frame = self.bounds;
        frame.size.width = _boardMargin + radius * 2 + (seprateWidth + radius * 2) * _currentIndex;
        _progressLayer.frame = frame;

        // layout sub labels
        __block CGFloat posX = _boardMargin + radius;
        CGFloat posY = _boardMargin + radius;
        [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
          label.font = _textFont;
          label.textColor = _textColor;
          label.text = self.items[idx];
          [label sizeToFit];
          label.center = CGPointMake(posX, posY);
          posX += seprateWidth + radius * 2;
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_items.count > 0)
    {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [self gernatePathWith:_boardMargin].CGPath;
        _trackLayer.mask = layer;
        //设置背景形状
        CAShapeLayer *backLayer = [CAShapeLayer layer];
        backLayer.path = [self gernatePathWith:0].CGPath;
        self.layer.mask = backLayer;
    }
}

- (UIBezierPath *)gernatePathWith:(CGFloat)margin
{
    CGFloat count = _items.count;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    CGFloat width = CGRectGetWidth(self.bounds) - margin * 2;
    CGFloat height = CGRectGetHeight(self.bounds) - margin * 2;
    CGFloat radius = height / 2;
    CGFloat separateLineHeightCopy = _separateLineHeight - margin;
    //弧度
    CGFloat angle = asin((separateLineHeightCopy / 2) / radius);
    CGFloat seprateWidth = (width - radius * 2 * count) / (count - 1);
    CGFloat length =
        sqrt(radius * radius - (separateLineHeightCopy / 2) * (separateLineHeightCopy / 2));
    CGFloat radiusMargin = radius - length;

    CGFloat posX = radius + margin;
    CGFloat posY = radius + margin;
    // start point
    [maskPath addArcWithCenter:CGPointMake(posX, posY)
                        radius:radius
                    startAngle:M_PI
                      endAngle:(2 * M_PI - angle)
                     clockwise:YES];
    // up
    for (NSInteger index = 1; index < count; index++)
    {
        [maskPath addLineToPoint:CGPointMake((radius * 2 + seprateWidth + radiusMargin * 2) * index,
                                             maskPath.currentPoint.y)];
        CGFloat endAngle;
        if (index < (count - 1))
        {
            endAngle = (2 * M_PI - angle);
        }
        else
        {
            endAngle = (1 * M_PI - angle);
        }
        [maskPath
            addArcWithCenter:CGPointMake((radius * 2 + seprateWidth) * index + radius + margin,
                                         radius + margin)
                      radius:radius
                  startAngle:(1 * M_PI + angle)
                    endAngle:endAngle
                   clockwise:YES];
    }
    // down
    for (NSInteger index = 1; index < count; index++)
    {
        [maskPath
            addLineToPoint:CGPointMake(width -
                                           (radius * 2 + seprateWidth + radiusMargin * 2) * index +
                                           margin,
                                       maskPath.currentPoint.y)];
        CGFloat endAngle;
        if (index < (count - 1))
        {
            endAngle = (1 * M_PI - angle);
        }
        else
        {
            endAngle = M_PI;
        }
        [maskPath
            addArcWithCenter:CGPointMake(width - ((radius * 2 + seprateWidth) * index + radius) +
                                             margin,
                                         radius + margin)
                      radius:radius
                  startAngle:angle
                    endAngle:endAngle
                   clockwise:YES];
    }
    return maskPath;
}

#pragma mark
#pragma mark Getter/Setter

- (NSMutableArray *)labels
{
    if (nil == _labels)
    {
        _labels = [[NSMutableArray alloc] init];
    }
    return _labels;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [self updateItems];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    self.backgroundColor = trackColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _progressLayer.backgroundColor = _progressColor.CGColor;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = MAX(0, currentIndex);
    [self setNeedsLayout];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsLayout];
}
@end

//
//  DHTriangleView.m
//  DHRunning
//
//  Created by skcu1805 on 2014/9/4.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHTriangleView.h"

@implementation DHTriangleView

- (void) drawRect:(CGRect)rect {
    // Build a triangular path
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){40, 40}];
    [path addLineToPoint:(CGPoint){100, 0}];
    [path addLineToPoint:(CGPoint){0, 0}];
    
    // Create a CAShapeLayer with this triangular path
    // Same size as the original imageView
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = self.bounds;
    mask.path = path.CGPath;
    
    // Mask the imageView's layer with this shape
    self.layer.mask = mask;
}

@end

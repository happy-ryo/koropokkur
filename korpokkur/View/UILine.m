//
// Created by happy_ryo on 2012/10/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UILine.h"


@implementation UILine {

}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    UIBezierPath *path = [UIBezierPath bezierPath];

    [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] set ];
    [path setLineWidth:0.5f];
    CGFloat dashPattern[2] = { 1.0f, 2.0f };
    [path setLineDash:dashPattern  count:2 phase:0];
    [path moveToPoint:CGPointMake(0, 10)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 10)];
    [path stroke];

//    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
//    CGContextSetLineWidth(context, 2.0);
//    CGContextMoveToPoint(context, 0, 0);  // 始点
//    CGContextAddLineToPoint(context, 0, 320);  // 終点
//    CGContextStrokePath(context);  // 描画！
}


@end
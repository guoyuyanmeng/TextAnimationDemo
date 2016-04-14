//
//  CoreLabel.m
//  TextAnimation
//
//  Created by kang on 16/4/5.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "CoreLabel.h"
#import <CoreText/CoreText.h>

@implementation CoreLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)  drawRect:(CGRect)rect {
//    [super drawRect:rect];
    
    
    // Initialize a string.
    CFStringRef textString = CFSTR("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
    
    // Create a mutable attributed string with a max length of 0.
    // The max length is a hint as to how much internal storage to reserve.
    // 0 means no hint.
    CFMutableAttributedStringRef attrString =
    CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    // Copy the textString into the newly created attrString
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0),
                                     textString);
    
    
    //设置字体间隔
    long number = 3;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 4), kCTKernAttributeName, num);
    
    /*
     * 设置空心字体颜色前必须先将字体设置成空心
     */
    
    //设置空心字
    long number2 = 3;
    CFNumberRef num2 = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number2);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 14), kCTStrokeWidthAttributeName, num2);
    
    
    //根据RGB值创建CGColorRef颜色对象
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { 1.0, 0.0, 0.0, 1.0 };
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    
    //设置字体颜色
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 5),kCTForegroundColorAttributeName, red);
    
    //设置字体
    CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:9].fontName, 12, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(14, 16),kCTFontAttributeName, font);
    
    //下划线颜色
    //根据RGB值创建CGColorRef颜色对象
    CGColorSpaceRef underLineColor = CGColorSpaceCreateDeviceRGB();
    CGFloat components2[] = { 0.0, 0.0, 1.0, 1.0 };
    CGColorRef blue = CGColorCreate(underLineColor, components2);
    CGColorSpaceRelease(rgbColorSpace);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(14, 16),kCTUnderlineColorAttributeName, blue);
    
    //下划线
    long number3 = 2; //1单行，2加粗，9双行  CTUnderlineStyle
    CFNumberRef num3 = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number3);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(14, 16),kCTUnderlineStyleAttributeName, num3);
    //(__bridge CFTypeRef)([NSNumber numberWithInt:kCTUnderlineStyleDouble])
    
    
    
    // Initialize a graphics context in iOS.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    /*
     * CGContextTranslateCTM(CGContextRef __nullable c,CGFloat tx, CGFloat ty)
     * param c  为context，表示一个上下文
     * param tx 为X坐标，
     * param ty 为Y坐标，
     *
     * 这个函数表示当前上下文所在控件的坐标轴沿着向量{(0,0),(tx,ty)}方向移动
     */
    //坐标轴向正下方移动，使X轴移动到当前控件的底部
    CGContextTranslateCTM(context, 0, self.frame.size.height);
    
    /*
     * CGContextScaleCTM(CGContextRef __nullable c,
     * CGFloat sx, CGFloat sy)
     * param c  为context，表示一个上下文
     * param sx 为x坐标的缩放倍数
     * param sy 为y坐标的缩放倍数
     *
     */
    //沿X轴旋转
    //因为上面的操作使X轴移动到了控件底部，所以Y轴的缩放倍数必须设置成负数才能在控件的可见区域内
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Initializing a graphic context in OS X is different:
    // CGContextRef context =
    //     (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    
    // Set the text matrix.
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。
    //图形状态中不考虑当前路径，所以不保存
    
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);
    
    // Create a path which bounds the area where you will be drawing text.
    // The path need not be rectangular.
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 60 , 10);
    CGPathAddLineToPoint(path, NULL, 60, 210);
    
    // In this simple example, initialize a rectangular path.
    CGPathAddEllipseInRect(path, NULL, CGRectMake(10.0, 10.0, 100, 100));
    CGPathAddRect(path, NULL, CGRectMake(10, 110, 100, 100) );
    
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // Create a frame.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0), path, NULL);
    
    // Draw the specified frame in the given context.
    CTFrameDraw(frame, context);
    
    CGColorRelease(red);
    CGColorRelease(blue);
    // Release the objects we used.
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);

}



- (void) attrName {

//    CFStringRef kCTCharacterShapeAttributeName;
//    //字体形状属性  必须是CFNumberRef对象默认为0，非0则对应相应的字符形状定义，如1表示传统字符形状
//    
//    const CFStringRef kCTFontAttributeName;
//    //字体属性   必须是CTFont对象
//    
//    const CFStringRef kCTKernAttributeName;
//    //字符间隔属性 必须是CFNumberRef对象
//    
//    const CFStringRef kCTLigatureAttributeName;
//    //设置是否使用连字属性，设置为0，表示不使用连字属性。标准的英文连字有FI,FL.默认值为1，既是使用标准连字。也就是当搜索到f时候，会把fl当成一个文字。必须是CFNumberRef 默认为1,可取0,1,2
//    
//    const CFStringRef kCTForegroundColorAttributeName;
//    //字体颜色属性  必须是CGColor对象，默认为black
//    
//    const CFStringRef kCTForegroundColorFromContextAttributeName;
//    //上下文的字体颜色属性 必须为CFBooleanRef 默认为False,
//    
//    const CFStringRef kCTParagraphStyleAttributeName;
//    //段落样式属性 必须是CTParagraphStyle对象 默认为NIL
//    
//    const CFStringRef kCTStrokeWidthAttributeName;
//    //笔画线条宽度 必须是CFNumberRef对象，默为0.0f，标准为3.0f
//    
//    const CFStringRef kCTStrokeColorAttributeName;
//    //笔画的颜色属性 必须是CGColorRef 对象，默认为前景色
//    
//    const CFStringRef kCTSuperscriptAttributeName;
//    //设置字体的上下标属性 必须是CFNumberRef对象 默认为0,可为-1为下标,1为上标，需要字体支持才行。如排列组合的样式Cn1
//    
//    const CFStringRef kCTUnderlineColorAttributeName;
//    //字体下划线颜色属性 必须是CGColorRef对象，默认为前景色
//    
//    const CFStringRef kCTUnderlineStyleAttributeName;
//    //字体下划线样式属性 必须是CFNumberRef对象,默为kCTUnderlineStyleNone 可以通过CTUnderlineStypleModifiers 进行修改下划线风格
//    
//    const CFStringRef kCTVerticalFormsAttributeName;
//    //文字的字形方向属性 必须是CFBooleanRef 默认为false，false表示水平方向，true表示竖直方向
//    
//    const CFStringRef kCTGlyphInfoAttributeName;
//    //字体信息属性 必须是CTGlyphInfo对象
//    
//    const CFStringRef kCTRunDelegateAttributeName;
//    //CTRun 委托属性 必须是CTRunDelegate对象
}


@end

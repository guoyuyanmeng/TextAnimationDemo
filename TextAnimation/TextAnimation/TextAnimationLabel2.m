//
//  TextAnimationLabel2.m
//  TextAnimation
//
//  Created by kang on 16/4/12.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "TextAnimationLabel2.h"
//#import "TextAnimation.h"
#import <CoreText/CoreText.h>

typedef  void(^CompletionAnimotionBlock)(bool finshed);
typedef  void(^textAnimationClosure)(void);
static NSString *textAnimationGroupKey = @"textAniamtionGroupKey";

@interface TextAnimationLabel2 () <NSLayoutManagerDelegate>
{
    NSMutableArray<CATextLayer *> *_oldCharacterTextLayers;
    NSMutableArray<CATextLayer *> *_newCharacterTextLayers;
    
    //    NSTextStorage *textStorage;
    //    NSLayoutManager *textLayoutManager;
    //    NSTextContainer *textContainer;
    
    BOOL animationIn;
    BOOL animationOut;
    
}

//@property (nonatomic, strong) NSMutableArray<CATextLayer*>  *oldCharacterTextLayers;
//@property (nonatomic, strong) NSMutableArray<CATextLayer *> *newCharacterTextLayers;

@property (nonatomic, strong)CompletionAnimotionBlock completionBlock;

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *textLayoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@end

@implementation TextAnimationLabel2

- (instancetype) initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self setPropert];
        [self initlized];
    }
    
    return self;
}


- (instancetype) init {
    
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void) setPropert {
    
    self.font = [UIFont systemFontOfSize:38.0];//UIFont(name: "Apple SD Gothic Neo", size: 38)
    self.numberOfLines = 5 ;
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
//
//    NSLog(@"self.attibutestring:%@",self.attributedText);
}

- (void) initlized {
    
    
    
    _oldCharacterTextLayers = [[NSMutableArray alloc]init];
    _newCharacterTextLayers = [[NSMutableArray alloc]init];
    
    
    _textStorage = nil;
    _textLayoutManager = nil;
    _textContainer  = nil;
    
    _textStorage = [[NSTextStorage alloc]initWithString:@""];
    _textLayoutManager = [[NSLayoutManager alloc]init];
    _textContainer = [[NSTextContainer alloc]init];
    
    [_textStorage addLayoutManager:_textLayoutManager];
    [_textLayoutManager addTextContainer:_textContainer];
    _textLayoutManager.delegate = self;
    
    _textContainer.size = self.bounds.size;
    _textContainer.maximumNumberOfLines = [self numberOfLines];
    _textContainer.lineBreakMode = [self lineBreakMode];

    

}

#pragma mark -setter , getter
- (void) setText:(NSString *)text {
//    [super setText:text];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange textRange = NSMakeRange(0, text.length);
    //设置段落格式
    NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphyStyle.alignment = NSTextAlignmentCenter;
    //设置文字颜色
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0] range:textRange];
    //设置文字字体
    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38.0] range:textRange];
    //设置段落格式
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphyStyle range:textRange];
    
    [self setOldCharacterTextLayers];
    [_textStorage setAttributedString:attributedText];
    [self setAttributedText:attributedText];
}

//
- (void) setOldCharacterTextLayers {
    
//    _oldCharacterTextLayers = _newCharacterTextLayers;
    for (CATextLayer *textlayer in _newCharacterTextLayers) {
//        textlayer.opacity = 1.0;
        [_oldCharacterTextLayers addObject:textlayer];
    }
    
}


- (void) setAttributedText:(NSAttributedString *)attributedText {
    
//    [super setAttributedText:attributedText];
    
    if (_oldCharacterTextLayers.count > 0) {
        [self removeOlderTextAnimation:^(){}];
        NSLog(@"oldtext animation");
    }

    
    if (_newCharacterTextLayers.count > 0) {
        [self addNewCharacterTextLayers:nil];
        NSLog(@"newtext animation");
    }
    
    
}


- (void) cleanOutOlderTextlayers {
    
    for (CATextLayer *textLayer in  _oldCharacterTextLayers) {
        [textLayer removeFromSuperlayer];
    }
    [_oldCharacterTextLayers removeAllObjects];
}

#pragma mark NSLayoutManagerDelegate
- (void)layoutManager:(NSLayoutManager *)layoutManager
didCompleteLayoutForTextContainer:(nullable NSTextContainer *)textContainer
                atEnd:(BOOL)layoutFinishedFlag {
    
    [self setNewCharacterTextLayers];
    
//    NSLog(@"1111111111111111111");
    NSLog(@"textStorage.string:%@",_textStorage.string);
//    NSLog(@"textStorage:%@",_textStorage);
    
}

#pragma mark - animotionDelegate
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    NSLog(@"animotion stoped");
    if (_oldCharacterTextLayers.count > 0) {
        [self cleanOutOlderTextlayers];
    }
}

#pragma mark - private Method
-(void) setNewCharacterTextLayers {
    
    NSLog(@"setNewCharacterTextLayers");
    [_newCharacterTextLayers removeAllObjects];
    NSString *attributeText = _textStorage.string;
    NSRange wordRange = NSMakeRange(0, attributeText.length);
    
    NSMutableAttributedString *attributedString = _textStorage;
    CGRect layoutRect = [_textLayoutManager usedRectForTextContainer:_textContainer];//计算text整体的区域矩形
    
    NSInteger index = wordRange.location;
    NSInteger totalLength = NSMaxRange(wordRange);
    
    while (index < totalLength) {
        NSRange glyphRange = NSMakeRange(index, 1);
        
        NSRange characterRange = [_textLayoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange: nil];
        
        NSTextContainer *textContainer = [_textLayoutManager textContainerForGlyphAtIndex:index effectiveRange: nil];
        CGRect glyphRect = [_textLayoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
        
        NSRange kerningRange = [_textLayoutManager rangeOfNominallySpacedGlyphsContainingIndex:index];//字距
        
        if (kerningRange.location == index && kerningRange.length >1) {
            if (_newCharacterTextLayers.count > 0) {
                //如果前一个textlayer的frame.size.width不变大的话，当前的textLayer会遮挡住字体的一部分，比如“You”的Y右上角会被切掉一部分
                CATextLayer *previousLayer = [_newCharacterTextLayers lastObject];
                CGRect frame = previousLayer.frame;
                frame.size.width += CGRectGetMaxX(glyphRect) - CGRectGetMaxX(frame);
                previousLayer.frame = frame;
            }
        }
        
        //上下居中
        glyphRect.origin.y += (self.bounds.size.height/2)-(layoutRect.size.height/2);
        
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = glyphRect;
        textLayer.opacity = 0.0;
        [textLayer setString:[attributedString attributedSubstringFromRange:characterRange]];
        
        [self.layer addSublayer:textLayer];
        [_newCharacterTextLayers addObject:textLayer];
        index += characterRange.length;
        
    }//while cyc
}

- (void) removeOlderTextAnimation: (textAnimationClosure)animationClosure{
    
    NSLog(@"startAnimation");
    
    NSInteger index = 0;
    
    for (CALayer *textlayer in _oldCharacterTextLayers) {
        
        NSTimeInterval duration = arc4random()%100/125.0 + 0.35;
        NSTimeInterval delay = arc4random_uniform(100)/500.0;
        NSLog(@"duration:%f  delay:%f",duration,delay);
        [self textAnimationActionWithLayer:textlayer duration:duration delay:delay isRemove:YES];
        ++index;
        
    }//for cycle
}

-(void) addNewCharacterTextLayers:(textAnimationClosure)animationClosure {
    
//    NSInteger count;
    for (CALayer *textLayer in _newCharacterTextLayers)
    {
//        NSLog(@"%ld",(long)count++);
        NSTimeInterval duration = arc4random()%200/100.0+0.25;
        NSTimeInterval delay = 0.5;
        
        NSLog(@"duration:%f  delay:%f",duration,delay);
        [self textAnimationActionWithLayer:textLayer duration:duration delay:delay isRemove:NO];
    }
}

- (void) textAnimationActionWithLayer:(CALayer*) layer
                             duration:(NSTimeInterval) duration
                                delay:(NSTimeInterval) delay
                             isRemove:(BOOL)isRemove
{

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_SEC), dispatch_get_main_queue(),^(){
        
        NSMutableArray<CABasicAnimation *> *animations = [[NSMutableArray alloc]init];
        
        CALayer *oldLayer = [self copyLayerProperty:layer];
        CALayer *newLayer = [self createLayerProperty:layer isRemove:isRemove];
        
        if ( !__CGPointEqualToPoint(oldLayer.position, newLayer.position)) {
//            NSLog(@"position");
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
            basicAnimation.fromValue =  [NSValue valueWithCGPoint:layer.position];
            basicAnimation.toValue =  [NSValue valueWithCGPoint:newLayer.position];
            basicAnimation.fillMode = kCAFillModeForwards ;//保持动画玩后的状态
            basicAnimation.removedOnCompletion = NO;
            [animations addObject:basicAnimation];
            
        }
        
        if (!CATransform3DEqualToTransform(oldLayer.transform, newLayer.transform)) {
//            NSLog(@"transform");
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            basicAnimation.fromValue =  [NSValue valueWithCATransform3D:layer.transform];
            basicAnimation.toValue =  [NSValue valueWithCATransform3D:newLayer.transform];
            basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
            basicAnimation.removedOnCompletion = NO;
            [animations addObject:basicAnimation];
        }
        
        if (!CGRectEqualToRect(oldLayer.frame, newLayer.frame)) {
//            NSLog(@"transform");
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
            basicAnimation.fromValue =  [NSValue valueWithCGRect:layer.frame];
            basicAnimation.toValue =  [NSValue valueWithCGRect:newLayer.frame];
            basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
            basicAnimation.removedOnCompletion = NO;
            [animations addObject:basicAnimation];
        }
        
        if (!CGRectEqualToRect(oldLayer.bounds, newLayer.bounds)) {
//            NSLog(@"transform");
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
            basicAnimation.fromValue =  [NSValue valueWithCGRect:layer.frame];
            basicAnimation.toValue =  [NSValue valueWithCGRect:newLayer.frame];
            basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
            basicAnimation.removedOnCompletion = NO;
            [animations addObject:basicAnimation];
        }

        if (oldLayer.opacity != newLayer.opacity)
        {
//            NSLog(@"opacity");
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            basicAnimation.fromValue = [NSNumber numberWithFloat:layer.opacity];
            basicAnimation.toValue = [NSNumber numberWithFloat:newLayer.opacity];
            basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
            basicAnimation.removedOnCompletion = NO;
            [animations addObject:basicAnimation];
        }
        
//        if (animations.count > 0) {
//            animationGroup = [CAAnimationGroup animation];
//            animationGroup.animations = animations;
//        }
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        
        if (animations.count > 0 && animationGroup) {
            
            animationGroup.animations = animations;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animationGroup.beginTime = CACurrentMediaTime();
            animationGroup.duration = duration;
            animationGroup.delegate = self;
            animationGroup.fillMode = kCAFillModeForwards ;//保持动画玩后的状态
            animationGroup.removedOnCompletion = NO;
            [layer addAnimation:animationGroup forKey:textAnimationGroupKey];
        }
    });

}


- (CALayer *)copyLayerProperty:(CALayer *)layer {
    
    CALayer *layerCopy = [CALayer layer];
    layerCopy.opacity = layer.opacity;
    layerCopy.bounds = layer.bounds;
    layerCopy.frame = layer.frame;
    layerCopy.transform = layer.transform;
    layerCopy.position = layer.position;
    return layerCopy;
}

- (CALayer *) createLayerProperty:(CALayer *)layer  isRemove:(BOOL)isRemove {
    
    CALayer *layerCopy = [CALayer layer];
    layerCopy.bounds = layer.bounds;
    layerCopy.frame = layer.frame;
    layerCopy.transform = layer.transform;
    layerCopy.position = layer.position;
    
    
    
    if (isRemove) {
        
        CGFloat distance = arc4random()%50+25;
        CGFloat angle = arc4random()%3141/1000.0/M_PI_2-M_PI_4;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        transform = CATransform3DRotate(transform, angle, 0, 0, 1);
        
        layerCopy.transform = transform;
        layerCopy.opacity = 0.0;
    }else {
        layerCopy.opacity = 1.0;
    }
    
    return layerCopy;
}
@end

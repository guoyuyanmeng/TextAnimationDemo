//
//  CalyerAnimotion.m
//  TextAnimation
//
//  Created by kang on 16/4/13.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "CalyerAnimotion.h"


static NSString *textAnimationGroupKey = @"textAniamtionGroupKey";
@interface CalyerAnimotion ()
{
    
    CALayer *_textLayer;
    
}

@property (nonatomic, strong)CompletionClosure completionBlock;
@property (nonatomic, strong)CALayer *textLayer;
@end

//static CompletionClosure completionBlock;
@implementation CalyerAnimotion

//删除文字动画
+ (void) removeAnimotionWithLayer:(CALayer*) layer
                             duration:(NSTimeInterval) duration
                                delay:(NSTimeInterval) delay
                      effectAnimation:(effectAnimatableLayerColsure) effectAnimation
                      finishedClosure:(CompletionClosure)completion {
    
    
    CalyerAnimotion *animationObjc = [[CalyerAnimotion alloc]init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_SEC), dispatch_get_main_queue(),^(){
        
        
        CALayer *olderLayer = [animationObjc animatableLayerCopy:layer];
        CALayer *newLayer  = [animationObjc animatableLayerCopy:layer];
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationObjc.completionBlock = completion;
        
        if (effectAnimation) {
            //改变Layer的properties，同时关闭implicit animation
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            newLayer = effectAnimation(newLayer);
            [CATransaction commit];
        }
        
        animationGroup = [animationObjc groupAnimationWithOldLayer:olderLayer  newLayer:newLayer];
        
        if (animationGroup) {
            animationObjc.textLayer = layer ;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animationGroup.beginTime = CACurrentMediaTime();
            animationGroup.duration = duration;
            animationGroup.delegate = animationObjc;
            [layer addAnimation:animationGroup forKey:textAnimationGroupKey];
            
        }else {
            if (completion) {
                completion(YES);
            }
            
        }
    });
    
}

//添加文字动画
+ (void) addAnimotionWithLayer:(CALayer*) layer
                     duration:(NSTimeInterval) duration
                        delay:(NSTimeInterval) delay
              effectAnimation:(effectAnimatableLayerColsure) effectAnimation
              finishedClosure:(CompletionClosure)completion {
    
    
    CalyerAnimotion *animationObjc = [[CalyerAnimotion alloc]init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay*NSEC_PER_SEC), dispatch_get_main_queue(),^(){
        
        
        CALayer *olderLayer = [animationObjc animatableLayerCopy:layer];
        CALayer *newLayer  = [animationObjc animatableLayerCopy:layer];
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationObjc.completionBlock = completion;
        
        if (effectAnimation) {
            //改变Layer的properties，同时关闭implicit animation
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            olderLayer = effectAnimation(olderLayer);
            newLayer.opacity = 1.0;
            [CATransaction commit];
        }
        
        animationGroup = [animationObjc groupAnimationWithOldLayer:olderLayer  newLayer:newLayer];
        
        if (animationGroup) {
            animationObjc.textLayer = layer ;
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animationGroup.beginTime = CACurrentMediaTime();
            animationGroup.duration = duration;
            animationGroup.delegate = animationObjc;
            [layer addAnimation:animationGroup forKey:textAnimationGroupKey];
            
        }else {
            if (completion) {
                completion(YES);
            }
            
        }
    });
    
}

- (CAAnimationGroup *) groupAnimationWithOldLayer:(CALayer *)olderLayer  newLayer:(CALayer *)newLayer {
    
    CAAnimationGroup *animationGroup;
    NSMutableArray<CABasicAnimation *> *animations = [[NSMutableArray alloc]init];;
    
    if ( !__CGPointEqualToPoint(olderLayer.position, newLayer.position)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        basicAnimation.fromValue =  [NSValue valueWithCGPoint:olderLayer.position];
        basicAnimation.toValue =  [NSValue valueWithCGPoint:newLayer.position];
        basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
        basicAnimation.removedOnCompletion = NO;
        [animations addObject:basicAnimation];
    }
    
    
    if (!CATransform3DEqualToTransform(olderLayer.transform, newLayer.transform)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        basicAnimation.fromValue =  [NSValue valueWithCATransform3D:olderLayer.transform];
        basicAnimation.toValue =  [NSValue valueWithCATransform3D:newLayer.transform];
        basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
        basicAnimation.removedOnCompletion = NO;
        [animations addObject:basicAnimation];
    }
    
    if (!CGRectEqualToRect(olderLayer.frame, newLayer.frame)) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"frame"];
        basicAnimation.fromValue =  [NSValue valueWithCGRect:olderLayer.frame];
        basicAnimation.toValue =  [NSValue valueWithCGRect:newLayer.frame];
        basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
        basicAnimation.removedOnCompletion = NO;
        [animations addObject:basicAnimation];
    }
    
    if (!CGRectEqualToRect(olderLayer.bounds, olderLayer.bounds))
    {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        basicAnimation.fromValue =  [NSValue valueWithCGRect:olderLayer.bounds];
        basicAnimation.toValue =  [NSValue valueWithCGRect:newLayer.bounds];
        basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
        basicAnimation.removedOnCompletion = NO;
        [animations addObject:basicAnimation];
    }
    
    if (olderLayer.opacity != newLayer.opacity)
    {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        basicAnimation.fromValue = [NSNumber numberWithFloat:olderLayer.opacity];
        basicAnimation.toValue = [NSNumber numberWithFloat:newLayer.opacity];
        basicAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
        basicAnimation.removedOnCompletion = NO;
        [animations addObject:basicAnimation];
    }
    
    if (animations.count > 0) {
        animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = animations;
        animationGroup.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
        animationGroup.removedOnCompletion = NO;
    }
    return animationGroup;
}



- (CALayer *)animatableLayerCopy:(CALayer *)layer {
    
    CALayer *layerCopy = [CALayer layer];
    layerCopy.opacity = layer.opacity;
    layerCopy.bounds = layer.bounds;
    layerCopy.frame = layer.frame;
    layerCopy.transform = layer.transform;
    layerCopy.position = layer.position;
    return layerCopy;
}

#pragma mark - animationDelegate
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    NSLog(@"animationDidStop");
    [self.textLayer removeAnimationForKey:textAnimationGroupKey];
    self.completionBlock(flag);
}


@end


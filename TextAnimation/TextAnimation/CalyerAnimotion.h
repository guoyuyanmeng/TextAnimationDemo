//
//  CalyerAnimotion.h
//  TextAnimation
//
//  Created by kang on 16/4/13.
//  Copyright © 2016年 kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef  void(^CompletionClosure)(bool finshed);
typedef CATextLayer* (^effectAnimatableLayerColsure) (CATextLayer *);

@interface CalyerAnimotion : NSObject


//添加文字动画
+ (void) addAnimotionWithLayer:(CALayer*) layer
                  duration:(NSTimeInterval) duration
                     delay:(NSTimeInterval) delay
           effectAnimation:(effectAnimatableLayerColsure) effectAnimation
           finishedClosure:(CompletionClosure)completion;

//删除文字动画
+ (void) removeAnimotionWithLayer:(CALayer*) layer
                     duration:(NSTimeInterval) duration
                        delay:(NSTimeInterval) delay
              effectAnimation:(effectAnimatableLayerColsure) effectAnimation
              finishedClosure:(CompletionClosure)completion;

@end

//
//  CoreAnimotionLabel.m
//  TextAnimation
//
//  Created by kang on 16/4/13.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "CoreAnimotionLabel.h"
#import <CoreText/CoreText.h>
#import "CalyerAnimotion.h"


typedef  void(^textAnimationClosure)(void);
@interface CoreAnimotionLabel () <NSLayoutManagerDelegate>
{
    NSMutableArray<CATextLayer *> *_oldCharacterTextLayers;
    NSMutableArray<CATextLayer *> *_newCharacterTextLayers;
    
    BOOL animationIn;
    BOOL animationOut;
    
}

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *textLayoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@end


@implementation CoreAnimotionLabel
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
        [self setPropert];
        [self initlized];
    }
    
    return self;
}

- (void) setPropert {
    
//    self.font = [UIFont systemFontOfSize:38.0];//UIFont(name: "Apple SD Gothic Neo", size: 38)
//    self.numberOfLines = 5 ;
//    self.textAlignment = NSTextAlignmentCenter;
//    self.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    
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
-(void) setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    _textContainer.size = bounds.size;
}

- (void) setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
}

- (void) setNumberOfLines:(NSInteger)numberOfLines {

    [super setNumberOfLines:numberOfLines];
    _textContainer.maximumNumberOfLines = numberOfLines;
    
}

- (void) setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [super setLineBreakMode:lineBreakMode];
    _textContainer.lineBreakMode = lineBreakMode;
}


- (void) setText:(NSString *)text {
//    [super setText:text];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange textRange = NSMakeRange(0, text.length);
    //设置段落格式
    NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphyStyle.alignment = NSTextAlignmentCenter;
    paragraphyStyle.alignment = self.textAlignment;
    //设置文字颜色
//    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0] range:textRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:self.textColor range:textRange];
    //设置文字字体
//    [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:38.0] range:textRange];
    [attributedText addAttribute:NSFontAttributeName value:self.font range:textRange];
    //设置段落格式
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphyStyle range:textRange];
    
    [_textStorage setAttributedString:attributedText];
    [self setAttributedText:attributedText];
}


//设置需要删除的textlayer 数组
- (void) setOldCharacterTextLayers {
    
    [_oldCharacterTextLayers removeAllObjects];
    
    for (CATextLayer *textlayer in _newCharacterTextLayers) {
        [_oldCharacterTextLayers addObject:textlayer];
    }
    
}

//设置需要添加的textlayer 数组
-(void) setNewCharacterTextLayers {
    
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
        textLayer.contentsScale = [UIScreen mainScreen].scale;//设置以Retina的质量来显示文字
        [self.layer addSublayer:textLayer];
        [_newCharacterTextLayers addObject:textLayer];
        index += characterRange.length;
        
    }//while cyc
}


- (void) setAttributedText:(NSAttributedString *)attributedText {
    
    //删除
    if (_oldCharacterTextLayers.count > 0) {
        [self removeOlderTextAnimation:^(){}];
    }
    
    //添加
    if (_newCharacterTextLayers.count > 0) {
        [self addNewCharacterTextLayers:nil];
    }
    
}



#pragma mark NSLayoutManagerDelegate
- (void)layoutManager:(NSLayoutManager *)layoutManager
didCompleteLayoutForTextContainer:(nullable NSTextContainer *)textContainer
                atEnd:(BOOL)layoutFinishedFlag {
    
    [self setOldCharacterTextLayers];
    
    [self setNewCharacterTextLayers];
    
    NSLog(@"textStorage.string:%@",_textStorage.string);
    
}



#pragma mark - private Method

//删除之前的文字
- (void) removeOlderTextAnimation: (textAnimationClosure)animationClosure{
    
//    NSLog(@"startAnimation");
    NSInteger longestAniamtionIndex = -1;
    NSInteger index = 0;
    
    
    
    for (CATextLayer *textlayer in _oldCharacterTextLayers) {
        
        NSTimeInterval duration = arc4random()%100/125.0 + 0.35;
        NSTimeInterval delay = arc4random_uniform(100)/500.0;
        
        CGFloat distance = arc4random()%50+25;
        CGFloat angle = arc4random()%3141/1000.0/M_PI_2-M_PI_4;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        transform = CATransform3DRotate(transform, angle, 0, 0, 1);
        
        
        if (delay+duration > 0.0)
        {
            longestAniamtionIndex = index;
        }

        
        [CalyerAnimotion removeAnimotionWithLayer: textlayer
                                            duration: duration
                                               delay: delay
                                     effectAnimation:^(CATextLayer *layer) {
                                         layer.transform = transform;
                                         layer.opacity = 0.0;
                                         return layer;
                                     
                                     }
                                     finishedClosure:^(BOOL isfinished) {
                                         
                                         [textlayer removeFromSuperlayer];
                                         if (_oldCharacterTextLayers)
                                         {
                                             
                                             if (_oldCharacterTextLayers.count > longestAniamtionIndex  && textlayer == _oldCharacterTextLayers[longestAniamtionIndex])
                                             {
                                                 if ( animationClosure)
                                                 {
                                                     animationClosure();
                                                 }
                                             }
                                         }

                                     }];
        ++index;
        
    }//for cycle
}


//添加新的文字
-(void) addNewCharacterTextLayers:(textAnimationClosure)animationClosure {
    
    for (CALayer *textLayer in _newCharacterTextLayers)
    {
       
        NSTimeInterval duration = arc4random()%200/100.0+0.25;
//        NSTimeInterval delay = 0.5;
        NSTimeInterval delay = arc4random_uniform(100)/500.0;
        
        CGFloat distance = arc4random()%50+25;
        CGFloat angle = arc4random()%3141/1000.0/M_PI_2-M_PI_4;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, -distance, 0);
        transform = CATransform3DRotate(transform, -angle, 0, 0, 1);
        
        [CalyerAnimotion addAnimotionWithLayer: textLayer
                                      duration: duration
                                         delay: delay
                               effectAnimation:^(CATextLayer *layer) {
                                  layer.transform = transform;
//                                          layer.opacity = 1.0;
                                  return layer;
                                      
                               }
                               finishedClosure:^(BOOL isfinished) {
                                  
                                  textLayer.opacity = 1.0;
                                  if ( animationClosure)
                                  {
                                      animationClosure();
                                  }
                               }];
    }
}


@end

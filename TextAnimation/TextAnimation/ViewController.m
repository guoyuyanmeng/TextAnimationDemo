//
//  ViewController.m
//  TextAnimation
//
//  Created by kang on 16/4/5.
//  Copyright © 2016年 kang. All rights reserved.
//

#import "ViewController.h"
#import "CoreLabel.h"
#import "TextAnimationLabel2.h"
#import "CoreAnimotionLabel.h"


@interface ViewController ()
{

    NSArray *textArray;
}
@property (nonatomic, strong)CoreAnimotionLabel *animationLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textArray = @[@"What is design?",
                  @"Design Code By Swift",
                  @"Design is not just",
                  @"what it looks like",
                  @"and feels like.",
                  @"Hello,Swift",
                  @"is how it works.",
                  @"- Steve Jobs",
                  @"Older people",
                  @"sit down and ask,",
                  @"Мною забот？",
                  @"我是要成为海贼王の男人!",
                  @"オレは海贼王になる男だ！ ",
                  @"Нашёл дурака！",
                  @"Батюшки мои！",
                  @"Objective-C",
                  @"iPhone",
                  @"iPad",
                  @"Mac Mini",
                  @"MacBook Pro",
                  @"Mac Pro",];
//    
//    CoreLabel *label = [[CoreLabel alloc]initWithFrame:CGRectMake(50, 50, 220, 220)];
//    label.center = self.view.center;
////    [label setBackgroundColor:[UIColor grayColor]];
//    [self.view addSubview:label];
    
    //
    CGRect labelFrame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    self.animationLabel = [[CoreAnimotionLabel alloc]initWithFrame:labelFrame];
    self.animationLabel.font = [UIFont systemFontOfSize:38.0];//UIFont(name: "Apple SD Gothic Neo", size: 38)
    self.animationLabel.numberOfLines = 5 ;
    self.animationLabel.textAlignment = NSTextAlignmentCenter;
    self.animationLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    self.animationLabel.text = @"我是要成为海贼王の男人!";
    
//    [self.animationLabel setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.animationLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(180, 400, 80, 60);
    [btn setTitle:@"change" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void) btnAction {
    
    int index = arc4random_uniform(20);
    if (index < textArray.count) {
        
        NSString *tempStr = [textArray objectAtIndex:index];
        self.animationLabel.text = tempStr;
    }
}


@end

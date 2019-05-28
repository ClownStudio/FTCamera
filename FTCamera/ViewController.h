//
//  ViewController.h
//  FTCamera
//
//  Created by 张文洁 on 2018/7/27.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface ViewController : BasicViewController

@property (nonatomic, strong) IBOutlet UIImageView *bg1;
@property (nonatomic, strong) IBOutlet UIImageView *bg2;
@property (nonatomic, strong) IBOutlet UIButton *btn1;
@property (nonatomic, strong) IBOutlet UIButton *btn2;
@property (nonatomic, strong) IBOutlet UIButton *btn3;
@property (nonatomic, strong) IBOutlet UIButton *btn4;
@property (nonatomic, strong) IBOutlet UIButton *btn5;

@property (nonatomic, strong) NSTimer *timer;

@end


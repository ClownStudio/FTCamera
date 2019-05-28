//
//  UnlockViewController.h
//  FTCamera
//
//  Created by 张文洁 on 2018/7/30.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProManager.h"

@interface UnlockViewController : UIViewController <ProManagerDelegate>

@property (nonatomic, strong) ProManager *proManager;

@end

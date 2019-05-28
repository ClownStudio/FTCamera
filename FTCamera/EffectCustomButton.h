//
//  EffectCustomButton.h
//  FTCamera
//
//  Created by 张文洁 on 2018/8/10.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EffectCustomButton : UIButton

@property (nonatomic,strong) UIImageView *lockedImageView;

- (void)setLayoutWithContent:(NSDictionary *)content;

@end

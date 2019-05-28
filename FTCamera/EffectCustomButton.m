//
//  EffectCustomButton.m
//  FTCamera
//
//  Created by 张文洁 on 2018/8/10.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import "EffectCustomButton.h"
#import "ProManager.h"
#import "Macro.h"

@implementation EffectCustomButton{
    UIImageView *_customImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //编辑功能的灰色背景
        [self setBackgroundColor:itemBackGroundColor];
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemBonderWidth, itemBonderWidth, frame.size.width - itemBonderWidth * 2, frame.size.height - itemBonderWidth * 2)];
        [self addSubview:_customImageView];
        
        self.lockedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 20, 10, 10, 10)];
        [self.lockedImageView setImage:[UIImage imageNamed:@"FT_Single_iap"]];
        self.lockedImageView.hidden = YES;
        [self addSubview:self.lockedImageView];
    }
    return self;
}

- (void)setLayoutWithContent:(NSDictionary *)content{
    [_customImageView setImage:[UIImage imageNamed:[content objectForKey:@"icon"]]];
    if ([ProManager isFullPaid] || [ProManager isProductPaid:[content objectForKey:@"productCode"]]) {
        self.lockedImageView.hidden = YES;
        return;
    }
    if ([[content objectForKey:@"isPurchase"] boolValue] == YES) {
        self.lockedImageView.hidden = YES;
    }else{
        self.lockedImageView.hidden = NO;
    }
}

@end

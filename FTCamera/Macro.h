//
//  Macro.h
//  FTCamera
//
//  Created by 张文洁 on 2018/7/30.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define ALL_PRODUCT_ID [NSString stringWithFormat:@"%@.pro",[[NSBundle mainBundle] bundleIdentifier]]

#define HIDE_SETTING_ANIMATION @"HIDE_SETTING_ANIMATION"

#define APP_ID @"1039766045"

//背景色
#define itemBackGroundColor [UIColor colorWithRed:0.086 green:0.086 blue:0.086 alpha:1.000]

//选中的边框色
#define itemBonderColor [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1.000]

//边框大小
#define itemBonderWidth 5

//广告产品id
#define AD_PRODUCT_ID @"com.appstudio.X2.ad"
//应⽤程式ID
#define AD_APP_ID @"ca-app-pub-3553919144267977~7168202255"
//插⻚广告ID
#define AD_INTERSTITIAL_ID @"ca-app-pub-3553919144267977/4714279360"
//横幅广告ID
#define AD_BANNER_ID @"ca-app-pub-3553919144267977/2279687717"

//广告展示时间间隔（秒）
#define CameraShowAdTime 20

//是否解锁后才可保存 0为是 1为否
#define IsSavedWithAD @"1"

#endif /* Macro_h */

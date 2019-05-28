//
//  AutoEditorViewController.h
//  FTCamera
//
//  Created by 张文洁 on 2018/8/6.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "EditNavigationBar.h"

@class AutoEditorViewController;

@protocol AutoEditorViewControllerDelegate <NSObject>

@optional
/**
 点击“完成”按钮回调函数
 */
-(void)didClickFinishButtonWithEditController:(AutoEditorViewController *)controller  newImage:(UIImage*)newImage;
/**
 点击“取消”按钮回调函数
 */
-(void)didClickCancelButtonWithEditController:(AutoEditorViewController *)controller;

@end

@interface AutoEditorViewController : BasicViewController

@property (nonatomic, weak) id <AutoEditorViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *oriImage;
@property (nonatomic, strong) UIImage *resetImage;

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) EditNavigationBar *navigationBar;

@end

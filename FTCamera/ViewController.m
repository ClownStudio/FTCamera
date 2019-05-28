//
//  ViewController.m
//  FTCamera
//
//  Created by 张文洁 on 2018/7/27.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import "ViewController.h"
#import "HXPhotoViewController.h"
#import "AssetBuffer.h"
#import "PayViewController.h"
#import "UnlockViewController.h"
#import <MBProgressHUD+JDragon.h>
#import "SettingView.h"
#import "AutoEditorViewController.h"
#import "UIImage+Rotate.h"
#import <StoreKit/StoreKit.h>

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define kStoreProductKey [NSString stringWithFormat:@"storeProduct%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, HXPhotoViewControllerDelegate, AutoEditorViewControllerDelegate,SKProductsRequestDelegate>{
    NSInteger _sourceType;
    NSInteger _currentImageIndex;
}

@property (strong, nonatomic) UIView *alphaView;
@property (strong, nonatomic) HXPhotoManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadBuffer];
    CGSize screen_size = [UIScreen mainScreen].bounds.size;
    CGSize bg_size = CGSizeMake(screen_size.height * 2048 / 2732, screen_size.height);
    
    CGRect r = self.bg1.frame;
    r.size = bg_size;
    self.bg1.frame = self.bg2.frame = r;
    self.bg1.center = self.bg2.center = self.view.center;
    self.bg1.image = [UIImage imageNamed:@"landing_1.jpg"];
    self.bg2.image = [UIImage imageNamed:@"landing_2.jpg"];
    self.bg2.alpha = 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    [self.btn1 sizeToFit];
    [self.btn2 sizeToFit];
    
    self.btn2.center = CGPointMake(screen_size.width / 2, self.btn2.center.y);
    
    CGFloat span = (screen_size.width - 3 * self.btn1.frame.size.width)/6;
    if (span > 30) {
        span = 30;
    }
    r = self.btn1.frame;
    r.origin.x = self.btn2.frame.origin.x - r.size.width - span;
    self.btn1.frame = r;
    
    self.btn3.center = CGPointMake(self.btn1.center.x, self.btn1.center.y + self.btn1.frame.size.height/2 + 40);
    self.btn4.center = CGPointMake(self.btn2.center.x, self.btn3.center.y);
    self.btn5.center = CGPointMake(screen_size.width - self.btn3.center.x, self.btn3.center.y);
    
    //临时
    r = self.btn1.frame;
    r.origin.x += (r.size.width + span) / 2;
    self.btn1.frame = r;
    
    r = self.btn2.frame;
    r.origin.x += (r.size.width + span) / 2;
    self.btn2.frame = r;
}

- (void)timerFired{
    switch (_currentImageIndex) {
        case 0:
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.bg1.alpha = 0;
                self.bg2.alpha = 1;
            } completion:^(BOOL finished) {
                self.bg1.image = [UIImage imageNamed:@"landing_3.jpg"];
            }];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.bg2.alpha = 0;
                self.bg1.alpha = 1;
            } completion:^(BOOL finished) {
                self.bg2.image = [UIImage imageNamed:@"landing_1.jpg"];
            }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.bg1.alpha = 0;
                self.bg2.alpha = 1;
            } completion:^(BOOL finished) {
                self.bg1.image = [UIImage imageNamed:@"landing_2.jpg"];
            }];
        }
            break;
        default:
            break;
    }
    
    _currentImageIndex = (_currentImageIndex + 1) % 3;
}

- (IBAction)albumAction:(id)sender{
    _sourceType = 0;
    if ([UIImagePickerController isSourceTypeAvailable:_sourceType]) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        
        //设置选取的照片是否可编辑
        pickerController.allowsEditing = NO;
        //设置相册呈现的样式
        pickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;//图片分组列表样式
        //照片的选取样式还有以下两种
        //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
        //UIImagePickerControllerSourceTypeCamera//调取摄像头
        
        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        pickerController.delegate = self;
        //使用模态呈现相册
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"NotSupportAlbum", nil)];
    }
}

- (IBAction)cameraAction:(id)sender{
    _sourceType = 1;
    if ([UIImagePickerController isSourceTypeAvailable:_sourceType]) {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        
        //设置选取的照片是否可编辑
        pickerController.allowsEditing = NO;
        //设置相册呈现的样式
        pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;//图片分组列表样式
        //照片的选取样式还有以下两种
        //UIImagePickerControllerSourceTypePhotoLibrary,直接全部呈现系统相册
        //UIImagePickerControllerSourceTypeCamera//调取摄像头
        
        //选择完成图片或者点击取消按钮都是通过代理来操作我们所需要的逻辑过程
        pickerController.delegate = self;
        //使用模态呈现相册
        [self.navigationController presentViewController:pickerController animated:YES completion:^{
            
        }];
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"NoCamera", nil)];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    resultImage = [resultImage fixOrientation];
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self beginEdit:resultImage];
    }];
    
}

- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original{
    if (photos.count > 0)
    {
        [HXPhotoTools getImageForSelectedPhoto:photos type:HXPhotoToolsFetchHDImageType completion:^(NSArray<UIImage *> *images) {
            NSSLog(@"%@",images);
            if (images.count > 0)
            {
                UIImage *img = [images firstObject];
                [self beginEdit:img];
            }
        }];
    }
}

- (void)photoViewControllerDidCancel{
    NSSLog(@"Cancel");
}

- (HXPhotoManager *)manager{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.videoMaxNum = 0;
        _manager.photoMaxNum = 1;
        _manager.lookGifPhoto = NO;
        _manager.cacheAlbum = NO;
        _manager.saveSystemAblum = YES;
        _manager.singleSelected = YES;
        _manager.singleSelecteClip = NO;
    }
    return _manager;
}

-(void)beginEdit:(UIImage*)img{
    AutoEditorViewController *editor = [[AutoEditorViewController alloc] init];
    editor.delegate = self;
    editor.oriImage = img;
    editor.resetImage = img;
    [self.navigationController pushViewController:editor animated:YES];
}


#pragma mark HCPhotoEditViewControllerDelegate

-(void)didClickFinishButtonWithEditController:(AutoEditorViewController *)controller newImage:(UIImage *)newImage{
    //分享的标题
    NSString *textToShare = NSLocalizedString(@"Share", nil);
    //分享的图片
    UIImage *imageToShare = newImage;
    NSArray *activityItems = @[textToShare,imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
    activityVC.popoverPresentationController.sourceView = controller.navigationBar.nextBtn;
    activityVC.popoverPresentationController.sourceRect = controller.navigationBar.nextBtn.bounds;
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    __weak id weak_self = self;
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        if (completed) {
            //分享 成功
            if (activityType == UIActivityTypeSaveToCameraRoll) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Saved", nil) preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    ;
                }]];
                
                [weak_self presentViewController:alert animated:YES completion:^{
                    ;
                }];
            }
        }
    };
}

- (void)didClickCancelButtonWithEditController:(AutoEditorViewController *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
    [self performSelector:@selector(onAlertStoreProduct) withObject:nil afterDelay:0.5];
}

- (void)onAlertStoreProduct{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([@"1" isEqualToString:[defaults objectForKey:kStoreProductKey]]) {
        return;
    }
    [self loadAppStoreController];
}

- (void)loadAppStoreController{
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }else{
            [self layoutAlertOrder];
        }
    } else {
        [self layoutAlertOrder];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:kStoreProductKey];
    [defaults synchronize];
}

- (void)layoutAlertOrder{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tip", nil) message:NSLocalizedString(@"Evaluate", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
            [self goToAppStore];
        }else{
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APP_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)goToAppStore{
    NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",APP_ID];;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)loadBuffer{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AssetBuffer *buffer = [AssetBuffer sharedInstance];
        [buffer loadImages];
    });
}

- (IBAction)settingAction:(id)sender{
    self.alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.alphaView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.alphaView];
    
    SettingView *settingView = [[[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:self options:nil] lastObject];
    if (IS_PAD) {
        [settingView setFrame:CGRectMake(- self.view.bounds.size.width * 0.4, 0, self.view.bounds.size.width * 0.4, self.view.bounds.size.height)];
    }else{
        [settingView setFrame:CGRectMake(- self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    settingView.tag = 1;
    [self.alphaView addSubview:settingView];
    [self.alphaView setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temp = settingView.frame;
        temp.origin.x = 0;
        settingView.frame = temp;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseSettingView)];
        [self.alphaView setUserInteractionEnabled:YES];
        [self.alphaView addGestureRecognizer:tap];
    }];
}

- (void)onCloseSettingView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temp = [self.alphaView viewWithTag:1].frame;
        temp.origin.x = - temp.size.width;
        [self.alphaView viewWithTag:1].frame = temp;
    } completion:^(BOOL finished) {
        [self.alphaView removeFromSuperview];
    }];
}

- (IBAction)recommendAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1291776269"]];
}

- (IBAction)buyAction:(id)sender{
    UnlockViewController *viewController = [[UnlockViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseSettingView) name:HIDE_SETTING_ANIMATION object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDE_SETTING_ANIMATION object:nil];
}

@end

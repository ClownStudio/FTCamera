//
//  UnlockViewController.m
//  FTCamera
//
//  Created by 张文洁 on 2018/7/30.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import "UnlockViewController.h"
#import "Macro.h"
#import <MBProgressHUD+JDragon.h>

@interface UnlockViewController ()

@end

#define Is_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

@implementation UnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
    
    self.proManager = [[ProManager alloc] init];
    self.proManager.delegate = self;
    
    UIImageView *imageView;
    if (IS_PAD) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height * 0.8/1136*640, self.view.bounds.size.height * 0.8)];
    }else{
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.8, self.view.bounds.size.width * 0.8/640 *1136)];
    }
    
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
    [imageView.layer setCornerRadius:15];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"FT_Unlock"]];
    [imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuyAllProduct:)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 40)/2, imageView.frame.origin.y + imageView.frame.size.height + 15, 40, 40)];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:20];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[UIColor whiteColor].CGColor];
    [button setImage:[UIImage imageNamed:@"FT_Close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(IBAction)onBuyAllProduct:(id)sender{
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"Loading", nil)];
    [self.proManager restorePro];
}

-(void)didSuccessBuyProduct:(NSString*)productId
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccessMessage:NSLocalizedString(@"PurchaseSuccess", nil)];
    [self performSelector:@selector(onBack:) withObject:nil afterDelay:3.0f];
}

-(void)didSuccessRestoreProducts:(NSArray*)productIds
{
    [MBProgressHUD hideHUD];
    if ([ProManager isFullPaid])
    {
        //全解锁
        [MBProgressHUD showSuccessMessage:NSLocalizedString(@"RestoreSuccess", nil)];
        [self performSelector:@selector(onBack:) withObject:nil afterDelay:3.0f];
        return ;
    }
    
    //未买过，进行支付
    [self.proManager buyProduct:kProDeluxeId];
}

-(void)didFailRestore:(NSString *)reason
{
    [MBProgressHUD hideHUD];
    [self.proManager buyProduct:kProDeluxeId];
}

-(void)didFailedBuyProduct:(NSString*)productId forReason:(NSString*)reason
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showErrorMessage:reason];
}

-(void)didCancelBuyProduct:(NSString*)productId
{
    [MBProgressHUD hideHUD];
}

-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.proManager) {
        self.proManager.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.proManager) {
        self.proManager.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

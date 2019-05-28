//
//  BasicViewController.m
//  FTCamera
//
//  Created by 张文洁 on 2018/8/2.
//  Copyright © 2018年 JamStudio. All rights reserved.
//

#import "BasicViewController.h"
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD+JDragon.h>

@interface BasicViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.proManager = [[ProManager alloc] init];
    self.proManager.delegate = self;
}

- (void)onFeedback{
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"NoMailAccount", nil)];
        return;
    }
    if ([MFMessageComposeViewController canSendText] == YES) {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
        mailCompose.mailComposeDelegate = self;
        [mailCompose setSubject:@""];
        NSArray *arr = @[@"samline228@yahoo.com"];
        //收件人
        [mailCompose setToRecipients:arr];
        [self presentViewController:mailCompose animated:YES completion:nil];
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"NoSupportMail", nil)];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    if (result) {
        NSLog(@"Result : %ld",(long)result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onRestore{
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"Loading", nil)];
    [self.proManager restorePro];
}

-(void)didSuccessBuyProduct:(NSString*)productId
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccessMessage:NSLocalizedString(@"PurchaseSuccess", nil)];
}

-(void)didSuccessRestoreProducts:(NSArray*)productIds
{
    [MBProgressHUD hideHUD];
    if ([ProManager isFullPaid])
    {
        //全解锁
        [MBProgressHUD showSuccessMessage:NSLocalizedString(@"RestoreSuccess", nil)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

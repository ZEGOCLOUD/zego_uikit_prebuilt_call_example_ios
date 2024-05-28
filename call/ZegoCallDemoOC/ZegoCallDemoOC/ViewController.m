//
//  ViewController.m
//  ZegoCallDemoOC
//
//  Created by zego on 2024/5/27.
//

#import "ViewController.h"
@import ZegoUIKit;
@import ZegoUIKitPrebuiltCall;
@import ZegoPluginAdapter;
@interface ViewController ()
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *appSign;
@property (nonatomic, assign) unsigned int appID;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.userID = [NSString stringWithFormat:@"%u",arc4random() % 99999];
  self.userName = [NSString stringWithFormat:@"zego_%@",self.userID];
  self.appID = <#appID#>;
  self.appSign = <#appSign#>;
}

- (IBAction)makeNewCall:(id)sender {
  self.userID = self.userIDLabel.text.length > 0 ? self.userIDLabel.text : [NSString stringWithFormat:@"%u",arc4random() % 99999];
  self.userName = [NSString stringWithFormat:@"zego_%@",self.userID];
  
  ZegoUIKitPrebuiltCallConfig *config = [ZegoUIKitPrebuiltCallConfig oneOnOneVideoCall];
  ZegoUIKitPrebuiltCallVC *vc = [[ZegoUIKitPrebuiltCallVC alloc] init:self.appID appSign:self.appSign userID:self.userID userName:self.userName callID:@"100" config:config];
  vc.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:vc animated:YES completion:nil];
}


@end

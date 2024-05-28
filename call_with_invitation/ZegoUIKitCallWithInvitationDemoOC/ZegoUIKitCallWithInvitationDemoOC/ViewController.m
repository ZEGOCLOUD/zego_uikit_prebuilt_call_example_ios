//
//  ViewController.m
//  ZegoUIKitCallWithInvitationDemoOC
//
//  Created by zego on 2024/5/27.
//

#import "ViewController.h"
@import ZegoUIKit;
@import ZegoUIKitPrebuiltCall;
@import ZegoUIKitSignalingPlugin;
@import ZegoPluginAdapter;
@interface ViewController ()<ZegoSendCallInvitationButtonDelegate,ZegoUIKitPrebuiltCallInvitationServiceDelegate,UITextFieldDelegate,ZegoUIKitEventHandle>
@property (nonatomic, assign) unsigned int appID;
@property (nonatomic, copy) NSString *appSign;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) ZegoSendCallInvitationButton * voiceCallButton;
@property (nonatomic, strong) ZegoSendCallInvitationButton * videoCallButton;
@property (weak, nonatomic) IBOutlet UIView *voiceCallView;
@property (weak, nonatomic) IBOutlet UITextField *inviteesTextField;
@property (weak, nonatomic) IBOutlet UIView *videoCallView;
@property (weak, nonatomic) IBOutlet UILabel *yourUserIDLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.userID = [NSString stringWithFormat:@"%u",arc4random() % 999999];
  self.userName = @"ios_test";
  self.appID = <#appID#>;
  self.appSign = <#appSign#>;
  
  [self addSubviews];
  self.inviteesTextField.delegate = self;
  [self.inviteesTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
  self.yourUserIDLabel.text = [NSString stringWithFormat:@"Your UserID:%@",self.userID];
  
  ZegoUIKitPrebuiltCallInvitationConfig *config = [[ZegoUIKitPrebuiltCallInvitationConfig alloc] initWithNotifyWhenAppRunningInBackgroundOrQuit:YES isSandboxEnvironment:YES certificateIndex:ZegoSignalingPluginMultiCertificateFirstCertificate];
  [[ZegoUIKitPrebuiltCallInvitationService shared] initWithAppID:self.appID appSign:self.appSign userID:self.userID userName:self.userName config:config];
  [ZegoUIKitPrebuiltCallInvitationService shared].delegate = self;
  [[ZegoUIKit shared] addEventHandler:self];

}

- (void)addSubviews {
  self.voiceCallButton = [[ZegoSendCallInvitationButton alloc] init:ZegoInvitationTypeVoiceCall];
  self.voiceCallButton.frame = CGRectMake(0, 0, self.voiceCallView.bounds.size.width, self.voiceCallView.bounds.size.height);
  self.voiceCallButton.delegate = self;
  [self.voiceCallView addSubview:self.voiceCallButton];
  
  
  self.videoCallButton = [[ZegoSendCallInvitationButton alloc] init:ZegoInvitationTypeVideoCall];
  self.videoCallButton.frame = CGRectMake(0, 0, self.videoCallView.bounds.size.width, self.videoCallView.bounds.size.height);
  self.videoCallButton.delegate = self;
  [self.videoCallView addSubview:self.videoCallButton];
  
    self.voiceCallButton.resourceID = @"<#resourceID#>";
    self.videoCallButton.resourceID = @"<#resourceID#>";

}

#pragma mark - ZegoSendCallInvitationButtonDelegate
- (void)onPressed:(NSInteger)errorCode errorMessage:(NSString *)errorMessage errorInvitees:(NSArray<ZegoCallUser *> *)errorInvitees {
  
}

#pragma mark - ZegoUIKitPrebuiltCallInvitationServiceDelegate
- (ZegoUIKitPrebuiltCallConfig *)requireConfig:(ZegoCallInvitationData *)data {
  ZegoUIKitPrebuiltCallConfig *config = [ZegoUIKitPrebuiltCallConfig new];
  if (data.type == ZegoInvitationTypeVoiceCall) {
    if (data.invitees.count > 1 ) {
      config = [ZegoUIKitPrebuiltCallConfig groupVoiceCall];
    } else {
      config = [ZegoUIKitPrebuiltCallConfig oneOnOneVoiceCall];
    }
  } else if (data.type == ZegoInvitationTypeVideoCall) {
    if (data.invitees.count > 1 ) {
      config = [ZegoUIKitPrebuiltCallConfig groupVideoCall];
    } else {
      config = [ZegoUIKitPrebuiltCallConfig oneOnOneVideoCall];
    }
  }
  return config;
}

#pragma mark - UITextFieldDelegate
- (void)textDidChange:(UITextField *)textField {
  if (textField.text.length <= 0) {
    return;
  }
  
  NSArray *IDArray = [textField.text componentsSeparatedByString:@","];
  NSMutableArray <ZegoUIKitUser*>*inviteesList = [NSMutableArray array];
  for (_userID in IDArray) {
    NSString * userName = _userID;
    if(_userID.length <= 0){
      return;
    }
    ZegoUIKitUser *user = [[ZegoUIKitUser alloc] init:_userID :userName :YES :YES];
    [inviteesList addObject:user];
  }
  self.videoCallButton.inviteeList = inviteesList;
  self.voiceCallButton.inviteeList = inviteesList;
}
#pragma mark - ZegoUIKitEventHandle


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self.inviteesTextField endEditing:YES];
}
@end

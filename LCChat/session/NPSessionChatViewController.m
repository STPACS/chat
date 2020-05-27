

//
//  NPSessionChatViewController.m
//  LCChat
//
//  Created by mac on 2020/5/27.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSessionChatViewController.h"
#import "NTESSessionConfig.h"
#import "NTESBundleSetting.h"
#import "UIView+Toast.h"
#import "NTESMulSelectFunctionBar.h"
#import "NIMKitMediaFetcher.h"

@import MobileCoreServices;
@import AVFoundation;


@interface NPSessionChatViewController ()
@property (nonatomic,strong)    NTESSessionConfig       *sessionConfig;
@property (nonatomic,strong)    UIButton *mulSelectCancelBtn;
@property (nonatomic,strong)    NSMutableArray *selectedMessages;
@property (nonatomic,strong)    NTESMulSelectFunctionBar *mulSelectedSureBar;
@property (nonatomic,strong)    NIMKitMediaFetcher *mediaFetcher;

@end

@implementation NPSessionChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DDLogInfo(@"enter session, id = %@",self.session.sessionId);

    
    // Do any additional setup after loading the view.
}

- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[NTESSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

#pragma mark - 文本消息

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers
{
    [super onSendText:text atUsers:atUsers];
}

- (void)sendMessage:(NIMMessage *)message
{
    [super sendMessage:message];
}

- (NSString *)sessionTitle
{
    return self.session.nickName;
}

#pragma mark - 石头剪子布
- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item
{
    
    NSLog(@"石头剪刀布");
    
//    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
//    attachment.value = arc4random() % 3 + 1;
//    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败".ntes_localized duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短".ntes_localized duration:0.2f position:CSToastPositionCenter];
}


#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;

}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    
}


#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *defaultItems = [super menusItems:message];
    if (defaultItems) {
        [items addObjectsFromArray:defaultItems];
    }
    
     [items addObject:[[UIMenuItem alloc] initWithTitle:@"转发".ntes_localized action:@selector(forwardMessage:)]];
    
    [items addObject:[[UIMenuItem alloc] initWithTitle:@"多选".ntes_localized action:@selector(multiSelect:)]];
    
    if (message.messageType == NIMMessageTypeText) {
         [items addObject:[[UIMenuItem alloc] initWithTitle:@"撤回".ntes_localized action:@selector(revokeMessage:)]];
    }
    
    return items;
    
}

- (void)setupNormalNav {
    UIButton *enterTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterTeamCard addTarget:self action:@selector(enterTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterTeamCard sizeToFit];
    UIBarButtonItem *enterTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterTeamCard];
    
    UIButton *enterSuperTeamCard = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterSuperTeamCard addTarget:self action:@selector(enterSuperTeamCard:) forControlEvents:UIControlEventTouchUpInside];
    [enterSuperTeamCard setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [enterSuperTeamCard setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [enterSuperTeamCard sizeToFit];
    UIBarButtonItem *enterSuperTeamCardItem = [[UIBarButtonItem alloc] initWithCustomView:enterSuperTeamCard];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(enterPersonInfoCard:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_normal"] forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"icon_session_info_pressed"] forState:UIControlStateHighlighted];
    [infoBtn sizeToFit];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn addTarget:self action:@selector(enterHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_normal"] forState:UIControlStateNormal];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_pressed"] forState:UIControlStateHighlighted];
    [historyBtn sizeToFit];
    UIBarButtonItem *historyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];

    if (self.session.sessionType == NIMSessionTypeTeam)
    {
        self.navigationItem.rightBarButtonItems  = @[enterTeamCardItem,historyButtonItem];
    }
    else if (self.session.sessionType == NIMSessionTypeSuperTeam)
    {
        self.navigationItem.rightBarButtonItems  = @[enterSuperTeamCardItem,historyButtonItem];
    }
    else if(self.session.sessionType == NIMSessionTypeP2P)
    {
        if ([self.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
        {
            self.navigationItem.rightBarButtonItems = @[historyButtonItem];
        }
        else
        {
            self.navigationItem.rightBarButtonItems = @[enterUInfoItem,historyButtonItem];
        }
    }
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.hidesBackButton = NO;
    [self.mulSelectCancelBtn removeFromSuperview];
}



- (UIButton *)mulSelectCancelBtn {
    if (!_mulSelectCancelBtn) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelSelected:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消".ntes_localized forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, 0, 48, 40);
        UIEdgeInsets titleInsets = cancelBtn.titleEdgeInsets;
        [cancelBtn setTitleEdgeInsets:titleInsets];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _mulSelectCancelBtn = cancelBtn;
    }
    return _mulSelectCancelBtn;
}


- (void)setupSelectedNav {
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar addSubview:self.mulSelectCancelBtn];
}

- (void)multiSelect:(id)sender {
    [self switchUIWithSessionState:NIMKitSessionStateSelect];
}

- (void)switchUIWithSessionState:(NIMKitSessionState)state {
    switch (state) {
        case NIMKitSessionStateSelect:
        {
            [self setupSelectedNav];
            [self setSessionState:NIMKitSessionStateSelect];
            [self.view addSubview:self.mulSelectedSureBar];
            break;
        }
        case NIMKitSessionStateNormal:
        default:
        {
            [self.mulSelectedSureBar removeFromSuperview];
            [self setSessionState:NIMKitSessionStateNormal];
            [self setupNormalNav];
            _selectedMessages = nil;
            break;
        }
    }
}

- (NTESMulSelectFunctionBar *)mulSelectedSureBar {
    if (!_mulSelectedSureBar) {
        _mulSelectedSureBar = [[NTESMulSelectFunctionBar alloc] initWithFrame:self.sessionInputView.frame];
        [_mulSelectedSureBar.sureBtn addTarget:self
                                        action:@selector(confirmSelected:)
                              forControlEvents:UIControlEventTouchUpInside];
    }
    return _mulSelectedSureBar;
}

- (void)confirmSelected:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self selectForwardSessionCompletion:^(NIMSession *targetSession) {
        //转发批量消息
        [weakSelf doMergerForwardToSession:targetSession];
        //返回正常页面
        [weakSelf switchUIWithSessionState:NIMKitSessionStateNormal];
    }];
}

#pragma mark - 转发
- (void)doMergerForwardToSession:(NIMSession *)session {
    __weak typeof(self) weakSelf = self;
   
}

- (void)onSelectedMessage:(BOOL)selected message:(NIMMessage *)message {
    if (!_selectedMessages) {
        _selectedMessages = [NSMutableArray array];
    }
    if (selected) {
        [_selectedMessages addObject:message];
    } else {
        [_selectedMessages removeObject:message];
    }
}

- (void)cancelSelected:(id)sender {
    [self switchUIWithSessionState:NIMKitSessionStateNormal];
}

- (void)forwardMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    message.setting.teamReceiptEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [self selectForwardSessionCompletion:^(NIMSession *targetSession) {
        [weakSelf forwardMessage:message toSession:targetSession];
    }];
}

- (void)selectForwardSessionCompletion:(void (^)(NIMSession *targetSession))completion {
   //转发
}


- (void)revokeMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *payload = @{
        @"apns-collapse-id": message.messageId,
    };
 
    NSLog(@"撤回一条消息");
   
}

 - (void)forwardMessage:(NIMMessage *)message toSession:(NIMSession *)session
{
    NSString *name;
  
    NSLog(@"转发一条消息");

}


- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

- (NIMKitMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[NIMKitMediaFetcher alloc] init];
        _mediaFetcher.limit = 1;
        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeGIF];
    }
    return _mediaFetcher;
}


- (void)cancelMessage:(id)sender {
    NIMMessage *message = [self messageForMenu];

    
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

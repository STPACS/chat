//
//  NPChatViewController.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatViewController.h"
#import "UITableView+NPRegistCell.h"
#import "NPKeyboardView.h"
#import "NPChatMessageTableViewCell.h"
#import "NPChatMessageTableViewCell+CellIdentifier.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NPMessageStateManager.h"
#import "Masonry.h"
#import "Marco.h"
#import "NPChatTextsTableViewCell.h"
#import "NPChatImagesTableViewCell.h"
#import "NPChatVideosTableViewCell.h"
#import "NPChatVoicesTableViewCell.h"
#import "NPDateTimeTableViewCell.h"
#import "NPMessageViewModel.h"
#import <MJRefresh.h>
#import "NPMessageItem.h"


@interface NPChatViewController ()<UITableViewDelegate,UITableViewDataSource,NPKeyboardViewDelegate,ChatMessageCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView     *backgroundImageView;

@property (strong, nonatomic) NSMutableArray  *messageArray;

@property (strong, nonatomic) NPKeyboardView    *chatBar;

@property (assign, nonatomic) NSInteger  page;//页码

@property (assign, nonatomic) NSInteger  pk;//数据库主键，用来控制加载个数


@end

@implementation NPChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pk = 0;
    
    _messageArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatBar];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"模拟收消息"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(receiveMessage)];
    //加载服务器数据
    
    self.page = 1;
    
    [self loadData];

    [self setHeaderRefresh];
    
}

- (void)setHeaderRefresh {
    __weak __typeof(&*self)weakSelf =self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.page += 1;
      
        //下拉加载更多
        [weakSelf loadMore];
    }];
}

//下拉加载历史数据,从数据库中取
- (void)loadMore {
    
    NSArray *array = [NPMessageItem findByCriteria:[NSString stringWithFormat:@" WHERE pk > %ld limit 10",(long)self.pk]];
    self.pk += 10;
    
    [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
        if (array.count == 0) {
            self.tableView.mj_header = nil;
        }
    }];
 
    for (int i = 0; i < array.count; i ++) {
       
        id object = array[i];
       
        [self.messageArray insertObject:object atIndex:0];
    }
   
    [self.tableView reloadData];
}

- (void)loadData {
    
    //获取最后一条数据
    NSArray *lastArray = [NPMessageItem findByCriteria:@"ORDER BY pk DESC LIMIT 1"];

    NSString *kid;
    if (lastArray.count > 0) {
        //用最后一条数据ID取数据
        NPMessageItem *item = lastArray[0];
        kid = item.kid;
    }else {
        kid = @"0";
    }
    
    //模拟服务器数据
    NSArray *array = [NPMessageViewModel loadDetailMessages];

    //取数据库中五条数据，跟服务器数据对比去重
    NSArray *oldArray = [[[NPMessageItem findByCriteria:[NSString stringWithFormat:@"ORDER BY pk DESC LIMIT %d",5]]reverseObjectEnumerator]allObjects];
    
    //去重
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NPMessageItem *item in oldArray) {
        [dict setObject:item.kid forKey:item.kid];
    }
    
    NSMutableArray *newArr = [NSMutableArray array];
     [array enumerateObjectsUsingBlock:^(NPMessageItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
         NSString *name = [dict objectForKey:item.kid];
         if (name.length <= 0) {
             [newArr addObject:item];
         }
     }];
    
    if (newArr.count > 0) {
        [NPMessageItem saveObjects:newArr];
    }
    
    NSArray *displayArray = [[[NPMessageItem findByCriteria:[NSString stringWithFormat:@"ORDER BY pk DESC LIMIT %d",10]]reverseObjectEnumerator]allObjects];
    
    [self.tableView.mj_header endRefreshing];
    
    for (int i = 0; i < displayArray.count; i ++) {
        
        id object = displayArray[i];
        [self.messageArray addObject:object];
    }
    
    [self.tableView reloadData];

    [self scrollTableView];
    
}

//滑动到内容底部
- (void)scrollTableView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger row = [self.tableView numberOfRowsInSection:0] - 1;
        if (row > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(naviBarHeight);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(self.view.frame.size.height - 44 - BottomHeight - naviBarHeight));
    }];
    
    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.tableView.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@44);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - npToolbarHeight) style:UITableViewStylePlain];
        
        [_tableView registerChatMessageCellClass];
        _tableView.delegate           = self;
        _tableView.dataSource         = self;
        _tableView.backgroundColor    = [UIColor orangeColor];
        _tableView.estimatedRowHeight = 66;
        _tableView.contentInset       = UIEdgeInsetsMake(8, 0, 0, 0);
        _tableView.separatorStyle     = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
      
    }
    return _tableView;
}

- (NPKeyboardView *)chatBar
{
    if (!_chatBar)
    {
        _chatBar = [[NPKeyboardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - npToolbarHeight - naviBarHeight, self.view.frame.size.width, npToolbarHeight)];
        [_chatBar setSuperViewHeight:[UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.isTranslucent ? 0 : 64)];
        [_chatBar setSuperViewWidth:SCREEN_WIDTH];
        _chatBar.delegate = self;
    }
    return _chatBar;
}

#pragma mark - KeyboardViewDelegate

- (void)chatBar:(NPKeyboardView *)chatBar sendMessage:(NSString *)message
{

    int a = arc4random() % 100000;

    NSString *str = [NSString stringWithFormat:@"%06d", a];
    
    NPMessageItem *model = [[NPMessageItem alloc]init];
    model.messageType = MessageTypeText;
    model.kid = str;
    model.owner = MessageOwnerSelf;
    model.text = message;
    [self addMessage:model];

}


- (void)chatBar:(NPKeyboardView *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds
{
    
    
//    NSMutableDictionary *voiceMessageDict = [NSMutableDictionary dictionary];
//    voiceMessageDict[kNPMessageConfigurationTypeKey]         = @(MessageTypeVoice);
//    voiceMessageDict[kNPMessageConfigurationOwnerKey]        = @(MessageOwnerSelf);
//    voiceMessageDict[kNPMessageConfigurationNicknameKey]     = kSelfName;
//    voiceMessageDict[kNPMessageConfigurationAvatarKey]       = kSelfThumb;
//    voiceMessageDict[kNPMessageConfigurationVoiceKey]        = voiceFileName;
//    voiceMessageDict[kNPMessageConfigurationVoiceSecondsKey] = @(seconds);
//    [self addMessage:voiceMessageDict];
}

- (void)chatBar:(NPKeyboardView *)chatBar sendPictures:(NSArray *)pictures imageType:(BOOL)isGif
{
//    NSMutableDictionary *imageMessageDict = [NSMutableDictionary dictionary];
//    imageMessageDict[kNPMessageConfigurationTypeKey]     = @(MessageTypeImage);
//    imageMessageDict[kNPMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
//    imageMessageDict[kNPMessageConfigurationImageKey]    = [pictures firstObject];
//    imageMessageDict[kNPMessageConfigurationNicknameKey] = kSelfName;
//    imageMessageDict[kNPMessageConfigurationAvatarKey]   = kSelfThumb;
//    [self addMessage:imageMessageDict];
}

- (void)chatBar:(NPKeyboardView *)chatBar sendVideos:(NSArray *)pictures
{
//    NSMutableDictionary *imageMessageDict = [NSMutableDictionary dictionary];
//    imageMessageDict[kNPMessageConfigurationTypeKey]     = @(MessageTypeVideo);
//    imageMessageDict[kNPMessageConfigurationOwnerKey]    = @(MessageOwnerSelf);
//    imageMessageDict[kNPMessageConfigurationVideoKey]    = [pictures firstObject];
//    imageMessageDict[kNPMessageConfigurationNicknameKey] = kSelfName;
//    imageMessageDict[kNPMessageConfigurationAvatarKey]   = kSelfThumb;
//    [self addMessage:imageMessageDict];
}

- (void)chatBarFrameDidChange:(NPKeyboardView *)chatBar frame:(CGRect)frame
{
    if (frame.origin.y == self.tableView.frame.size.height)
    {
        return;
    }
    
    [UIView animateWithDuration:.3f animations:^
    {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
        {
            make.height.equalTo(@(frame.origin.y-56));
        }];
        
    } completion:nil];
    
    [self scrollTableView];
}


- (void)startRecordVoice
{

}

- (void)cancelRecordVoice
{

}

- (void)endRecordVoice
{

}

- (void)updateCancelRecordVoice
{

}

- (void)updateContinueRecordVoice
{

}

#pragma mark - ChatMessageCellDelegate方法

- (void)messageCellTappedHead:(NPChatMessageTableViewCell *)messageCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    NSLog(@"tapHead :%@",indexPath);
}

- (void)messageCellTappedBlank:(NPChatMessageTableViewCell *)messageCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    NSLog(@"tapBlank :%@",indexPath);
    [self.chatBar endInputing];
}

- (void)messageCellTappedMessage:(NPChatMessageTableViewCell *)messageCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    switch (messageCell.messageType)
    {
        case MessageTypeVoice:
        {
            NSString *voiceFileName = self.messageArray[indexPath.row][kNPMessageConfigurationVoiceKey];
         
            break;
        }
        case MessageTypeImage:
            
       
        case MessageTypeVideo:
        {
            break;
        }
            
        
        default:
            break;
    }
}

- (void)messageCellResend:(NPChatMessageTableViewCell *)messageCell
{

}

- (void)messageCellCancel:(NPChatMessageTableViewCell *)messageCell
{

}

#pragma mark - XMAVAudioPlayerDelegate方法

- (void)audioPlayerStateDidChanged:(NPVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NPChatVoicesTableViewCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    dispatch_async(dispatch_get_main_queue(), ^
    {
//        [voiceMessageCell setVoiceMessageState:audioPlayerState];
    });
}

#pragma mark - 改变状态
- (void)messageReadStateChanged:(NPMessageReadState)readState withProgress:(CGFloat)progress forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NPChatMessageTableViewCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView.visibleCells containsObject:messageCell])
    {
        return;
    }
    messageCell.messageReadState = readState;
}

- (void)messageSendStateChanged:(NPMessageSendState)sendState withProgress:(CGFloat)progress forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NPChatMessageTableViewCell *messageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![self.tableView.visibleCells containsObject:messageCell])
    {
        return;
    }
    
    if ((MessageTypeImage == messageCell.messageType) )
    {
//        [(NPChatImagesTableViewCell *)messageCell setUploadProgress:progress];
    }
    else if (MessageTypeVideo == messageCell.messageType)
    {
//        [(NPChatVideosTableViewCell *)messageCell setUploadProgress:progress];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        messageCell.messageSendState = sendState;
    });
}

- (void)reloadAfterReceiveMessage:(NSDictionary *)message
{
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:.3f animations:^
     {
         [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
          {
              make.height.equalTo(@([[UIScreen mainScreen] bounds].size.height-44 - BottomHeight));
              [self.chatBar endInputing];
          }];
         
     } completion:nil];
}

- (void)addMessage:(NPMessageItem *)message
{
    [self.messageArray addObject:message];
    
    //插入数据库
    [message save];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self sendMessage:message];
}


- (void)sendMessage:(NPMessageItem *)message
{
    //发送消息
    [[NPMessageStateManager shareManager] setMessageSendState:MessageSendSuccess forIndex:[self.messageArray indexOfObject:message]];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//    {
//       CGFloat progress = 0.0f;
//       for (int i=0; i<5; i++)
//       {
//           dispatch_async (dispatch_get_main_queue(), ^
//           {
//               [self messageSendStateChanged:MessageSendStateSending withProgress:progress forIndex:[self.messageArray indexOfObject:message]];
//           });
//           progress += 0.2f;
////           sleep(1);
//       }
//
//       dispatch_async (dispatch_get_main_queue(), ^
//       {
//           [[NPMessageStateManager shareManager] setMessageSendState:MessageSendSuccess forIndex:[self.messageArray indexOfObject:message]];
//           [self messageSendStateChanged:MessageSendSuccess withProgress:1.0f forIndex:[self.messageArray indexOfObject:message]];
//       });
//    });
}

//临时代码，模拟接收消息
- (void)receiveMessage
{
    int messageType = random() % 3;
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
//    if (0 == messageType)
//    {
//        messageDict[kNPMessageConfigurationTextKey] = @"放得开萨拉房间里撒发撒离开飞机撒拉卡萨积分";
//        messageDict[kNPMessageConfigurationTypeKey] = @(MessageTypeText);
//        messageDict[kNPMessageConfigurationOwnerKey] = @(MessageOwnerOther);
//    }
//    else if (1 == messageType)
//    {
//        messageDict[kNPMessageConfigurationImageKey] = [UIImage imageNamed:@"plugins_FriendNotify"];
//        messageDict[kNPMessageConfigurationTypeKey] = @(MessageTypeImage);
//        messageDict[kNPMessageConfigurationOwnerKey] = @(MessageOwnerOther);
//    }
//    else if (2 == messageType)
//    {
//        messageDict[kNPMessageConfigurationTypeKey] = @(MessageTypeDateTime);
//        messageDict[kNPMessageConfigurationTextKey] = @"2016-05-3 13:21:09";
//        messageDict[kNPMessageConfigurationOwnerKey] = @(MessageOwnerSystem);
//    }
//    else if (3 == messageType)
//    {
//        messageDict[kNPMessageConfigurationTypeKey]         = @(MessageTypeVoice);
//        messageDict[kNPMessageConfigurationOwnerKey]        = @(MessageOwnerOther);
//        messageDict[kNPMessageConfigurationVoiceSecondsKey] = @(random()%60);
//    }
    
    int a = arc4random() % 100000;

       NSString *str = [NSString stringWithFormat:@"%06d", a];
       
       NPMessageItem *model = [[NPMessageItem alloc]init];
       model.messageType = MessageTypeText;
       model.kid = str;
       model.owner = MessageOwnerOther;
       model.text = [NSString stringWithFormat:@"%@lalal啦啦啦",str];
       [self addMessage:model];

}


#pragma mark - UITableViewDataSource & UITableViewDelegate方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NPMessageItem *message = self.messageArray[indexPath.row];
    NSString *strIdentifier = [NPChatMessageTableViewCell cellIdentifierForMessageConfiguration:
                               @{kNPMessageConfigurationOwnerKey:@(message.owner),
                                 kNPMessageConfigurationTypeKey:@(message.messageType)}];
    
    NPChatMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    [messageCell configureCellWithData:message];
    messageCell.messageReadState = [[NPMessageStateManager shareManager] messageReadStateForIndex:indexPath.row];
    messageCell.messageSendState = [[NPMessageStateManager shareManager] messageSendStateForIndex:indexPath.row];
    messageCell.delegate = self;
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NPMessageItem *message = self.messageArray[indexPath.row];
    NSString *strIdentifier = [NPChatMessageTableViewCell cellIdentifierForMessageConfiguration:
    @{kNPMessageConfigurationOwnerKey:@(message.owner),
      kNPMessageConfigurationTypeKey:@(message.messageType)}];
    
    return [tableView fd_heightForCellWithIdentifier:strIdentifier cacheByIndexPath:indexPath configuration:^(NPChatMessageTableViewCell *cell)
            {
                [cell configureCellWithData:message];
            }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NPMessageItem *message = self.messageArray[indexPath.row];
    if (message.messageType == MessageTypeVoice)
    {

    }
}


/**
 *  响应快捷菜单
 */
- (void)messageCell:(NPChatMessageTableViewCell *)messageCell withActionType:(NPChatMessageCellMenuActionType)actionType {
    
}


@end

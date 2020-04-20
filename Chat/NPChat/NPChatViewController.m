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
#import "NPChatTextsTableViewCell.h"
#import "NPChatImagesTableViewCell.h"
#import "NPChatVideosTableViewCell.h"
#import "NPChatVoicesTableViewCell.h"
#import "NPDateTimeTableViewCell.h"
#import "NPMessageViewModel.h"
#import <MJRefresh.h>
#import "NPMessageItem.h"
//#import "NPUserManager.h"
#import "NPDBHelper.h"
#import "NPDBTableHelper.h"
//#import "LLRouter.h"
//#import "NPPhotoGroupViewManager.h"
//#import <ydk-audio/YdkAudioPlayer.h>

@interface NPChatViewController ()<UITableViewDelegate,UITableViewDataSource,NPKeyboardViewDelegate,ChatMessageCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView     *backgroundImageView;

@property (strong, nonatomic) NSMutableArray  *messageArray;

@property (strong, nonatomic) NPKeyboardView    *chatBar;

@property (assign, nonatomic) NSInteger  page;//页码

@property (assign, nonatomic) NSInteger  pk;//数据库主键，用来控制加载个数

@property (nonatomic, copy) NSString *saveFilepath;//保存录音文件路径

@property (nonatomic, copy) NSString *saveTime;//保存录音时间

@property (nonatomic, assign) BOOL isPlaying;

//@property(nonatomic, strong) YdkAudioPlayer *player;

@property (nonatomic, strong) NPChatMessageTableViewCell *saveCell;

@end

@implementation NPChatViewController

//RN跳转原生
//+ (void)load {
//
//    [LLRouter registerModuleName:@"NPChatViewController" toHandler:^UIViewController * _Nonnull(UINavigationController * _Nullable navigation, NSString * _Nullable path, NSDictionary * _Nullable routerParameters) {
//
//        NPChatViewController *publish = [[NPChatViewController alloc]init];
//        publish.needOrderId = [routerParameters objectForKey:@"kid"];
//        [UIViewController.currentController pushViewController:publish];
//        return publish;
//    }];
//}

//- (YdkAudioPlayer *)player {
//    if (!_player) {
//        _player = YdkAudioPlayer.new;
//        _player.delegate = self;
//    }
//    return _player;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self bringNavigationBarToFront];
//    self.navigationBar.separatorHidden = YES;
//    self.navigationBar.backgroundColor = self.navigationBar.maskView.backgroundColor = [UIColor colorWithHexString:@"#F6F7FB"];
}


- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationBar.title = @"咨询详情";

    //设置数据库表名
    [NPDBTableHelper shareInstance].tbName = [NSString stringWithFormat:@"NP_%@_%@",self.needOrderId,@"当前登录人用户ID"];
    
    //切换数据库表
    [[NPDBHelper shareInstance] changetable];

    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7FB"];
    
    self.pk = 0;

    _messageArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatBar];

//    SZBarButtonItem *right = [[SZBarButtonItem alloc] initWithTitle:@"收消息" target:self action:@selector(receiveMessage)];
//
//    [right setTitleColor:UIColorHex(FBE017) forState:UIControlStateNormal];
//    right.size = CGSizeMake(TK_TransformPT_W(63), TK_TransformPT_W(24));
//    right.right = self.view.width - TK_TransformPT_W(16);
//    self.navigationBar.rightButtonItem = right;
    
    //加载服务器数据

    self.page = 1;

//    [self loadData];

    [self setHeaderRefresh];
    
}

- (void)setHeaderRefresh {
    __weak __typeof(&*self)weakSelf =self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        weakSelf.page += 1;

        //下拉加载更多
//        [weakSelf loadMore];
    }];
}

/*
//下拉加载历史数据,从数据库中取
- (void)loadMore {

    //2，下拉加载历史数据，获取显示数据第一条kid，拉取服务器20条数据，跟本地数据库进行对比，不同的插入数据库（如果没有不同的，或者不够20条不同的，之后的数据直接获取数据库的显示），从数据库获取20条显示第二屏幕
    
    //获取本地数据显示的第一条
    NSString *versionKid;

    if (self.messageArray.count > 0) {
        //用最后一条数据ID取数据
        NPMessageItem *item = self.messageArray[0];
        versionKid = item.kid;
    }else {
        versionKid = @"";
    }
    
    self.pk += 20;
    self.pk += 1;//多加一条，第二次从11条开始，依次。
    
    NSArray *displayArray = [NPMessageItem findByCriteria:[NSString stringWithFormat:@"where kid < %@ ORDER BY kid DESC LIMIT 20",versionKid]];
    
    if (displayArray.count == 0) {
        [[NPMessageViewModel health_need_order_record_msgs_action_page_history:self.page pageSize:20 kid:self.needOrderId versionKid:versionKid] subscribeNext:^(id  _Nullable x) {
                if ([x isKindOfClass:[NSArray class]]) {
                    //对比去重
                    
                    NSArray *array = x;
                    
                    [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
                          if (array.count == 0) {
                              self.tableView.mj_header = nil;
                          }
                      }];

                    BOOL sucess = [NPMessageItem saveObjects:array];
                    if (sucess) {
                          
                        for (int i = 0; i < array.count; i ++) {

                             id object = array[i];

                             [self.messageArray insertObject:object atIndex:0];
                         }

                         [self.tableView reloadData];
                    }
    
                }
            }];
    }else {
        
        [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
               if (displayArray.count == 0) {
                   self.tableView.mj_header = nil;
               }
        }];
        
       for (int i = 0; i < displayArray.count; i ++) {

          id object = displayArray[i];

          [self.messageArray insertObject:object atIndex:0];
      }

        [self.tableView reloadData];
    }
}

//初次进来加载数据
- (void)loadData {
    
    //1，初次进来，获取数据库最后一条KID，拉取服务器最新20条数据，如果差距大，删掉数据库，再写到数据库，从数据库获取20条数据显示第一屏幕

    //获取最后一条数据
    NSArray *lastArray = [NPMessageItem findByCriteria:@"ORDER BY kid DESC LIMIT 1"];

    NSString *versionKid;
    if (lastArray.count > 0) {
        //用最后一条数据ID取数据
        NPMessageItem *item = lastArray[0];
        versionKid = item.kid;
    }else {
        versionKid = @"";
    }

    //服务器数据
    [[NPMessageViewModel health_need_order_record_msgs_action_page_new:1 pageSize:20 kid:self.needOrderId versionKid:versionKid] subscribeNext:^(id  _Nullable x) {
        
        NSArray *dataList = [NSArray yy_modelArrayWithClass:NPMessageItem.class json:[x objectForKey:@"entities"]];
        
        if ([dataList isKindOfClass:[NSArray class]]) {
            
            NSArray *array = dataList;
            //数据库为空，直接将数据写入数据库中
            if (versionKid.length == 0) {
                //直接写入数据库
                BOOL sucess =  [NPMessageItem saveObjects:array];
                
                if (sucess) {
                    [self getDataDisplay];
                }
            }else{
                //如果相差的条数太多，直接清掉数据库表内容
                if ([[x objectForKey:@"count"]intValue] > 20) {
                    
                    //清空数据库表内容
                    BOOL suc = [NPMessageItem clearTable];
                    
                    if (suc) {
                        BOOL sucess =  [NPMessageItem saveObjects:array];
                        
                        if (sucess) {
                            [self getDataDisplay];
                        }
                    }
                }else {
                    //对比去重
                    //取数据库中的数据，跟服务器数据对比去重
                    NSArray *oldArray = [[[NPMessageItem findByCriteria:[NSString stringWithFormat:@"ORDER BY kid DESC LIMIT %d",20]]reverseObjectEnumerator]allObjects];
                    
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
                       BOOL sucess = [NPMessageItem saveObjects:newArr];
                        
                        if (sucess) {
                            [self getDataDisplay];
                        }
                    }else{
                        //没有重复的，直接从数据库拿数据显示
                        [self getDataDisplay];

                    }
                }
            }
        }
    }];
}

*/

- (void)getDataDisplay {
    //获取数据库中数据进行显示
    NSArray *displayArray = [[[NPMessageItem findByCriteria:[NSString stringWithFormat:@"ORDER BY kid DESC LIMIT %d",20]]reverseObjectEnumerator]allObjects];

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
        make.height.equalTo(@(self.view.frame.size.height - 50 - BottomHeight - naviBarHeight));
    }];

    [self.chatBar mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.tableView.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
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
        _tableView.backgroundColor    = [UIColor colorWithHexString:@"#F6F7FB"];
        _tableView.estimatedRowHeight = 66;
        _tableView.contentInset       = UIEdgeInsetsMake(0, 0, 0, 0);
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
        _chatBar = [[NPKeyboardView alloc] init];
        
        _chatBar.delegate = self;
    }
    return _chatBar;
}

#pragma mark - KeyboardViewDelegate

- (void)chatBar:(NPKeyboardView *)chatBar sendMessage:(NSString *)message
{

    NPMessageItem *model = [[NPMessageItem alloc]init];
    model.owner = MessageOwnerSelf;
    model.body = message;
    model.msgType = @"TEXT";
    model.fromAccount = [NSString stringWithFormat:@"%@",@"用户ID"];
    [self addMessage:model];

}

- (void)chatBar:(NPKeyboardView *)chatBar sendPictures:(NSArray *)pictures imageType:(BOOL)isGif
{
    //先上传OSS

    /*
    if (pictures.count > 0) {
        UIImage *image = pictures[0];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        [[YdkNetwork uploadWithData:imageData fileType:@"image"] subscribeNext:^(YdkUploadInfo * _Nullable x) {
            
            if (x.url) {
                CGSize size = CGSizeFromString([x.ext objectForKey:@"size"]);
                               
                NSString *url = [NSString stringWithFormat:@"%@?w=%.1f&h=%.1f",x.url,size.width,size.height];
                         
                NSMutableDictionary *attach = [NSMutableDictionary dictionary];
                [attach setObject:@"" forKey:@"md5"];
                [attach setObject:[NSString stringWithFormat:@"%f",size.height] forKey:@"h"];
                [attach setObject:[NSString stringWithFormat:@"%f",size.width] forKey:@"w"];
                [attach setObject:@"" forKey:@"size"];
                [attach setObject:@"PICTURE" forKey:@"name"];
                [attach setObject:url forKey:@"url"];
                [attach setObject:@"jpg" forKey:@"ext"];

                NSString *con_attach = [NSString convertToJsonData:attach];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NPMessageItem *model = [[NPMessageItem alloc]init];
                    model.owner = MessageOwnerSelf;
                    model.body = url;
                    model.attach = con_attach;
                    model.msgType = @"PICTURE";
                    model.fromAccount = [NSString stringWithFormat:@"%@",NPUserManager.shared.user.userId];
                    [self addMessage:model];
                    
                });
            }
        } error:^(NSError * _Nullable error) {

        }];
    }
     
     */
}

//发送视频
- (void)chatBar:(NPKeyboardView *)chatBar Message:(NSURL *)videoUrl coverImage:(UIImage *)coverImage duration:(CGFloat)duration
{
    
    __block  NSString *videoUrlString;
    __block  NSString *imageUrl;
    
    NSData *imageData = UIImageJPEGRepresentation(coverImage, 0.9);

    /*
    [[YdkNetwork uploadWithData:imageData fileType:@"image"] subscribeNext:^(YdkUploadInfo * _Nullable x) {
        imageUrl = x.url;
        [self sendVideoMessage:videoUrlString imageUrl:imageUrl];

    }error:^(NSError * _Nullable error) {
                   
    }];
        
    [[YdkNetwork uploadWithFileURL:videoUrl fileType:@"video"] subscribeNext:^(YdkUploadInfo *info) {
        if (info.isCompleted) {

            videoUrlString = info.url;
            
            [self sendVideoMessage:videoUrlString imageUrl:imageUrl];
            
        }
    } error:^(NSError *error) {

    }];
     
     */

}

- (void)sendVideoMessage:(NSString *)videoUrl imageUrl:(NSString *)imageUrl {
    if (videoUrl.length > 0 && imageUrl.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSMutableDictionary *attach = [NSMutableDictionary dictionary];
            [attach setObject:videoUrl?videoUrl:@"" forKey:@"url"];
            [attach setObject:@"" forKey:@"md5"];
            [attach setObject:@"mp4" forKey:@"ext"];
            [attach setObject:@"" forKey:@"h"];
            [attach setObject:@"" forKey:@"w"];
            [attach setObject:@"" forKey:@"size"];
            [attach setObject:@"VIDEO" forKey:@"name"];
            [attach setObject:@"" forKey:@"dur"];
            [attach setObject:imageUrl?imageUrl:@"" forKey:@"thumImage"];

            NSString *con_attach = [NSString convertToJsonData:attach];
            
            NPMessageItem *model = [[NPMessageItem alloc]init];
            model.owner = MessageOwnerSelf;
            model.body = videoUrl;
            model.attach = con_attach;
            model.msgType = @"VIDEO";
            model.fromAccount = [NSString stringWithFormat:@"%@",@"用户ID"];
            [self addMessage:model];
            
        });
    }
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
            make.height.equalTo(@(frame.origin.y));
        }];

    } completion:nil];

    [self scrollTableView];
}


//- (void)startAudio {
//    NPLog(@"开始录音");
//
//    NIMAudioType type = [self recordAudioType];
//    NSTimeInterval duration = 180;
//
//    [[NIMSDK sharedSDK].mediaManager addDelegate:self];
//
//    [[NIMSDK sharedSDK].mediaManager record:type
//                                   duration:duration];
//}//开始录音
//
//- (void)stopAudio{
//    NPLog(@"停止录音");
//    [[NIMSDK sharedSDK].mediaManager stopRecord];
//}//停止录音
//
//- (void)audition{
//    NPLog(@"试听录音");
//       if (self.saveFilepath) {
//           [[NIMSDK sharedSDK].mediaManager play:self.saveFilepath];
//       }else {
//           NPLog(@"录音失败");
//       }
//}//试听录音
//
//- (void)Stopaudition{
//
//}//停止试听录音
//
//- (void)sendAudition:(NSInteger)time{
//
//    NPLog(@"发送录音");
//
//       if ([[NIMSDK sharedSDK].mediaManager isPlaying]) {
//           [[NIMSDK sharedSDK].mediaManager stopPlay];
//       }
//       self.saveTime = [NSString stringWithFormat:@"%ld",time];
//       if (self.saveFilepath) {
//
//           [self uploadImageWithAudio:[NSURL fileURLWithPath:self.saveFilepath isDirectory:NO]];
//
//       }else {
//           NPLog(@"录音失败");
//       }
//
//
//
//}//发送录音
//
//- (void)cancelAction{
//    NPLog(@"取消录音");
//    [[NIMSDK sharedSDK].mediaManager cancelRecord];
//}//取消录音
//
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    if ([[NIMSDK sharedSDK].mediaManager isPlaying]) {
//        [[NIMSDK sharedSDK].mediaManager stopPlay];
//    }
//
//    if ([[NIMSDK sharedSDK].mediaManager isRecording]) {
//        [[NIMSDK sharedSDK].mediaManager stopRecord];
//    }
//}

#pragma mark 录音相关


////当前录音格式 : NIMSDK 支持 aac 和 amr 两种格式
//- (NIMAudioType)recordAudioType
//{
//    NIMAudioType type = NIMAudioTypeAAC;
//    return type;
//}

#pragma mark 上传图片和音频
- (void)uploadImageWithAudio:(NSURL *)url {

//    [[YdkNetwork uploadWithFileURL:url fileType:@"audio"]subscribeNext:^(YdkUploadInfo * _Nullable x) {
//
//        //提交信息
//        if (x.url) {
//            if ([[NIMSDK sharedSDK].mediaManager isPlaying]) {
//                [[NIMSDK sharedSDK].mediaManager stopPlay];
//            }
//            NPLog(@"%@",x.url);
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                NSMutableDictionary *attach = [NSMutableDictionary dictionary];
//                [attach setObject:@"" forKey:@"size"];
//                [attach setObject:@"aac" forKey:@"ext"];
//                [attach setObject:self.saveTime?self.saveTime:@"" forKey:@"dur"];
//                [attach setObject:x.url?x.url:@"" forKey:@"url"];
//                [attach setObject:@"" forKey:@"md5"];
//
//                NSString *con_attach = [NSString convertToJsonData:attach];
//
//                NPMessageItem *model = [[NPMessageItem alloc]init];
//                model.owner = MessageOwnerSelf;
//                model.body = x.url;
//                model.attach = con_attach;
//                model.msgType = @"AUDIO";
//                model.fromAccount = [NSString stringWithFormat:@"%@",NPUserManager.shared.user.userId];
//                [self addMessage:model];
//
//           });
//
//        }
//
//    } error:^(NSError * _Nullable error) {
//        showMessage(@"发送失败");
//    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//#pragma mark - NIMMediaManagerDelegate
//- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
//    if (!filePath || error) {
//
//        [self onRecordFailed:error];
//    }
//}
//
//- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
//    if(!error) {
//        if ([self recordFileCanBeSend:filePath]) {
//
//            self.saveFilepath = filePath;
//
//        }else{
//            [self showRecordFileNotSendReason];
//        }
//    } else {
//        [self onRecordFailed:error];
//    }
//}
//
//- (void)recordAudioDidCancelled {
//
//}
//
//- (void)recordAudioProgress:(NSTimeInterval)currentTime {
//
//}
//
//- (void)recordAudioInterruptionBegin {
//    [[NIMSDK sharedSDK].mediaManager cancelRecord];
//}

#pragma mark - 录音相关接口
- (void)onRecordFailed:(NSError *)error{}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    return YES;
}

- (void)showRecordFileNotSendReason{}


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
    
    [UIView animateWithDuration:.3f animations:^
    {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make)
         {
             make.height.equalTo(@([[UIScreen mainScreen] bounds].size.height - naviBarHeight - 50 - BottomHeight));
             [self.chatBar endInputing];
         }];

    } completion:nil];
    
}

- (void)messageCellTappedMessage:(NPChatMessageTableViewCell *)messageCell
{
    
    self.saveCell = messageCell;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:messageCell];
    switch (messageCell.messageType)
    {
        case MessageTypeVoice:
        {
            NPMessageItem *message = self.messageArray[indexPath.row];
            
            NPChatVoicesTableViewCell *currentCell = (NPChatVoicesTableViewCell *)messageCell;
            
            NSDictionary *dic = [NSDictionary dictionaryWithJsonString:message.attach];

//            [self.player prepareWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]] autoPlay:NO];

            if (self.isPlaying == YES) {
                self.isPlaying = NO;
                currentCell.voiceMessageState = VoiceMessageStateCancel;
//                [self.player stop];
            }else{
                  
                self.isPlaying = YES;
                currentCell.voiceMessageState = VoiceMessageStatePlaying;
//                [self.player play];
           }
            
            break;
        }
        case MessageTypeImage:
        {
            //点击展开图片
           
            NPChatImagesTableViewCell *cell = (NPChatImagesTableViewCell *)messageCell;
            
            NPMessageItem *message = self.messageArray[indexPath.row];

            NSDictionary *dic = [NSDictionary dictionaryWithJsonString:message.attach];
            
            NSArray *imageUrls = @[[dic objectForKey:@"url"]];
//            [NPPhotoGroupViewManager presentFromView:cell.messageImageView toContainer:self.view imageUrls:imageUrls currentIndex:0];
            
        }
            break;

        case MessageTypeVideo:
        {
            NPMessageItem *message = self.messageArray[indexPath.row];

            NPChatVideosTableViewCell *cell = (NPChatVideosTableViewCell *)messageCell;

            NSDictionary *dic = [NSDictionary dictionaryWithJsonString:message.attach];

            NSDictionary *source = @{ @"uri": [dic objectForKey:@"url"]?[dic objectForKey:@"url"]:@"", @"videoCoverImage": cell.thumbnailImageView.image, @"title" : @""  };
//            [LLRouter route:@"LLVideoPlayerController" passProps:@{ @"source" : source} completionHandler:^(NSError *error) {
//
//            }];
            
            break;
        }

        default:
            break;
    }
}


#pragma mark YdkAudioPlayerDelegate

- (void)audioPlayerUpdateProgress:(Float64)progress duration:(Float64)duration playableDuration:(Float64)playableDuration {
//    self.slider.value = progress / duration;
//    self.section.progress = (NSInteger)progress;
//    self.timeLabel.text = [[NSString stringWithFormat:@"%ld", (long)progress] timeFormat];
//    if (progress == duration) {
//        [self next];
//    }
    NSLog(@" ---%lf =-- %lf, ___%lf", progress, duration, playableDuration);
    
}

//- (void)audioPlayerStatusChanged:(YdkAudioPlayerStatus)status {
//
//    if (status == YdkAudioPlayerStatusStop) {
//
//        self.isPlaying = NO;
//        NPChatVoicesTableViewCell *currentCell = (NPChatVoicesTableViewCell *)self.saveCell;
//        currentCell.voiceMessageState = VoiceMessageStateCancel;
//        self.saveCell = nil;
//
//    }
//}

- (void)audioPlayerFailedWithError:(NSError *)error{
    
    
}

- (void)messageCellResend:(NPChatMessageTableViewCell *)messageCell
{
    //重新发送
    
    //保存点击的CELL

    self.saveCell = messageCell;
    
    NPMessageItem *item = messageCell.item;
    
    [self sendMessage:item];
    
}

- (void)messageCellCancel:(NPChatMessageTableViewCell *)messageCell
{

}

#pragma mark - 改变状态

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
    }else {
     
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

- (void)addMessage:(NPMessageItem *)message
{
    [self.messageArray addObject:message];

    //插入数据库
    [message save];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self sendMessage:message];
}

- (void)sendMessage:(NPMessageItem *)message
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:message.attach?message.attach:@"" forKey:@"attach"];
    [dic setObject:message.body?message.body:@"" forKey:@"body"];
    [dic setObject:message.createUserId?message.createUserId:@"" forKey:@"createUserId"];
    [dic setObject:message.delFlag?message.delFlag:@"" forKey:@"delFlag"];
    [dic setObject:message.eventType?message.eventType:@"" forKey:@"eventType"];
    [dic setObject:message.ext?message.ext:@"" forKey:@"ext"];
    [dic setObject:message.fromAccount?message.fromAccount:@"" forKey:@"fromAccount"];
    [dic setObject:message.fromNick?message.fromNick:@"" forKey:@"fromNick"];
    [dic setObject:message.msgTimestamp?message.msgTimestamp:@"" forKey:@"msgTimestamp"];
    [dic setObject:message.msgType?message.msgType:@"" forKey:@"msgType"];
    [dic setObject:message.msgidClient?message.msgidClient:@"" forKey:@"msgidClient"];
    [dic setObject:self.needOrderId?self.needOrderId:@"" forKey:@"needOrderId"];
    [dic setObject:message.toAccount?message.toAccount:@"" forKey:@"toAccount"];
//
//    [[NPMessageViewModel healthNeedOrderRecordMsgsDic:dic]subscribeNext:^(id  _Nullable x) {
//
//        if (x) {
//
//            //更新数据库中的kid
//            message.kid = [NSString stringWithFormat:@"%@",x];
//            [message update];
//
//            //更新发送状态
//            if (self.saveCell) {
//                dispatch_async(dispatch_get_main_queue(), ^
//                   {
//                       [self.saveCell setMessageSendState:MessageSendSuccess];
//                        self.saveCell = nil;
//                   });
//            }else {
//                //更新最新一条发送状态
//
//                [self messageSendStateChanged:MessageSendSuccess withProgress:1 forIndex:self.messageArray.count - 1];
//
//            }
//        }
//
//    }error:^(NSError * _Nullable error) {
//
//    }];
}

//临时代码，模拟接收消息
- (void)receiveMessage
{
    int messageType = random() % 4;

    NPMessageItem *model = [[NPMessageItem alloc]init];

    NSString *con_attach;
    
    if (0 == messageType)
    {
        model.messageType = MessageTypeText;
        model.body = @"放得开萨拉房间里撒发撒离开飞机撒拉卡萨积分";
        model.msgType = @"TEXT";

    }
    else if (1 == messageType)
    {

        model.messageType = MessageTypeImage;
        
        NSMutableDictionary *attach = [NSMutableDictionary dictionary];
        [attach setObject:@"" forKey:@"md5"];
        [attach setObject:[NSString stringWithFormat:@"%f",200.0f] forKey:@"h"];
        [attach setObject:[NSString stringWithFormat:@"%f",300.0f] forKey:@"w"];
        [attach setObject:@"" forKey:@"size"];
        [attach setObject:@"PICTURE" forKey:@"name"];
        [attach setObject:@"https://cdn-test.lajsf.com/nutrition-plan/image/ios/20209223372036854775807/558F95CE-74B1-4BCA-A223-1F269922AB81.jpg?w=224.0&h=398.0" forKey:@"url"];
        [attach setObject:@"jpg" forKey:@"ext"];
        con_attach = [NSString convertToJsonData:attach];
        model.msgType = @"PICTURE";

    }
    else if (2 == messageType)
    {
        model.messageType = MessageTypeVoice;
        
        NSMutableDictionary *attach = [NSMutableDictionary dictionary];
        [attach setObject:@"" forKey:@"size"];
        [attach setObject:@"aac" forKey:@"ext"];
        [attach setObject:@"33.0" forKey:@"dur"];
        [attach setObject:@"https://cdn-test.lajsf.com/nutrition-plan/audio/ios/20209223372036854775807/9A647976-996B-4804-A6DD-DF175A1AC20A.mp3" forKey:@"url"];
        [attach setObject:@"" forKey:@"md5"];

        con_attach = [NSString convertToJsonData:attach];
        model.msgType = @"AUDIO";

    }
    else if (3 == messageType)
    {
        NSMutableDictionary *attach = [NSMutableDictionary dictionary];
       [attach setObject:@"https://cdn-test.lajsf.com/nutrition-plan/video/ios/20209223372036854775807/C3BA4E47-BAB4-4133-9733-820C2EB54665.mp4" forKey:@"url"];
       [attach setObject:@"" forKey:@"md5"];
       [attach setObject:@"mp4" forKey:@"ext"];
       [attach setObject:@"" forKey:@"h"];
       [attach setObject:@"" forKey:@"w"];
       [attach setObject:@"" forKey:@"size"];
       [attach setObject:@"VIDEO" forKey:@"name"];
       [attach setObject:@"" forKey:@"dur"];
       [attach setObject:@"https://cdn-test.lajsf.com/nutrition-plan/image/ios/20209223372036854775807/B4BA18EB-9BF0-4052-B338-F4D7C208004B.jpg" forKey:@"thumImage"];
        
        con_attach = [NSString convertToJsonData:attach];
        
        model.messageType = MessageTypeVideo;
        model.msgType = @"VIDEO";
    }
    
    model.attach = con_attach;
    model.fromAccount = [NSString stringWithFormat:@"%@",@"3242423"];

    [self.messageArray addObject:model];

   //插入数据库
   [model save];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
      
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    messageCell.messageSendState = message.kid.length > 0 ?MessageSendSuccess :MessageSendFail;
    messageCell.delegate = self;
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NPMessageItem *message = self.messageArray[indexPath.row];
    NSString *strIdentifier = [NPChatMessageTableViewCell cellIdentifierForMessageConfiguration:
    @{kNPMessageConfigurationOwnerKey:@(message.owner),
      kNPMessageConfigurationTypeKey:@(message.messageType)}];

    if (message.messageType == MessageTypeImage) {
        return real(180);
    }
    
    if (message.messageType == MessageTypeVideo) {
        return real(200);
    }
    
    CGFloat textHight = [tableView fd_heightForCellWithIdentifier:strIdentifier cacheByIndexPath:indexPath configuration:^(NPChatMessageTableViewCell *cell)
    {
        [cell configureCellWithData:message];
    }];
    
    return textHight;
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

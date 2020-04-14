//
//  ViewController.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ViewController.h"
//#import "NPInputToolBar.h"
//#import "UIView+Extension.h"
//#import "NPMessageViewModel.h"
//#import "ReciveMsgCell.h"
//#import "SendMsgCell.h"
//#import <MJRefresh.h>
#import "NPChatViewController.h"

//static NSString *const kCellID0 = @"ReciveCell";
//static NSString *const kCellID1 = @"SendCell";

@interface ViewController ()

//<NPMoreButtonViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate, UITableViewDataSource>
//
//@property (nonatomic, strong)NPInputToolBar *inputToolbar;
//
//@property (nonatomic, assign)CGFloat inputToolbarY;
//
//@property (nonatomic, strong) NSMutableArray *msgMuArray;//数据内容
//
//@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(190, 90, 90, 90);
    [button2 setTitle:@"聊天" forState:UIControlStateNormal];
    button2.backgroundColor = UIColor.orangeColor;
    [button2 addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: button2];
    
}

- (void)buttonAction2 {
    NPChatViewController *chat = [[NPChatViewController alloc]init];
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)buttonAction {

}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self loadTable];
//
//    //聊天工具栏
//    [self _initToolbar];
//
//    //加载服务器数据
//    [self loadData];
//
//}
//
//- (void)loadTable {
//
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BottomHeight - 50 - NavigationHeight) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//
//    self.tableView.estimatedRowHeight = 52;
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReciveMsgCell class]) bundle:nil] forCellReuseIdentifier:kCellID0];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SendMsgCell class]) bundle:nil] forCellReuseIdentifier:kCellID1];
//    [self setHeaderRefresh];
//
//}
//
//- (void)setHeaderRefresh {
//    __weak __typeof(&*self)weakSelf =self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSMutableArray *muArr = [[NPMessageViewModel new] loadDetailMessages];
//            if (muArr.count > 0) {
//                [weakSelf.msgMuArray addObjectsFromArray:muArr];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.tableView reloadData];
//                    NSIndexPath *path = [NSIndexPath indexPathForRow:muArr.count inSection:0];
//                    [weakSelf.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                    [weakSelf.tableView.mj_header endRefreshing];
//                    weakSelf.tableView.mj_header = nil;
//                });
//            } else {
//                [weakSelf.tableView.mj_header endRefreshing];
//                weakSelf.tableView.mj_header = nil;
//            }
//        });
//    }];
//}
//
////加载数据
//- (void)loadData {
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        self.msgMuArray = [[NPMessageViewModel new] loadDetailMessages];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//            NSIndexPath *path = [NSIndexPath indexPathForRow:self.msgMuArray.count - 1 inSection:0];
//            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        });
//    });
//}
//
////数据
//- (NSMutableArray *)msgMuArray {
//    if (_msgMuArray == nil) {
//        _msgMuArray = [NSMutableArray array];
//    }
//    return _msgMuArray;
//}
//
//- (void)_initToolbar {
//    self.inputToolbar = [NPInputToolBar shareInstance];
//        [self.view addSubview:self.inputToolbar];
//        self.inputToolbar.textViewMaxVisibleLine = 4;
//        self.inputToolbar.width = self.view.width;
//        self.inputToolbar.height = 50;
//        self.inputToolbar.y = self.view.height - self.inputToolbar.height - BottomHeight;
//        [self.inputToolbar setMorebuttonViewDelegate:self];
//
//        __weak typeof(self) weakSelf = self;
//        self.inputToolbar.sendContent = ^(NSObject *content){
//            NSLog(@"上传服务器内容☀️:---%@",(NSString *)content);
//    //        weakSelf.textView.text = (NSString *)content;
//            [weakSelf sendMessage:(NSString *)content autoAnswer:YES];
//        };
//
//        self.inputToolbar.inputToolbarFrameChange = ^(CGFloat height,CGFloat orignY){
//            weakSelf.inputToolbarY = orignY;
//
//            if (weakSelf.tableView.contentSize.height > orignY) {
//
//                [weakSelf.tableView setContentOffset:CGPointMake(0, weakSelf.tableView.contentSize.height - orignY + BottomHeight + 50) animated:YES];
//            }
//
//        };
//        [self.inputToolbar resetInputToolbar];
//}
//
////发送内容
//- (void)sendMessage:(NSString *)text autoAnswer:(BOOL)autoAnswer{
//    NPMessageItem *msgItem = [NPMessageItem new];
//    msgItem.message = text;
//    if (autoAnswer) {
//        msgItem.userId = [NSString stringWithFormat:@"%d",0];
//    } else {
//        msgItem.userId = @"1";
//    }
//    [self.msgMuArray insertObject:msgItem atIndex:0];
//
//    [self.tableView beginUpdates];
//       [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.msgMuArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//       [self.tableView endUpdates];
//       [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgMuArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//
//
//    //调整table位置
//    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - _inputToolbarY + BottomHeight + 50) animated:NO];
//
//
////    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        NSIndexPath *path = [NSIndexPath indexPathForRow:self.msgMuArray.count - 1 inSection:0];
////        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
////        if (autoAnswer) {
////            [self sendMessage:text autoAnswer:NO];
////        }
////    });
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.msgMuArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NPMessageItem *msgItem = self.msgMuArray[self.msgMuArray.count - indexPath.row - 1];
//    if ([msgItem.userId integerValue] == 0) {
//        SendMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID1 forIndexPath:indexPath];
//        [cell setContentMsg:msgItem];
//        return cell;
//    } else {
//        ReciveMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID0 forIndexPath:indexPath];
//        [cell setContentMsg:msgItem];
//        [cell setHeadImg:@"plugins_FriendNotify"];
//        return cell;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//// 开始拖拽
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    self.inputToolbar.isBecomeFirstResponder = NO;
//}
//
//
//- (void)dealloc {
//    NSLog(@"dealloc");
//}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    self.inputToolbar.isBecomeFirstResponder = NO;
//}
//
//- (void)moreButtonView:(NPMoreButtonView *)moreButtonView didClickButton:(NPMoreButtonViewButtonType)buttonType
//{
//    switch (buttonType) {
//        case MoreButtonViewButtonTypeImages:
//        {
//            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            ipc.delegate = self;
//            [self presentViewController:ipc animated:YES completion:nil];
//        } break;
//
//        case MoreButtonViewButtonTypeCamera:
//        {
//            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//            ipc.delegate = self;
//            [self presentViewController:ipc animated:YES completion:nil];
//        } break;
//
//        default:
//            break;
//    }
//}
//
//- (void)inputToolbar:(NPInputToolBar *)inputToolbar orignY:(CGFloat)orignY
//{
//    _inputToolbarY = orignY;
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    //UIImage *image = info[UIImagePickerControllerOriginalImage];
//    //图片选取成功
//}



@end

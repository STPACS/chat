


//
//  NPHomeViewController.m
//  LCChat
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPHomeViewController.h"
#import "NPSessionChatViewController.h"

@interface NPHomeViewController ()

@property (nonatomic,assign) BOOL supportsForceTouch;

@property (nonatomic,strong) NSMutableDictionary *previews;

@end

@implementation NPHomeViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _previews = [[NSMutableDictionary alloc] init];
      
    }
    return self;
}

- (void)dealloc{

}


- (void)viewDidLoad{
    [super viewDidLoad];
    

    self.emptyTipLabel = [[UILabel alloc] init];
    self.emptyTipLabel.text = @"还没有会话，在通讯录中找个人聊聊吧".ntes_localized;
    [self.emptyTipLabel sizeToFit];
    self.emptyTipLabel.hidden = self.recentSessions.count;
    self.emptyTipLabel.numberOfLines = 0;
    [self.view addSubview:self.emptyTipLabel];
    
    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    self.navigationItem.titleView  = [self titleView:userID];
    self.definesPresentationContext = YES;
    [self setUpNavItem];
}

- (void)setUpNavItem{

}

- (void)refresh{
    [super refresh];
    self.emptyTipLabel.hidden = self.recentSessions.count;
}


- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    
    
    NPSessionChatViewController *vc = [[NPSessionChatViewController alloc] initWithSession:recent.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSelectedAvatar:(NIMRecentSession *)recent
             atIndexPath:(NSIndexPath *)indexPath{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
     
    }
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}

- (void)onTopRecentAtIndexPath:(NIMRecentSession *)recent
                   atIndexPath:(NSIndexPath *)indexPath
                         isTop:(BOOL)isTop
{

}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self refreshSubview];
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑".ntes_localized;
    }
    return [super nameForRecentSession:recent];
}

- (NSMutableArray *)customSortRecents:(NSMutableArray *)recentSessions
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:recentSessions];
    [array sortUsingComparator:^NSComparisonResult(NIMRecentSession *obj1, NIMRecentSession *obj2) {
        NSInteger score1 =  0;
        NSInteger score2 =  0;
        if (obj1.lastMessage.timestamp > obj2.lastMessage.timestamp)
        {
            score1 += 1;
        }
        else if (obj1.lastMessage.timestamp < obj2.lastMessage.timestamp)
        {
            score2 += 1;
        }
        if (score1 == score2)
        {
            return NSOrderedSame;
        }
        return score1 > score2? NSOrderedAscending : NSOrderedDescending;
    }];
    return array;
}

//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)context viewControllerForLocation:(CGPoint)point {
//    UITableViewCell *touchCell = (UITableViewCell *)context.sourceView;
//    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        NTESSessionPeekNavigationViewController *nav = [NTESSessionPeekNavigationViewController instance:recent.session];
//        return nav;
//    }
//    return nil;
//}

//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
//{
//    UITableViewCell *touchCell = (UITableViewCell *)previewingContext.sourceView;
//    if ([touchCell isKindOfClass:[UITableViewCell class]]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:touchCell];
//        NIMRecentSession *recent = self.recentSessions[indexPath.row];
//        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:recent.session];
//        [self.navigationController showViewController:vc sender:nil];
//    }
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除".ntes_localized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NIMRecentSession *recentSession = weakSelf.recentSessions[indexPath.row];
        [weakSelf onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
        [tableView setEditing:NO animated:YES];
    }];
    
   
    return @[delete];
}

#pragma mark - NIMEventSubscribeManagerDelegate


#pragma mark - Private

- (void)refreshSubview{
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
  
    self.tableView.height = self.view.height - self.tableView.top;
    
    self.emptyTipLabel.centerX = self.view.width * .5f;
    self.emptyTipLabel.centerY = self.tableView.height * .5f;
    self.emptyTipLabel.width = self.emptyTipLabel.width < self.view.width ? self.emptyTipLabel.width : self.view.width - 5;
    CGSize size = [self.emptyTipLabel sizeThatFits:CGSizeMake(self.emptyTipLabel.width, CGFLOAT_MAX)];
    self.emptyTipLabel.height = size.height;
}

- (UIView*)titleView:(NSString*)userID{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text =  @"聊天列表";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [self.titleLabel sizeToFit];
    UILabel *subLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    subLabel.textColor = [UIColor grayColor];
    subLabel.font = [UIFont systemFontOfSize:12.f];
    subLabel.text = userID;
    subLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [subLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width  = subLabel.width;
    titleView.height = self.titleLabel.height + subLabel.height;
    
    subLabel.bottom = titleView.height;
    [titleView addSubview:self.titleLabel];
    [titleView addSubview:subLabel];
    return titleView;
}


@end

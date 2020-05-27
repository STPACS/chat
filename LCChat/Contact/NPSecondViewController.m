
//
//  NPSecondViewController.m
//  LCChat
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSecondViewController.h"
#import "UIView+NTES.h"
#import "NTESGroupedContacts.h"
#import "NTESContactUtilItem.h"
#import "NTESContactUtilCell.h"
#import "NTESContactDataCell.h"

static const NSString *contactCellUtilIcon   = @"icon";
static const NSString *contactCellUtilVC     = @"vc";
static const NSString *contactCellUtilBadge  = @"badge";
static const NSString *contactCellUtilTitle  = @"title";
static const NSString *contactCellUtilUid    = @"uid";
static const NSString *contactCellUtilSelectorName = @"selName";

@interface NPSecondViewController ()
{
    NTESGroupedContacts *_contacts;
}

@end

@implementation NPSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.definesPresentationContext = YES;//保证搜索结果页可以正常推出
    
    [self prepareData];

    // Do any additional setup after loading the view.
}

- (void)prepareData{

    _contacts = [[NTESGroupedContacts alloc] init];

    self.navigationItem.title = @"通讯录".ntes_localized;

    
    NSArray *utils = [self groupAbove];
    //构造显示的数据模型
    NTESContactUtilItem *contactUtil = [[NTESContactUtilItem alloc] init];
    NSMutableArray * members = [[NSMutableArray alloc] init];
    for (NSDictionary *item in utils) {
        NTESContactUtilMember *utilItem = [[NTESContactUtilMember alloc] init];
        utilItem.nick              = item[contactCellUtilTitle];
        utilItem.icon              = [UIImage imageNamed:item[contactCellUtilIcon]];
        utilItem.vcName            = item[contactCellUtilVC];
        utilItem.badge             = [item[contactCellUtilBadge] stringValue];
        utilItem.userId            = item[contactCellUtilUid];
        utilItem.selName           = item[contactCellUtilSelectorName];
        [members addObject:utilItem];
    }
    contactUtil.members = members;
    
    [_contacts addGroupAboveWithTitle:@"" members:contactUtil.members];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    if (@available(iOS 11.0, *)) {
        CGFloat height = self.view.safeAreaInsets.bottom;
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - height);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        UIEdgeInsets separatorInset   = self.tableView.separatorInset;
        separatorInset.right          = 0;
        _tableView.separatorInset = separatorInset;
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)groupAbove
{
    //原始数据
    NSInteger systemCount = 0;
    NSMutableArray *utils =
    [@[
       @{
           contactCellUtilIcon:@"icon_notification_normal",
           contactCellUtilTitle:@"验证消息".ntes_localized,
           contactCellUtilVC:@"NTESSystemNotificationViewController",
           contactCellUtilBadge:@(systemCount)
           },
      
       ] mutableCopy];
    return utils;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    return contactItem.uiHeight;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_contacts memberCountOfGroup:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_contacts groupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id contactItem = [_contacts memberOfIndex:indexPath];
    NSString * cellId = [contactItem reuseId];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        Class cellClazz = NSClassFromString([contactItem cellName]);
        cell = [[cellClazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([contactItem showAccessoryView]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
  if ([cell isKindOfClass:[NTESContactUtilCell class]]) {
      [(NTESContactUtilCell *)cell refreshWithContactItem:contactItem];
//      [(NTESContactUtilCell *)cell setDelegate:self];
  }else{
      [(NTESContactDataCell *)cell refreshUser:contactItem];
//      [(NTESContactDataCell *)cell setDelegate:self];
  }
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_contacts titleOfGroup:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _contacts.sortedGroupTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index + 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NTESContactItem> contactItem = (id<NTESContactItem>)[_contacts memberOfIndex:indexPath];
    return [contactItem userId].length;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除好友".ntes_localized message:@"删除好友后，将同时解除双方的好友关系".ntes_localized delegate:nil cancelButtonTitle:@"取消".ntes_localized otherButtonTitles:@"确定".ntes_localized, nil];
        [alert show ];
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

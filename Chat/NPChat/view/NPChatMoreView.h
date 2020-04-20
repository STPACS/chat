//
//  NPChatMoreView.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPChatMoreItem.h"


typedef NS_ENUM(NSUInteger, ChatMoreItemType)
{
    ChatMoreItemImage = 0, /**< 显示拍照 */
    ChatMoreItemImageAlbum,/**< 显示相册 */
    ChatMoreItemVideoAlbum,/**< 显示视频相册 */
    ChatMoreItemLocation,  /**< 显示地理位置 */
    ChatMoreVoiceCall,     /**< 音频呼叫 */
    ChatMoreVideoCall,     /**< 视频呼叫 */
    ChatMoreFile,          /**< 文件转发 */
};


@protocol ChatMoreViewDataSource;
@protocol ChatMoreViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface NPChatMoreView : UIView


@property (weak, nonatomic) id<ChatMoreViewDelegate>   delegate;
@property (weak, nonatomic) id<ChatMoreViewDataSource> dataSource;

@property (assign, nonatomic) NSUInteger   numberPerLine;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

- (void)reloadData;

@end

@protocol ChatMoreViewDelegate <NSObject>

@optional
/**
 *  moreView选中的index
 *
 *  @param moreView 对应的moreView
 */
- (void)moreView:(NPChatMoreView *)moreView selectIndex:(ChatMoreItemType)itemType;

@end

@protocol ChatMoreViewDataSource <NSObject>

@required
/**
 *  获取数组中一共有多少个titles
 *
 *
 *  @return titles
 */

- (NSArray *)titlesOfMoreView:(NPChatMoreView *)moreView;

/**
 *  获取moreView展示的所有图片
 *
 *
 *  @return imageNames
 */
- (NSArray *)imageNamesOfMoreView:(NPChatMoreView *)moreView;

@end

NS_ASSUME_NONNULL_END

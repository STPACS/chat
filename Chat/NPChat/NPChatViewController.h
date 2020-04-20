//
//  NPChatViewController.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPChatViewController : UIViewController

@property (copy, nonatomic) NSString *strChatterName;

@property (copy, nonatomic) NSString *strChatterThumb;

@property (copy, nonatomic) NSString *needOrderId;

/*
 文本抄送示例：
 {"attach":"","body":"文字消息","convType":"PERSON","eventType":"1","fromAccount":"zhangsan","fromClientType":"IOS","fromDeviceId":"B0BFF2EB-E2E1-4063-9E73-92FB926BF388","fromNick":"zhangsan","msgTimestamp":"1456888017105","msgType":"TEXT","msgidClient":"f33f0716-6027-47de-a582-37a8dc2d217c","msgidServer":"8364607","resendFlag":"0","to":"lisi","yidunRes":"{\"yidunBusType\":0,\"action\":0,\"labels\":[]}"}
 **/

/*
 图片消息抄送示例：
 {"attach":"{\"md5\":\"d0323f8d447abf3df7256bd66f9d5b62\",\"h\":500,\"ext\":\"jpg\",\"size\":9093,\"w\":500,\"name\":\"图片发送于2016-03-02 11:09\",\"url\":\"http:\\/\\/b12026.nos.netease.com\\/MTAxMTAxMA==\\/bmltYV8xNDI5MTVfMTQ1NTY4NzIxMDkyOF8wOWE1ZmVlMS1lOGQ4LTQwMzItOGZkMS0yMWE1ODBjYjA1MWE=\"}","body":"","convType":"PERSON","eventType":"1","fromAccount":"zhangsan","fromClientType":"IOS","fromDeviceId":"B0BFF2EB-E2E1-4063-9E73-92FB926BF388","fromNick":"zhangsan","msgTimestamp":"1456888195062","msgType":"PICTURE","msgidClient":"472f2f50-2b00-4d7b-8b8d-d8870daa0dbd","msgidServer":"8364613","resendFlag":"0","to":"lisi","yidunRes":"{\"yidunBusType\":1,\"labels\":[{\"level\":0,\"rate\":0.0,\"label\":100},{\"level\":0,\"rate\":0.0,\"label\":200},{\"level\":0,\"rate\":0.0,\"label\":110},{\"level\":0,\"rate\":0.0,\"label\":400},{\"level\":0,\"rate\":0.0,\"label\":300},{\"level\":0,\"rate\":0.0,\"label\":210}]}"}

 attach字段释义：
 {
   "md5":"xxxxxxxx",      //图片的md5值
   "h":500,               //图片的高
   "w":500,               //图片的宽
   "size":9093,           //图片的大小
   "name":"xxxxxxxx",     //图片的名称
   "url":"xxxxxxxx",      //图片的url
   "ext":"jpg"            //图片格式
 }
 **/

/**
 音频抄送示例：
 {"attach":"{\"size\":14181,\"ext\":\"aac\",\"dur\":3900,\"url\":\"http:\\/\\/b12026.nos.netease.com\\/MTAxMTAxMA==\\/bmltYV8xNDI5MTVfMTQ1NTY4NzIxMDkyN18xYjRlOTc4My0zYzFkLTQ5NzUtOTY2NC1hOTkzMzAzOGZiZjc=\",\"md5\":\"4c5cc81dd00817b548b5eef42eac4d11\"}","body":"发来了一段语音","convType":"PERSON","eventType":"1","fromAccount":"zhangsan","fromClientType":"IOS","fromDeviceId":"B0BFF2EB-E2E1-4063-9E73-92FB926BF388","fromNick":"zhangsan","msgTimestamp":"1456888940830","msgType":"AUDIO","msgidClient":"b0b703ea-3e10-453e-8650-e3a2802130bd","msgidServer":"8364635","resendFlag":"0","to":"lisi"}

 attach字段释义：
 {
   "size":14181,          //音频的大小
   "ext":"aac",           //音频的格式
   "dur":3900,            //音频的时长
   "url":"xxxxxxxx",      //音频的url
   "md5":"xxxxxxxx"       //音频的md5值
 }
 
 */

/**
 视频抄送示例：
 {"attach":"{\"url\":\"http:\\/\\/b12026.nos.netease.com\\/MTAxMTAxMA==\\/bmltYV8xNDI5MTVfMTQ1NTY4NzIxMDkyN18xZGNkMjQzNi02OTg2LTQxNGEtYWE5ZC04ZDhmYjQyMTE2OTQ=\",\"md5\":\"c2f2e15af1c9e341187f81e5f8453399\",\"ext\":\"mp4\",\"h\":480,\"size\":114347,\"w\":360,\"name\":\"视频发送于2016-03-02 11:16\",\"dur\":1456}","body":"","convType":"PERSON","eventType":"1","fromAccount":"zhangsan","fromClientType":"IOS","fromDeviceId":"B0BFF2EB-E2E1-4063-9E73-92FB926BF388","fromNick":"zhangsan","msgTimestamp":"1456888595916","msgType":"VIDEO","msgidClient":"57a33622-cd80-4c65-b8d3-15f3c2bb128f","msgidServer":"8364616","resendFlag":"0","to":"lisi"}

 attach字段释义：
 {
   "url":"xxxxxxxx",      //视频的url
   "md5":"xxxxxxxx",      //视频的md5值
   "ext":"mp4",           //视频的格式
   "h":"480",             //视频的高
   "w":"360",             //视频的宽
   "size":14181,          //视频的大小
   "name":"xxxxxxxx",     //视频的名称
   "dur":1456             //视频的时长
 }
 */

/**
 自定义抄送示例：
 {"attach":"{"myKey1":\"myValue1\",\"myKey2\":2}","body":"","convType":"PERSON","eventType":"1","fromAccount":"zhangsan","fromClientType":"REST","fromDeviceId":"","fromNick":"zhangsan","msgTimestamp":"1456898248757","msgType":"CUSTOM","msgidClient":"1f929f45-1b5e-495e-b76c-465a4187be52","msgidServer":"8364702","resendFlag":"0","to":"lisi"}

 
 */

@end

NS_ASSUME_NONNULL_END

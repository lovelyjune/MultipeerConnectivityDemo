//
//  BluetoothManager.h
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//
//  1 新建方新建房间
//  1 加入方加入房间
//  2 自动进行连接
//  3 开始连接
//  4 连接成功
//  5 其中一方发送数据
//  6 另一方接受数据
//
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BluetoothCreateSideHelper.h"
#import "BluetoothJoinSideHelper.h"
#import "BluetoothOneSideDelegate.h"

typedef enum : NSUInteger
{
    StateNotConnected = 100,
    StateConnecting = 101,
    StateConnected = 102
} LinkStatus;

@protocol BluetoothDelegate <NSObject>

//step 2 连接状态改变（成功，中断，失败）
-(void)linkStatusHasChange:(LinkStatus)linkStatus andIsCreateSide:(Boolean)isCreate;

//step 4 接受数据
-(void)receiveData:(NSData*)data andIsCreateSide:(Boolean)isCreate;

@end


@interface BluetoothManager : NSObject<BluetoothOneSideDelegate>

+ (BluetoothManager *)manager;

@property(nonatomic,weak) id<BluetoothDelegate> delegate;


//step 1
-(void)createRoom;

//step 1
-(void)joinRoom;

//step 3 发送数据
-(void)sendDataBlock:(NSData*)data andError:(void(^)(NSError*error))errorBlock;

//step 5 断开连接
-(void)disconnect;

@end

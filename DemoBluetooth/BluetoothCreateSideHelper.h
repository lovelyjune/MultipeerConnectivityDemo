//
//  BluetoothCreateSideHelper.h
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BluetoothOneSideDelegate.h"

//@protocol CreateSideDelegate <NSObject>
//
//-(void)createSideLinkStatusHasChange:(MCSessionState)linkStatus;
//
//-(void)createSideDidReceiveData:(NSData *)data;
//
//@end

@interface BluetoothCreateSideHelper : NSObject<MCSessionDelegate,MCNearbyServiceAdvertiserDelegate>

@property(nonatomic,weak) id<BluetoothOneSideDelegate> delegate;

- (instancetype)initWithSession:(MCSession*)session;

-(void)sendDataBlock:(NSData*)data andError:(void(^)(NSError*error))errorBlock;

@end

//
//  BluetoothJoinSideDelegate.h
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BluetoothOneSideDelegate.h"




@interface BluetoothJoinSideHelper : NSObject<MCSessionDelegate,MCNearbyServiceBrowserDelegate>

@property(nonatomic,weak) id<BluetoothOneSideDelegate> delegate;

- (instancetype)initWithSession:(MCSession*)session;

-(void)sendDataBlock:(NSData*)data andError:(void(^)(NSError*error))errorBlock;

@end

//
//  BluetoothOneSideDelegate.h
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/6/2.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BluetoothOneSideDelegate <NSObject>

-(void)oneSideLinkStatusHasChange:(MCSessionState)linkStatus;

-(void)oneSideDidReceiveData:(NSData *)data;

@end

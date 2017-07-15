//
//  BluetoothJoinSideDelegate.m
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import "BluetoothJoinSideHelper.h"

@interface BluetoothJoinSideHelper()
@property(nonatomic,strong) MCSession * session;
@end

@implementation BluetoothJoinSideHelper

- (instancetype)initWithSession:(MCSession*)session
{
    self = [super init];
    if (self)
    {
        self.session = session;
    }
    return self;
}

//MCNearbyServiceBrowser 代理方法
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    NSLog(@"搜索到的peerID======%@，申请加入",peerID);
    //自动发送加入请求，等待新建方允许,超时100秒
    //自动加入搜索的第一个设备
    [browser invitePeer:peerID toSession:self.session withContext:nil timeout:100.0];
}

//断开连接的设备
-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"与以下设备断开了连接=====%@",peerID);
}

//连接错误
-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"连接错误====%@",error);
}


// MCSession 代理方法
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate oneSideLinkStatusHasChange:state];
    });
}

//接收数据
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate oneSideDidReceiveData:data];
    });
}

//发送数据
-(void)sendDataBlock:(NSData*)data andError:(void(^)(NSError*error))errorBlock
{
    NSError * error = nil;
    [self.session sendData:data toPeers:[self.session connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    
    if(errorBlock && error) errorBlock(error);       //处理错误
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    
}


- (void)dealloc
{
    NSLog(@"BluetoothJoinSideDelegate---dealooc");
}

@end

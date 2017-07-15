//
//  BluetoothCreateSideHelper.m
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import "BluetoothCreateSideHelper.h"

@interface BluetoothCreateSideHelper()
@property(nonatomic,strong) MCSession * session;

@end

@implementation BluetoothCreateSideHelper

- (instancetype)initWithSession:(MCSession*)session
{
    self = [super init];
    if (self)
    {
        self.session = session;
    }
    return self;
}

//MCNearbyServiceAdvertiser 代理方法
//收到加入的请求
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler
{
    NSLog(@"用来接收要求的ad======%@",advertiser);
    NSLog(@"从哪里peerid过来======%@",peerID);
    NSLog(@"数据内容=====%@",context);
    invitationHandler(YES,self.session);        //自动允许对方加入
    NSLog(@"接收要求，开始会话");
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
    NSLog(@"BluetoothCreateSideHelper---dealooc");
}

@end

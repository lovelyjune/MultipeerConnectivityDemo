//
//  BluetoothManager.m
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import "BluetoothManager.h"

@interface BluetoothManager()

@property(nonatomic,strong)NSString * serviceType;
@property(nonatomic,assign)BOOL isCreateSide;

@property(nonatomic,strong) MCNearbyServiceAdvertiser * createAdvertiser;
@property(nonatomic,strong) BluetoothCreateSideHelper * createHelper;

@property(nonatomic,strong) MCNearbyServiceBrowser * joinAdvertiser;
@property(nonatomic,strong) BluetoothJoinSideHelper * joinHelper;

@end


@implementation BluetoothManager

static BluetoothManager *_dataCenter = nil;
+ (BluetoothManager *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataCenter = [[BluetoothManager alloc] init];
        
    });
    return _dataCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.serviceType = @"blue-stream";
    }
    return self;
}

//step1 新建房间
-(void)createRoom
{
    NSLog(@"新建方的设备名字====%@",[[UIDevice currentDevice] name]);
    
    [self destroyJoin];     //销毁加入方
    
    MCPeerID * peerID = [[MCPeerID alloc]initWithDisplayName:[[UIDevice currentDevice] name]];
    MCSession * session = [[MCSession alloc]initWithPeer:peerID];
    self.createHelper = [[BluetoothCreateSideHelper alloc]initWithSession:session];
    session.delegate = self.createHelper;
    
    self.createAdvertiser = [[MCNearbyServiceAdvertiser alloc]initWithPeer:peerID discoveryInfo:nil serviceType:self.serviceType];
    self.createAdvertiser.delegate = self.createHelper;
    [self.createAdvertiser startAdvertisingPeer];        //开始发布广播
    
    self.createHelper.delegate = self;
    self.isCreateSide = true;
    
    NSLog(@"新建房间，开始广播.....");
}


//step1 加入房间
-(void)joinRoom
{
    [self destroyCreate];       //销毁新建方
    
    MCPeerID * peerID = [[MCPeerID alloc]initWithDisplayName:[[UIDevice currentDevice] name]];
    
    NSLog(@"加入方的设备名字====%@",[[UIDevice currentDevice] name]);
    
    MCSession * session = [[MCSession alloc]initWithPeer:peerID];
    self.joinHelper = [[BluetoothJoinSideHelper alloc]initWithSession:session];
    session.delegate = self.joinHelper;
    
    self.joinAdvertiser = [[MCNearbyServiceBrowser alloc]initWithPeer:peerID serviceType:self.serviceType];
    self.joinAdvertiser.delegate = self.joinHelper;
    [self.joinAdvertiser startBrowsingForPeers];
    NSLog(@"开始搜索房间......");
    
    self.joinHelper.delegate = self;
    self.isCreateSide = false;
}

//step 2 连接状态改变（成功，中断，失败）
-(void)oneSideLinkStatusHasChange:(MCSessionState)linkStatus
{
    switch (linkStatus)
    {
        case MCSessionStateNotConnected:
            [self.delegate linkStatusHasChange:StateNotConnected andIsCreateSide:self.isCreateSide];
            break;
        case MCSessionStateConnecting:
            [self.delegate linkStatusHasChange:StateConnecting andIsCreateSide:self.isCreateSide];
            break;
        case MCSessionStateConnected:
            [self.delegate linkStatusHasChange:StateConnected andIsCreateSide:self.isCreateSide];
            break;
        default:
            break;
    }
}

//step 3 发送数据
-(void)sendDataBlock:(NSData*)data andError:(void(^)(NSError*error))errorBlock
{
    if(self.isCreateSide == true)
    {
        [self.createHelper sendDataBlock:data andError:errorBlock];
    }
    else
    {
        [self.joinHelper sendDataBlock:data andError:errorBlock];
    }
}

//step 4 接受到数据
-(void)oneSideDidReceiveData:(NSData *)data
{
    [self.delegate receiveData:data andIsCreateSide:self.isCreateSide];
}


//断开连接
-(void)disconnect
{
    if(self.isCreateSide) [self destroyCreate];
    else [self destroyJoin];
}

-(void)destroyCreate
{
    self.createHelper.delegate = nil;
    self.createHelper = nil;
    [self.createAdvertiser stopAdvertisingPeer];
    self.createAdvertiser.delegate = nil;
    self.createAdvertiser = nil;
    NSLog(@"销毁新建方");
}

-(void)destroyJoin
{
    self.joinHelper.delegate = nil;
    self.joinHelper = nil;
    [self.joinAdvertiser stopBrowsingForPeers];
    self.joinAdvertiser.delegate = nil;
    self.joinAdvertiser = nil;
    NSLog(@"销毁加入方");
}



@end

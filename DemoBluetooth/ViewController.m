//
//  ViewController.m
//  DemoBluetooth
//
//  Created by yingxin ye on 2017/5/20.
//  Copyright © 2017年 yingxin ye. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self initView];
}

-(void)initData
{
    [BluetoothManager manager].delegate = self;
}

-(void)initView
{
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createBtn.frame = CGRectMake(0,20, 90, 35);
    [createBtn setTitle:@"新建" forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    UIButton * joinBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    joinBtn.frame = CGRectMake(0,100, 90, 35);
    [joinBtn setTitle:@"加入" forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
    
    UIButton * sendBTn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBTn.frame = CGRectMake(0,200, 90, 35);
    [sendBTn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBTn addTarget:self action:@selector(sendHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBTn];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeBtn.frame = CGRectMake(0,300, 90, 35);
    [closeBtn setTitle:@"断开" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

-(void)createHandler
{
    [[BluetoothManager manager] createRoom];
}

-(void)joinHandler
{
    [[BluetoothManager manager] joinRoom];
}


-(void)sendHandler
{
    NSData* tempData = [@"testdata" dataUsingEncoding:NSUTF8StringEncoding];
    
    [[BluetoothManager manager] sendDataBlock:tempData andError:^(NSError *error) {
        NSLog(@"错误----%@",error);
    }];
}

//断开
-(void)closeHandler
{
    [[BluetoothManager manager] disconnect];
}

//状态改变代理
-(void)linkStatusHasChange:(LinkStatus)linkStatus andIsCreateSide:(Boolean)isCreate
{
    NSLog(@"连接状态改变------%lu, 自己是否新建方---%i",(unsigned long)linkStatus,isCreate);
}

//收到data
-(void)receiveData:(NSData*)data andIsCreateSide:(Boolean)isCreate
{
    NSLog(@"收到-----%@,自己是否新建方----%i",data,isCreate);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

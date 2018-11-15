//
//  MODKViewController.m
//  MODKNetWorking
//
//  Created by openman1992 on 11/15/2018.
//  Copyright (c) 2018 openman1992. All rights reserved.
//

#import "MODKViewController.h"
#import "YourNameGetListApiManager.h"

@interface MODKViewController () <MODKApiManagerApiCallbackDelegate>

@property (nonatomic, strong) YourNameGetListApiManager *listApiManager;

@end

@implementation MODKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.listApiManager loadData];
}

- (void)managerCallApiDidSuccess:(MODKBaseApiManager *)manager responseObject:(id)responseObject {
    NSLog(@"%@",responseObject);
}

- (void)managerCallApiDidFailed:(MODKBaseApiManager *)manager error:(NSError *)error {
    
}


- (YourNameGetListApiManager *)listApiManager {
    if (!_listApiManager) {
        _listApiManager = [[YourNameGetListApiManager alloc]init];
        _listApiManager.delegate = self;
    }
    return _listApiManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

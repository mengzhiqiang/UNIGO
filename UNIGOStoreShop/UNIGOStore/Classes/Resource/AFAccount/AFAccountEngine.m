//
//  AFAccountEngine.m
//  AFJiaJiaMob
//
//  Created by singelet on 16/7/15.
//  Copyright © 2016年 AoFei. All rights reserved.
//

#import "AFAccountEngine.h"
//#import "NTESFileLocationHelper.h"

static AFAccountEngine *sharedInstance = nil;

@interface AFAccountEngine()
{
    
}

@property (nonatomic, copy) NSString *filepath;

@end

@implementation AFAccountEngine

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //注意：这里建议使用self,而不是直接使用类名（考虑继承）
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        // NSString *filepath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:kJiaJiaMobAccountInformation];
        NSString *filePath = [documentPath stringByAppendingPathComponent:kJettMobAccountInformation];
        sharedInstance = [[AFAccountEngine alloc] initWithPath:filePath];
    });
    return sharedInstance;
}


#pragma mark - Init

- (instancetype)initWithPath:(NSString *)filepath
{
    self = [super init];
    if (self) {
        _filepath = filepath;
       [self readAccountData];
    }
    return self;
}


#pragma mark - 

- (void)readAccountData
{
    NSString *filepath = [self filepath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        _currentAccount = [AFAccount mj_objectWithKeyValues:[NSData zh_JSONFromData:data]];
//        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
//        _currentAccount = [object isKindOfClass:[AFAccount class]] ? object : nil;
    }
}

- (void)setCurrentAccount:(AFAccount *)currentAccount
{
    _currentAccount = currentAccount;
   [self saveAccountData];
}

- (void)saveAccountData
{
    NSData *data = [NSData data];
    if (_currentAccount) {
        data = [NSData zh_dataFromJSON:[_currentAccount mj_keyValues]];
//        data = [NSKeyedArchiver archivedDataWithRootObject:_currentAccount];
    }
    [data writeToFile:[self filepath] atomically:YES];
}

+ (AFAccount *)getAccount
{
    return [AFAccountEngine sharedInstance].currentAccount;
}

+ (AFAccountEngine *)getAccountEngine
{
    return [AFAccountEngine sharedInstance];
}

+ (void)quitAccount
{
    [[AFAccountEngine sharedInstance] setCurrentAccount:nil];
}


+ (void)saveAccountInformationWithUserInfo:(NSDictionary *)userInfo
{
   NSMutableDictionary *accountInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    AFAccount *account = [AFAccount mj_objectWithKeyValues:accountInfo];
    [[AFAccountEngine sharedInstance] setCurrentAccount:account];
    
}

@end

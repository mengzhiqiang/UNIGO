//
//  MOFSPickerManager.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/26.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "MOFSPickerManager.h"

@implementation MOFSPickerManager

+ (MOFSPickerManager *)shareManger {
    static MOFSPickerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    return  manager;
}


- (MOFSAddressPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [MOFSAddressPickerView new];
    }
    return _addressPicker;
}


// ================================pickerView===================================//



//===============================addressPicker===================================//

- (void)showMOFSAddressPickerWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle commitTitle:(NSString *)commitTitle commitBlock:(void(^)(NSString *address, NSString *zipcode))commitBlock cancelBlock:(void(^)(void))cancelBlock {
    self.addressPicker.toolBar.titleBarTitle = title;
    self.addressPicker.toolBar.cancelBarTitle = cancelTitle;
    self.addressPicker.toolBar.commitBarTitle = commitTitle;
    [self.addressPicker showMOFSAddressPickerCommitBlock:^(NSString *address, NSString *zipcode) {
        if (commitBlock) {
            commitBlock(address, zipcode);
        }
    } cancelBlock:^{
        if (cancelBlock) {
            cancelBlock();
        }
    }];
}

- (void)showMOFSAddressPickerWithDefaultAddress:(NSString *)address title:(NSString *)title cancelTitle:(NSString *)cancelTitle commitTitle:(NSString *)commitTitle commitBlock:(void(^)(NSString *address, NSString *zipcode))commitBlock cancelBlock:(void(^)(void))cancelBlock {
    self.addressPicker.toolBar.titleBarTitle = title;
    self.addressPicker.toolBar.cancelBarTitle = cancelTitle;
    self.addressPicker.toolBar.commitBarTitle = commitTitle;
    
    [self.addressPicker showMOFSAddressPickerCommitBlock:^(NSString *address, NSString *zipcode) {
        if (commitBlock) {
            commitBlock(address, zipcode);
        }
    } cancelBlock:^{
        if (cancelBlock) {
            cancelBlock();
        }
    }];

    if (address == nil || [address isEqualToString:@""]) {
        return;
    }
    
    [self searchIndexByAddress:address block:^(NSString *address) {
        BOOL flag = [address rangeOfString:@"error"].location == NSNotFound;
        if (flag) {
            NSArray *indexArr = [address componentsSeparatedByString:@"-"];
            for (int i = 0; i < indexArr.count; i++) {
                @try {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.addressPicker selectRow:[indexArr[i] integerValue] inComponent:i animated:NO];
                    });
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
            }
        }
    }];
    
}

- (void)showMOFSAddressPickerWithDefaultZipcode:(NSString *)zipcode title:(NSString *)title cancelTitle:(NSString *)cancelTitle commitTitle:(NSString *)commitTitle commitBlock:(void (^)(NSString *, NSString *))commitBlock cancelBlock:(void (^)(void))cancelBlock {
    self.addressPicker.toolBar.titleBarTitle = title;
    self.addressPicker.toolBar.cancelBarTitle = cancelTitle;
    self.addressPicker.toolBar.commitBarTitle = commitTitle;
    
    [self.addressPicker showMOFSAddressPickerCommitBlock:^(NSString *address, NSString *zipcode) {
        if (commitBlock) {
            commitBlock(address, zipcode);
        }
    } cancelBlock:^{
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    if (zipcode == nil || [zipcode  isEqual: @""]) {
        return;
    }
    
    [self searchIndexByZipCode:zipcode block:^(NSString *address) {
        BOOL flag = [address rangeOfString:@"error"].location == NSNotFound;
        if (flag) {
            NSArray *indexArr = [address componentsSeparatedByString:@"-"];
            for (int i = 0; i < indexArr.count; i++) {
                @try {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.addressPicker selectRow:[indexArr[i] integerValue] inComponent:i animated:NO];
                    });
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
            }
        }
    }];
    
}

- (void)searchAddressByZipcode:(NSString *)zipcode block:(void(^)(NSString *address))block {
    [self.addressPicker searchType:SearchTypeAddress key:zipcode block:^(NSString *result) {
        if (block) {
            block(result);
        }
    }];
}

- (void)searchZipCodeByAddress:(NSString *)address block:(void(^)(NSString *zipcode))block {
    [self.addressPicker searchType:SearchTypeZipcode key:address block:^(NSString *result) {
        if (block) {
            block(result);
        }
    }];
}

- (void)searchIndexByAddress:(NSString *)address block:(void(^)(NSString *address))block {
    [self.addressPicker searchType:SearchTypeAddressIndex key:address block:^(NSString *result) {
        if (block) {
            block(result);
        }
    }];
}

- (void)searchIndexByZipCode:(NSString *)zipcode block:(void (^)(NSString *))block {
    [self.addressPicker searchType:SearchTypeZipcodeIndex key:zipcode block:^(NSString *result) {
        if (block) {
            block(result);
        }
    }];
}

@end

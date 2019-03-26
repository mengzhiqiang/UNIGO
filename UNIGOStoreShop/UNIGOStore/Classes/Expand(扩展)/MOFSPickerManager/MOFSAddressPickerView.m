//
//  MOFSAddressPickerView.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/31.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "MOFSAddressPickerView.h"
#import "DCAdressDateBase.h"
#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MOFSAddressPickerView() <UIPickerViewDelegate, UIPickerViewDataSource, NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray<AddressModel *>  *dataArr;
@property (nonatomic, strong) NSMutableArray<CityModel *>     *CityArr;
@property (nonatomic, strong) NSMutableArray<DistrictModel *> *distriArr;

@property (nonatomic, assign) NSInteger selectedIndex_province;
@property (nonatomic, assign) NSInteger selectedIndex_city;
@property (nonatomic, assign) NSInteger selectedIndex_area;

@property (nonatomic, assign) BOOL isGettingData;
@property (nonatomic, strong) void (^getDataCompleteBlock)(void);

@property (nonatomic, strong) dispatch_semaphore_t semaphore;


@property (nonatomic, strong) NSArray *  rootArray;
@property (nonatomic, strong) NSArray *  cityArray;
@property (nonatomic, strong) NSArray *  areaArray;

@end

@implementation MOFSAddressPickerView

#pragma mark - setter

- (void)setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attributes {
    _attributes = attributes;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadAllComponents];
    });
}

- (void)setNumberOfSection:(NSInteger)numberOfSection {
    if (numberOfSection <= 0 || numberOfSection > 3) {
        _numberOfSection = 3;
    } else {
        _numberOfSection = numberOfSection;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadAllComponents];
    });
}

#pragma mark - getter

- (NSMutableArray<AddressModel *> *)addressDataArray {
    return _dataArr;
}

#pragma mark - create UI

- (instancetype)initWithFrame:(CGRect)frame {
    
    self.semaphore = dispatch_semaphore_create(1);
    
    [self initToolBar];
    [self initContainerView];
    
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, self.toolBar.frame.size.height, UISCREEN_WIDTH, 216);
    } else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self initBgView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getData];
            dispatch_queue_t queue = dispatch_queue_create("my.current.queue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_barrier_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadAllComponents];
                });
            });
        });
    }
    return self;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    if (component >= self.numberOfComponents) {
        return;
    }
    [super selectRow:row inComponent:component animated:animated];
    switch (component) {
        case 0:
            self.selectedIndex_province = row;
            self.selectedIndex_city = 0;
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 1) {
                [self reloadComponent:1];
            }
            if (self.numberOfSection > 2) {
                [self reloadComponent:2];
            }
            break;
        case 1:
            self.selectedIndex_city = row;
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 2) {
                [self reloadComponent:2];
            }
            break;
        case 2:
            self.selectedIndex_area = row;
            break;
        default:
            break;
    }
}

- (void)initToolBar {
    self.toolBar = [[MOFSToolView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
    self.toolBar.backgroundColor = [UIColor whiteColor];
}

- (void)initContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.containerView.userInteractionEnabled = YES;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewClickedAction)]];
    
    [self showWithAnimation];
}

- (void)initBgView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT - self.frame.size.height - 44, UISCREEN_WIDTH, self.frame.size.height + self.toolBar.frame.size.height)];
}

#pragma mark - Action

- (void)showMOFSAddressPickerCommitBlock:(void(^)(NSString *address, NSString *zipcode))commitBlock cancelBlock:(void(^)(void))cancelBlock {
    if (self.numberOfSection <= 0 || self.numberOfComponents > 3) {
        self.numberOfSection = 3;
    }
    
    if ([self numberOfRowsInComponent:0] > 0) {
        //iOS 10及以上需要添加 这一行代码，否则第一次不显示中间两条分割线
        [self selectRow:[self selectedRowInComponent:0] inComponent:0 animated:NO];
    }
    [self showWithAnimation];
    
    __weak typeof(self) weakSelf = self;
    self.toolBar.cancelBlock = ^ {
        if (cancelBlock) {
            [weakSelf hiddenWithAnimation];
            cancelBlock();
        }
    };
    
    self.toolBar.commitBlock = ^ {
        if (commitBlock) {
            [weakSelf hiddenWithAnimation];
            if (weakSelf.dataArr.count > 0) {
                AddressModel *addressModel     = weakSelf.dataArr[weakSelf.selectedIndex_province];
                CityModel *cityModel          = weakSelf.CityArr[weakSelf.selectedIndex_city];
                DistrictModel *districtModel  = weakSelf.distriArr[weakSelf.selectedIndex_area];
                
                NSString *address;
                NSString *zipcode;
                if (!cityModel || weakSelf.numberOfComponents == 1) {
                    address = [NSString stringWithFormat:@"%@",addressModel.name];
                    zipcode = [NSString stringWithFormat:@"%@",addressModel.zipcode];
                } else {
                    if (!districtModel || weakSelf.numberOfComponents == 2) {
                        address = [NSString stringWithFormat:@"%@-%@",addressModel.name,cityModel.name];
                        zipcode = [NSString stringWithFormat:@"%@-%@",addressModel.zipcode,cityModel.zipcode];
                    } else {
                        address = [NSString stringWithFormat:@"%@-%@-%@",addressModel.name,cityModel.name,districtModel.name];
                        zipcode = [NSString stringWithFormat:@"%@-%@-%@",addressModel.zipcode,cityModel.zipcode,districtModel.zipcode];
                    }
                }
                
                commitBlock(address, zipcode);
            }
        }
    };
}

- (void)showWithAnimation {
    [self addViews];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGFloat height = self.bgView.frame.size.height;
    self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT - height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}

- (void)hiddenWithAnimation {
    CGFloat height = self.bgView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self hiddenViews];
    }];
}

- (void)containerViewClickedAction {
    if (self.containerViewClickedBlock) {
        self.containerViewClickedBlock();
    }
    [self hiddenWithAnimation];
}

- (void)addViews {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.containerView];
    [window addSubview:self.bgView];
    [self.bgView addSubview:self.toolBar];
    [self.bgView addSubview:self];
}

- (void)hiddenViews {
    [self removeFromSuperview];
    [self.toolBar removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.containerView removeFromSuperview];
    
    
    self.delegate = nil;
//    self = nil ;
    self.toolBar = nil;
    self.bgView = nil;
    self.containerView = nil;
}

#pragma mark - get data

- (void)getData {
    self.isGettingData = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    if (path == nil) {
        for (NSBundle *bundle in [NSBundle allFrameworks]) {
            path = [bundle pathForResource:@"city" ofType:@"json"];
            if (path != nil) {
                break;
            }
        }
    }
    
    if (path == nil) {
        self.isGettingData = NO;
        if (self.getDataCompleteBlock) {
            self.getDataCompleteBlock();
        }
        return;
    }
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    if (_dataArr.count != 0) {
        [_dataArr removeAllObjects];
        [_CityArr removeAllObjects];
        [_distriArr removeAllObjects];
        
    }
    if (!_CityArr) {
        _CityArr = [NSMutableArray array];
    }
    if (!_distriArr) {
        _distriArr = [NSMutableArray array];
    }
    
    
    
    
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
//    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
//    NSError *error;
//    NSArray * jsonObjectArray =[NSJSONSerialization JSONObjectWithData:data
//                                                               options:kNilOptions
//                                                                 error:&error];
    _rootArray = [NSArray arrayWithArray:[DCAdressDateBase sharedDataBase].adressList ];
    
    self.selectedIndex_province = 0;
    self.selectedIndex_city = 0;
    self.selectedIndex_area = 0;
    [self setProvinceData];
    [self setCityDataIndex:0];
    [self setAreaDataIndex:0];
    
    
    
    //    self.parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    //    self.parser.delegate = self;
    //    [self.parser parse];
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"province"]) {
        
        AddressModel *model = [[AddressModel alloc] initWithDictionary:attributeDict];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.count];
        [self.dataArr addObject:model];
    } else if ([elementName isEqualToString:@"cityList"]) {
        CityModel *model = [[CityModel alloc] initWithDictionary:attributeDict];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.lastObject.list.count];
        [self.dataArr.lastObject.list addObject:model];
    } else if ([elementName isEqualToString:@"areaList"]) {
        DistrictModel *model = [[DistrictModel alloc] initWithDictionary:attributeDict];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.lastObject.list.lastObject.list.count];
        [self.dataArr.lastObject.list.lastObject.list addObject: model];
    }
}

-(void)setProvinceData{
    
    for (int i=0; i<[_rootArray count]; i++) {
        NSDictionary * diction = [_rootArray objectAtIndex:i];
        AddressModel *model = [[AddressModel alloc] initWithDictionary:diction];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.count];
        [self.dataArr addObject:model];
    }
    
}
-(void)setCityDataIndex:(int)index{
    
    if (self.CityArr.count>0) {
        [self.CityArr removeAllObjects];
    }
    _cityArray =  [[_rootArray objectAtIndex:index] objectForKey:@"cityList"];
    for (int i=0; i<[_cityArray count]; i++) {
        NSDictionary * diction = [_cityArray objectAtIndex:i];
        CityModel *model = [[CityModel alloc] initWithDictionary:diction];
        model.index = [NSString stringWithFormat:@"%d", i];
        [self.CityArr addObject:model];
    }
    
}
-(void)setAreaDataIndex:(int)index{
    if (self.distriArr.count>0) {
        [self.distriArr removeAllObjects];
    }
    
    _areaArray =  [[_cityArray objectAtIndex:index] objectForKey:@"areaList"];
    for (int i=0; i<[_areaArray count]; i++) {
        NSDictionary * diction = [_areaArray objectAtIndex:i];
        DistrictModel *model = [[DistrictModel alloc] initWithDictionary:diction];
        model.index = [NSString stringWithFormat:@"%d", i];
        [self.distriArr addObject: model];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.isGettingData = NO;
    if (self.getDataCompleteBlock) {
        self.getDataCompleteBlock();
    }
}

#pragma mark - search

- (void)searchType:(SearchType)searchType key:(NSString *)key block:(void(^)(NSString *result))block {
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    NSString *valueName = @"";
    NSString *type = @"";
    
    if (searchType == SearchTypeAddressIndex) {
        valueName = @"index";
        type = @"name";
    } else if (searchType == SearchTypeZipcodeIndex) {
        valueName = @"index";
        type = @"code";
    } else {
        valueName = searchType == SearchTypeAddress ? @"name" : @"code";
        type = searchType == SearchTypeAddress ? @"code" : @"name";
    }
    
    if (self.isGettingData || !self.dataArr || self.dataArr.count == 0) {
        __weak typeof(self) weakSelf = self;
        self.getDataCompleteBlock = ^{
            if (block) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    block([weakSelf searchByKey:key valueName:valueName type:type]);
                });
                
                dispatch_semaphore_signal(weakSelf.semaphore);
            }
        };
    } else {
        if (block) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                block([self searchByKey:key valueName:valueName type:type]);
            });
            dispatch_semaphore_signal(self.semaphore);
        }
    }
    
}


- (NSString *)searchByKey:(NSString *)key valueName:(NSString *)valueName type:(NSString *)type {
    
    if ([key isEqualToString:@""] || !key) {
        return @"";
    }
    
    NSArray *arr = [key componentsSeparatedByString:@"-"];
    if (arr.count > 3) {
        return @"error0"; //最多只能输入省市区三个部分
    }
    AddressModel *addressModel = (AddressModel *)[self searchModelInArr:_dataArr key:arr[0] type:type];
    if (addressModel) {
        if (arr.count == 1) { //只输入了省份
            return [addressModel valueForKey:valueName];
        }
        CityModel *cityModel = (CityModel *)[self searchModelInArr:addressModel.list key:arr[1] type:type];
        if (cityModel) {
            if (arr.count == 2) { //只输入了省份+城市
                return [NSString stringWithFormat:@"%@-%@",[addressModel valueForKey:valueName],[cityModel valueForKey:valueName]];
            }
            DistrictModel *districtModel = (DistrictModel *)[self searchModelInArr:cityModel.list key:arr[2] type:type];
            if (districtModel) {
                return [NSString stringWithFormat:@"%@-%@-%@",[addressModel valueForKey:valueName],[cityModel valueForKey:valueName],[districtModel valueForKey:valueName]];
            } else {
                return @"error3"; //输入区错误
            }
        } else {
            return @"error2"; //输入城市错误
        }
    } else {
        return @"error1"; //输入省份错误
    }
    
    
}

- (NSObject *)searchModelInArr:(NSArray *)arr key:(NSString *)key type:(NSString *)type {
    
    NSObject *object;
    
    for (NSObject *obj in arr) {
        if ([key isEqualToString:[obj valueForKey:type]]) {
            object = obj;
            break;
        }
    }
    
    return object;
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfSection;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSLog(@"component---%ld",(long)component);
    //    AddressModel *addressModel;
    //    if (self.dataArr.count > 0) {
    //        addressModel = self.dataArr[self.selectedIndex_province];
    //    }
    //
    //    CityModel *cityModel;
    //    if (addressModel) {
    //        cityModel = addressModel.list[self.selectedIndex_city];
    //    }
    if (self.dataArr.count != 0) {
        if (component == 0) {
            return self.dataArr.count;
        } else if (component == 1) {
            return  _cityArray.count;
        } else if (component == 2) {
            return  _distriArr.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSLog(@"titleForRow==component---%ld====row==%ld",(long)component,row);
    if (self.containerView.hidden == YES) {
        self.containerView.hidden = NO;
        self.backgroundColor = [UIColor redColor];
    }
    
    if (component == 0) {
        AddressModel *addressModel = self.dataArr[row];
        return addressModel.name;
    } else if (component == 1) {
        //        AddressModel *addressModel = self.dataArr[self.selectedIndex_province];
        [self setCityDataIndex:(int)_selectedIndex_province];
        
        CityModel *cityModel = self.CityArr[row];
        NSLog(@"titleForRow==cityModel.name---%@====",cityModel.name);
        
        return (cityModel.name?cityModel.name:@"请选择");
    } else if (component == 2) {
        //        AddressModel *addressModel = self.dataArr[self.selectedIndex_province];
        //        CityModel *cityModel = addressModel.list[self.selectedIndex_city];
        
        if (row>=self.distriArr.count) {
            row = 0;
        }
        
        [self setAreaDataIndex:(int)_selectedIndex_city];
        DistrictModel *districtModel = self.distriArr[row];
        return (districtModel.name?districtModel.name:@"请选择");
        
    } else {
        return nil;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSLog(@"viewForRow==component---%ld====row==%ld",(long)component,row);
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:16];
        pickerLabel.textColor = [UIColor colorWithRed:12.f/255.f green:14.f/255.f blue:14.f/255.f alpha:1];
    }
    
    NSString *text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    pickerLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:_attributes];
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"didSelectRow==component---%ld====row==%ld",(long)component,row);
    
    switch (component) {
        case 0:
            self.selectedIndex_province = row;
            self.selectedIndex_city = 0;
            self.selectedIndex_area = 0;
            [self setCityDataIndex:(int)row];
            [self setAreaDataIndex:0];
            
            if (self.numberOfSection > 1) {
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:NO];
            }
            if (self.numberOfSection > 2) {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
            break;
        case 1:
            self.selectedIndex_city = row;
            [self setAreaDataIndex:(int)row];
            
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 2) {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
            break;
        case 2:
            self.selectedIndex_area = row;
            break;
        default:
            break;
    }
}

- (void)dealloc {
    
}

@end


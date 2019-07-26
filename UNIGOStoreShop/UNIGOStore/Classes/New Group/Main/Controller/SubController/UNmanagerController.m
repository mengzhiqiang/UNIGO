//
//  UNmanagerController
//  SmartDevice
//
//  Created by mengzhiqiang on 16/3/15.
//  Copyright © 2016年 ALPHA. All rights reserved.
//
/*
 nickname    否    string    用户名
 headimgurl    否    string    头像base64后的字符串
 truename    否    string    真实姓名
 birthday    否    date    生日 格式例如2019-10-04
 sex
 
 */

#import "UIViewController+navigationBar.h"

#import "DCReceivingAddressViewController.h"
#import "UNNickNameViewController.h"
#import "UNmanagerController.h"

#import "DeviceTableViewCell.h"
#import "AFFixIconView.h"
#import "AFdatePickerView.h"
#import "LCActionSheet.h"

#import "ExtendClass.h"
#import "Unification.h"
#import "AFAccountEngine.h"
#import "AFCommonEngine.h"

#import "UIImageView+AFNetworking.h"
#import "AFPhotoAlbumHelper.h"
#import "AFUpdateBabyInformation.h"

@interface UNmanagerController ()<UIGestureRecognizerDelegate,AFFixIconViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImagePickerController     *  imagePicker;
    AFdatePickerView            *   datePickView ;
    AFFixIconView               *  fixIconView;
    UNClient                    *  accountInfo ;
}
@property (strong, nonatomic) NSString * imageSuffix;     //图片后缀

@end

@implementation UNmanagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =@"帐号";
    
    _rootTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT- 64) style:UITableViewStyleGrouped];
    _rootTableView .frame = CGRectMake(0,  DCTopNavH, SCREEN_WIDTH, SCREEN_HEIGHT- DCTopNavH);
    _rootTableView.delegate=self;
    _rootTableView.dataSource=self;
    _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rootTableView.sectionHeaderHeight = 16 ;
    _rootTableView.sectionFooterHeight = 0;
    _rootTableView.backgroundColor=PersonBackGroundColor;
    self.view.backgroundColor=PersonBackGroundColor;

    _userInfo=[[NSMutableDictionary alloc]init];
    [self.view addSubview:_rootTableView];
   

    _userNickName = @"游客";
    _userSex = @"未设置";
    _userOld = @"2015-01-01";
    [self loadOldDate ];
    [_rootTableView reloadData];
}
-(void)loadOldDate{

        accountInfo =  [AFAccountEngine  getAccount].client;
        _userNickName  = (accountInfo.nickname?accountInfo.nickname:@"未设置");
        _userSex       = ((accountInfo.sex==1)?@"1":@"2");
        _userOld       = accountInfo.birthday;
        _userTrueName  = (accountInfo.truename?accountInfo.truename :@"未设置");
        _userPhone     = accountInfo.phone;
        _userUrl       = (accountInfo.avatar.large?accountInfo.avatar.large:nil);

        NSDictionary * babyDIC = [accountInfo mj_JSONObject];
        _userInfo = [NSMutableDictionary dictionaryWithDictionary:babyDIC] ;
        [self loadBabyInformation];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self  loadNewDate];

}

-(void)loadNewDate{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *path = [API_HOST stringByAppendingString:user_info];
    [HttpEngine requestPostWithURL:path params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        
        if ([JSONDic  count]<1) {
            return ;
        }
        [AFAccountEngine  saveAccountInformationWithUserInfo:JSONDic ];
        [self loadOldDate];

    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        
        if ([[Dic_data objectForKey:@"msg"] isEqualToString:@"access_token不存在或为空"]) {
            //去登陆
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceLoginTokenKey];
            [self.navigationController popToRootViewControllerAnimated:YES];return ;
        }
        [self promtNavHidden:@"请求失败"];
        
    }];
    
}
-(void)onTap{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"选取图片===%@",aImage);
    
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    _imageSuffix = [NSString typeForImageData:info];
    if (fixIconView) {
        [fixIconView removeFromSuperview];
        fixIconView = nil;
    }
    fixIconView = [[AFFixIconView alloc] initWithImage:info[UIImagePickerControllerOriginalImage] andImageSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];

    fixIconView.frame = CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    fixIconView.delegate = self;
    [fixIconView.backBtn addTarget:self action:@selector(backToImagePicker) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:fixIconView];
    
    [UIView animateWithDuration:0.3 animations:^{
        fixIconView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    imagePicker = picker;
    
    //    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)backToImagePicker{
    
    [UIView animateWithDuration:0.3 animations:^{
        fixIconView.frame = CGRectMake(320, 0, 320, 568);
        //        control.alpha = 0;
    } completion:^(BOOL finished) {
        [fixIconView removeFromSuperview];
        //        [control removeFromSuperview];
    }];
    
}
#pragma mark - FixIconViewDelegate method
-(void)getSubImage:(UIImage *)image{
    [imagePicker dismissViewControllerAnimated:NO completion:NULL];
    [self backToImagePicker];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    self.headImage=image;
    
    NSString * imagebast = [NSString imageToString:image];

    [_rootTableView reloadData];

    return ;
    [self UpdateBabyInformationKey:@"headimgurl" value:imagebast];
//    [self updateBackGroundImage:image];
}



#pragma mark 上传头像图片
-(void)updateBackGroundImage:(UIImage *)image {
    
//    NSString *pathUrl = [API_HOST stringByAppendingString:[NSString stringWithFormat:@"%@policy?policy=babyAvatar:%d",jett_Sign_policy,(int)accountInfo.identifier]];
    
    return ;
    __weak typeof (self) myself = self;
    [UIHelper addLoadingViewTo:self.view withFrame:0];
    [HttpEngine requestGetWithURL:nil headImage:image params:nil isToken:YES imageSuffix:_imageSuffix errorDomain:nil errorString:nil success:^(CGFloat progress) {
    } success:^(id responseObject) {
        [UIHelper hiddenAlertWith:self.view];
        
        NSDictionary * old_dic = [accountInfo mj_JSONObject];
        NSMutableDictionary* new_dic = [NSMutableDictionary dictionaryWithDictionary:old_dic];
        [new_dic setObject:responseObject forKey:@"avatar"];
        /*宝贝信息存储 */
//        [AFCommonEngine saveSingleBadyWithObject:new_dic];
//        myself.badyUrl = [responseObject objectForKey:@"large"];
        [myself.rootTableView reloadData];

    } failure:^(NSError *error) {
        [UIHelper hiddenAlertWith:self.view];
        NSDictionary *userInfo = error.userInfo;
        if (![UIHelper TitleMessage:userInfo]) {
            return;
        }
        [UIHelper  showUpMessage:@"上传失败"];
    }];
    
}


- (IBAction)SaveInformationButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section==1 ||section==2) {
        return  1;
    }
    return  5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0) {
        return 87.5;
    }
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil] objectAtIndex:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.lineLabel1.hidden = NO;
    cell.titleNameLabel.frame = CGRectMake(25, (cell.height-20)/2, 120, 20);
    cell.headImageView.hidden = YES;

    if (indexPath.section==1) {
        cell.titleNameLabel.text = @"地址管理";
        cell.pushNextLabel.text  = @"";
        return cell;
    }else if (indexPath.section==2){
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.headImageView.hidden=YES;
        cell.titleNameLabel.text= @"退出登录";
        cell.pushNextLabel.text  = @"";
        cell.titleNameLabel.textAlignment = NSTextAlignmentCenter;
        cell.titleNameLabel.textColor=[UIColor HexString:@"ff3824"];
        cell.titleNameLabel.frame = CGRectMake((SCREEN_WIDTH-150)/2, (50-22)/2, 150, 22);
        return cell;
    }
    
    NSArray  *arr_titile  = @[@"头像",@"昵称",@"生日",@"年龄",@"性别"];
        cell.titleNameLabel.text=[arr_titile  objectAtIndex:indexPath.row%5];
        switch (indexPath.row) {
                case 0:
            {
                cell.pushNextLabel.hidden = YES;
                cell.pushTagImageView.hidden = YES;
                cell.backgroundColor =[UIColor whiteColor];
                cell.titleNameLabel.frame = CGRectMake(25, (87.5-20)/2, 120, 20);
                cell.headImageView.hidden = NO;
                [cell.headImageView draCirlywithColor:[UIColor redColor] andRadius:2.0];
                cell.headImageView.frame = CGRectMake(SCREEN_WIDTH-65-29, (87.5-60)/2, 65, 65);
                [cell.headImageView setImageWithURL:[NSURL URLWithString:_userUrl] placeholderImage:(self.headImage?self.headImage:[UIImage imageNamed:@"pho_head_portrait_default"])];
                [cell.headImageView draCirlywithColor:nil andRadius:cell.headImageView.height/2];
            }
                break;
            case 1:
            {
                cell.pushNextLabel.text=_userNickName;
                
            }
                break;
            case 2:
            {
                cell.pushNextLabel.text = (_userOld?_userOld:@"未设置");

            }
                break;
            case 3:
            {
                cell.pushTagImageView.hidden = YES;
            }
                break;
            case 4:
            {
                if ([_userSex isEqualToString:@"1"]) {
                cell.pushNextLabel.text=@"男孩";
                
            }else if ([_userSex isEqualToString:@"未设置"]) {
                cell.pushNextLabel.text=@"未设置";
            }else{
                cell.pushNextLabel.text=@"女孩";
            }
                cell.lineLabel1.hidden = YES;
 
            }
                break;
            break;
            default:
                break;
        }

      return   cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"====%ld",(long)indexPath.row);
    
    if (indexPath.section==1) {
        
        DCReceivingAddressViewController* adressVC = [[DCReceivingAddressViewController alloc]init];
        [self.navigationController pushViewController:adressVC animated:YES];
        return;
    }else if (indexPath.section==2) {
        
        [self showActionSheetViewTelphoe];
        return;
    }
    
    switch (indexPath.row) {
            case 0:
        {
            [self  showActionSheetViewUploadPhoto ];
        }
            break;
        case 1:
        {
            UNNickNameViewController *nickNameVC = [[UNNickNameViewController alloc]init];
            nickNameVC.baby_Dic = self.userInfo;
            [self.navigationController pushViewController:nickNameVC animated:YES];
            nickNameVC.backBabyinforBlock = ^(NSDictionary *babyDic) {
                _userNickName = [babyDic objectForKey:@"name"];
                _userInfo = [NSMutableDictionary dictionaryWithDictionary:babyDic] ;
                [_rootTableView reloadData];
            };
        }
            break;
        case 2:
        {
  
            [self selectAgeWithdate];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
            [self showAgeWithActionSheetView];

        }
            break;

        default:
            break;
    }
    
}

- (void)showActionSheetViewTelphoe {
    __weak typeof (self) myself = self;
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"确认退出登录吗？" buttonTitles:@[@"退出登录"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex == 0) {
            [myself logoutButton];
        }
        NSLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
    }];
    [sheet show];
    
}

- (void)logoutButton{
    
    [self logoutButton:nil];
}
- (void)logoutButton:(UIButton *)sender {
    
    //   [UIHelper alertWithTitle:@"确定要退出登录吗" andMSG:nil delegate:self andTag:102];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASS_WORD];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceLoginTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSmartDeviceUseInfornKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [AFAccountEngine quitAccount];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"cleadcookieNoticon" object:nil];

    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark 选择头像图片
- (void)showActionSheetViewUploadPhoto
{
    [AFPhotoAlbumHelper checkSystemPermissionWithCount:0 isTtile:NO callBack:^(NSInteger index) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.mediaTypes = @[(__bridge_transfer NSString *)kUTTypeImage]; // 设置可以选取的媒体类型
        if (index == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) { // 支持相机
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            } else {
                NSLog(@"该环境不支持相机，不处理");
                return;
            }
        } else if (index == 0) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.navigationBar.translucent = NO;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}


#pragma mark 选择年龄
-(void)selectAgeWithdate{
    
    if (!datePickView) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AFdatePickerView"owner:self options:nil];
        datePickView = [nib objectAtIndex:0];
        datePickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    datePickView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:datePickView];
    [datePickView showOrHiddenDate:NO];
    __weak typeof (self) myself = self;
    datePickView.clickCommirbtnBlock = ^(NSString * date){
        _userOld=date;
        [myself UpdateBabyInformationKey:@"birthday" value:date];
    };
}

#pragma mark 设置性别
- (void)showAgeWithActionSheetView
{
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"男孩",@"女孩"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        if(buttonIndex == 2) {
            return ;
        }
        if (buttonIndex==0) {
            _userSex=@"1";   //男
        } else  if (buttonIndex==1) {
            _userSex=@"2";//女
        }
        [self UpdateBabyInformationKey:@"sex" value:_userSex];
        
    }];
    
    [sheet showWithColor:[UIColor HexString:@"2c2c2c"]];
}
/* dd*/
-(void)UpdateBabyInformationKey:(NSString*)key value:(NSString*)value{
    
        //修改接口
        [UIHelper addLoadingViewTo:self.view withFrame:0];
        
        [AFUpdateBabyInformation requestPatchWithparams:_userInfo key:key value:value success:^(id responseObject) {
            
            NSLog(@"更新接口==responseObject==%@=",responseObject);
            [UIHelper hiddenAlertWith:self.view];
            [_rootTableView reloadData];
            
        } failure:^(NSError *error) {
            [UIHelper hiddenAlertWith:self.view];
            
            NSDictionary *userInfo = error.userInfo;
            if (![UIHelper TitleMessage:userInfo]) {
            }
        }];
        return;
    
}


-(void)changeBabayInfoWithDiction:(NSDictionary*)dic{
    
    [self loadOldDate];
    [self.rootTableView reloadData];
}

-(NSDictionary *)relNewDicWithOldDicton:(NSDictionary*)Dic_dat{
    
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    
    for (NSString *str in [Dic_dat allKeys]) {
        
        if ([[[Dic_dat objectForKey:str] class] isSubclassOfClass:[NSNull class]] ) {
        }
        else  if ([[[Dic_dat objectForKey:str] class] isSubclassOfClass:[NSDictionary class]] ) {
            NSDictionary*dic_acc= [self relNewDicWithOldDicton:[Dic_dat objectForKey:str]];
            
            if ([dic_acc allKeys]>0) {
                [dic setObject:dic_acc forKey:str];
                
            }
        }
        else{
            [dic setObject:[Dic_dat objectForKey:str] forKey:str];
        }
    }
    
    return dic;
}


-(void)loadBabyInformation{

    _babyIDlabel.text= self.userPhone;
    [_rootTableView reloadData];

}

@end

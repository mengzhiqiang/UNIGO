//
//  DCAfterSaleViewController.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 4/8/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCAfterSaleViewController.h"

@interface DCAfterSaleViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *goodsTextF;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UITextView *goodsTextView;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSumLabel;

@end

@implementation DCAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"退款";
    _rootView.top = SCREEN_top ;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backButton];
    [_goodsTextView becomeFirstResponder];
    
    [self loadNewUI ];
}

-(void)loadNewUI{
    
    self.view.backgroundColor = PersonBackGroundColor;
    self.rootView.backgroundColor = PersonBackGroundColor;

    NSDictionary * goodsDicgoodsDic =  [[_goodsPayDiction objectForKey:@"goods"] firstObject];
    
    self.goodNameLabel.text = [goodsDicgoodsDic objectForKey:@"name"];
    self.goodeDetailLabel.text = [goodsDicgoodsDic objectForKey:@"spec_name"];
    self.goodsPriceLabel.text = [goodsDicgoodsDic objectForKey:@"price"];
    self.goodsCountLabel.text = [NSString stringWithFormat:@"x%@",[goodsDicgoodsDic objectForKey:@"num"]];
    [self.goodsImageView setImageWithURL:[NSURL URLWithString: [goodsDicgoodsDic objectForKey:@"image"]] placeholderImage:nil];
    
    self.goodsTextF.text = [_goodsPayDiction objectForKey:@"total_price"];
    self.goodsTextF.delegate = self;

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

-(void)submit{
   
    CGFloat sum = [[_goodsPayDiction objectForKey:@"total_price"] floatValue];
    CGFloat text = [_goodsTextF.text floatValue] ;
    
    if (text >sum) {
        [UIHelper  alertWithTitle:@"退款金额不能大于总额，请修改！"]; return ;
    }
    
}

@end

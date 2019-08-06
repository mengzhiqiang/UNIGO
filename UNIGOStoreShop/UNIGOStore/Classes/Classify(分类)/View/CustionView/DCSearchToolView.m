//
//  DCSearchToolView.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 21/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCSearchToolView.h"
#import "JFBubbleItem.h"
@implementation DCSearchToolView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
       
        [self addSearchView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)addSearchView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_top)];
    view.backgroundColor = [UIColor HexString:@"f2f2f2"];
    
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 25+iphoneXTop, ScreenW-40, 30)];
    [view addSubview:_searchBar];
    _searchBar.placeholder = @"搜索商品";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    [self addSubview:view];
    
    [self getSearchRecommendList];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [_searchBar resignFirstResponder];
    self.hidden = YES ;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"===%@",searchBar.text);
    [_searchBar resignFirstResponder];
    self.hidden = YES ;
    
    if (_backText) {
        _backText(searchBar.text);
    }
}

-(void)getSearchRecommendList{
    
    NSString *path = [API_HOST stringByAppendingString:searchRecommendList_get];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [HttpEngine requestPostWithURL:path params:nil isToken:NO errorDomain:nil errorString:nil success:^(id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *JSONDic = [(NSDictionary *)responseObject objectForKey:@"data"] ;
        NSLog(@"===%@",responseObject );
        self.searchList = JSONDic;
        [self setupNewUI];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary *Dic_data = error.userInfo;
        NSLog(@"code==%@",Dic_data);
        if (![UIHelper TitleMessage:Dic_data]) {
            return;
        }
        
    }];
    
}

-(void)setupNewUI{
    
    WEAKSELF;
    if (!_searchBubbleView) {
        _searchBubbleView = [[JFEditBubbleView alloc] initWithFrame:CGRectMake(0, 100, self.bounds.size.width, 150)];
        _searchBubbleView.editBubbleViewDelegate = self;
        _searchBubbleView.dataArray = self.searchList ;
        _searchBubbleView.backSelectIndex = ^(NSString *string) {
            if (weakSelf.backText) {
                weakSelf.backText(string);
            }
            [_searchBar resignFirstResponder];
            self.hidden = YES ;
            
        };
        [self addSubview:_searchBubbleView];
    }
    
}

#pragma mark - Bubble Delegate

-(void)bubbleView:(JFBubbleView *)bubbleView didSelectItem:(JFBubbleItem *)item{
   
    
    NSLog(@"===%@",item.textLabel.text) ;
}
@end

//
//  DCSearchToolView.m
//  UNIGOStore
//
//  Created by zhiqiang meng on 21/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import "DCSearchToolView.h"

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
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    view.backgroundColor = [UIColor HexString:@"f2f2f2"];
    
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 25, ScreenW-40, 30)];
    [view addSubview:_searchBar];
    _searchBar.placeholder = @"搜索商品";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    [self addSubview:view];
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
@end

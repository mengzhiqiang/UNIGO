//
//  DCSearchToolView.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 21/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFEditBubbleView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCSearchToolView : UIView<UISearchBarDelegate,JFEditBubbleViewDelegate>

@property(strong , nonatomic)UISearchBar * searchBar ;
@property(strong , nonatomic)NSArray * searchList ;

@property(strong , nonatomic)JFEditBubbleView * searchBubbleView ;

@property(nonatomic,copy)void (^backText)(NSString * text) ;
@end

NS_ASSUME_NONNULL_END

//
//  DCSearchToolView.h
//  UNIGOStore
//
//  Created by zhiqiang meng on 21/4/2019.
//  Copyright © 2019 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCSearchToolView : UIView<UISearchBarDelegate>

@property(strong , nonatomic)UISearchBar * searchBar ;

@property(nonatomic,copy)void (^backText)(NSString * text) ;
@end

NS_ASSUME_NONNULL_END

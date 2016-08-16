//
//  HXCurrencySelectionViewController.h
//  https://github.com/huangxuan518/HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/29.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCurrencySelectionViewController : UIViewController

@property (nonatomic,copy) NSString *currentCurrency; //当前货币码

@property (nonatomic,copy) void (^completion)(HXCurrencySelectionViewController *vc, NSString *currency);

@end

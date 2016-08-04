//
//  HXCurrencyManager.h
//  HXCurrencyConversion
//
//  Created by 黄轩 on 16/8/4.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXCurrencyManager : NSObject

//所有币种
- (NSArray *)allCurrencies;

//货币代码转货币名
- (NSString *)toCurrencyName:(NSString *)currency;

//保存当前待转换币种
- (void)saveFromCurrency:(NSString *)fromCurrency;
//保存目标货币
- (void)saveToCurrency:(NSString *)toCurrency;

//获取当前待转换币种
- (NSString *)currentFromCurrency;
//获取目标货币
- (NSString *)currentToCurrency;

+ (instancetype)shareInstance;

#define kCurrencyManager [HXCurrencyManager shareInstance]

@end

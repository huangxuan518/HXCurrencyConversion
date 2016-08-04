//
//  HXCurrencyManager.m
//  HXCurrencyConversion https://github.com/huangxuan518/HXCurrencyConversion
//  博客地址 http://blog.libuqing.com/
//
//  Created by 黄轩 on 16/8/4.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXCurrencyManager.h"

#define FromCurrency @"fromCurrency"
#define ToCurrency @"toCurrency"

@interface HXCurrencyManager ()

@property (nonatomic,strong) NSDictionary *data;

@end

@implementation HXCurrencyManager

+ (instancetype)shareInstance {
    static HXCurrencyManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

- (NSDictionary *)data {
    if (!_data) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"currencycodetable" ofType:@"plist"];
        _data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return _data;
}

- (NSArray *)allCurrencies {
    return self.data.allKeys;
}

//货币代码转货币名
- (NSString *)toCurrencyName:(NSString *)currency {
    return self.data[currency];
}

//保存当前待转换币种
- (void)saveFromCurrency:(NSString *)fromCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:fromCurrency forKey:FromCurrency];
    [defaults synchronize];
}

//保存目标货币
- (void)saveToCurrency:(NSString *)toCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:toCurrency forKey:ToCurrency];
    [defaults synchronize];
}

//获取当前待转换币种
- (NSString *)currentFromCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fromCurrency = [defaults objectForKey:FromCurrency];
    if (fromCurrency.length > 0) {
        return fromCurrency;
    }
    return @"USD";
}

//获取目标货币
- (NSString *)currentToCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *toCurrency = [defaults objectForKey:ToCurrency];
    if (toCurrency.length > 0) {
        return toCurrency;
    }
    return @"CNY";
}

@end

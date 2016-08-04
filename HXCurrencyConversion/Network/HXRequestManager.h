//
//  HXRequestManager.h
//  HXCurrencyConversion https://github.com/huangxuan518/HXCurrencyConversion
//  博客地址 http://blog.libuqing.com/
//
//  Created by 黄轩 on 16/8/4.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import <Foundation/Foundation.h>

#define apikey @"fd0a97bd4bcb79b91c50b47c7fa8246d"

@interface HXRequestManager : NSObject

/**
 *  支持的币种查询 http://apis.baidu.com/apistore/currencyservice/type
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
- (void)getCurrencySupportListRequest:(void(^)(NSArray *responseAry, NSInteger responseCode))success
                              failure:(void(^)(NSString *localizedDescription, NSInteger code))failure ;

/**
 *  汇率转换 http://apis.baidu.com/apistore/currencyservice/currency?fromCurrency=%@&toCurrency=%@&amount=%@
 *
 *  @param fromCurrency 待转化的币种
 *  @param toCurrency   转化后的币种
 *  @param amount       转化金额
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
- (void)getExchangeRateConversionReuqestWithFromCurrency:(NSString *)fromCurrency
                                              toCurrency:(NSString *)toCurrency
                                                  amount:(NSString *)amount
                                                 success:(void(^)(NSDictionary *responseDic, NSInteger responseCode))success
                                                 failure:(void(^)(NSString *localizedDescription, NSInteger code))failure;

@end

//
//  CoinbaseAPI.h
//  currensy
//
//  Created by Nikhil Srinivasan on 2/15/14.
//  Copyright (c) 2014 bitpass. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinbaseAPI : NSObject

+(void)getCoinbaseAuth: (NSString *) authCode clientKey:(NSString *)clientKey clientSecret:(NSString *)clientSecret;

@end

//
//  CoinbaseAuth.m
//  currensy
//
//  Created by Nikhil Srinivasan on 2/15/14.
//  Copyright (c) 2014 bitpass. All rights reserved.
//

#import "CoinbaseAuth.h"

@implementation CoinbaseAuth

// Oauth2
NSString *clientID = @"9df7e7bba7edb141ad6c3084f3ed96821c94f138af75c1bf3f46de72800ce846";
NSString *clientSecret = @"4ab3b6e626b3d303fda4302a988a983a2c7de248452645a4ddc0e9180b150a37";
NSString *redirectURI = @"currensyapp.com";

// API Key + Secret
NSString *APIKey = @"m5Vb1MdYPFFDtKcq";
NSString *APISecret = @"bPEhQ3uOVK9EEr9ht6Fx42nKCxKlW5Ux";


+(void)getDataCoinbaseAuth: (NSString *) authCode clientKey:(NSString *)clientKey clientSecret:(NSString *)clientSecret {
    
    
    // Check if we have a valid auth code
    if(authCode != nil) {
        
        NSLog(@"attempting oauth");
        
        // Create a NSURLSession to submit an HTTP POST request to Venmo
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSString *tokURL = @"https://coinbase.com/oauth/authorize";
        
        NSURL * url = [NSURL URLWithString:tokURL];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSString *params = [NSString stringWithFormat:@"response_type=code&client_id=%@&redirect_uri=%@&scope=%@", clientID, redirectURI, @"user"];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *request_error) {
                                                               
           NSLog(@"Response:%@ %@\n", response, request_error);
           
            if(request_error == nil)
           {
               
               
           }
                                                               
       }];
        
        [dataTask resume];
    }
    
    else NSLog(@"Auth code not provided!");
    
    
    
}


+(void)testLoginWithAPIKeySecret {
    
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:APISecret];
    
    
    NSString *url = [NSString stringWithFormat:@"https://www.coinbase.com/api/v1/account/balance?ACCESS_KEY=%@&ACCESS_SIGNATURE=%@&ACCESS_NONCE=%@", APIKey, [uuid UUIDString], @"1"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *received_data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if(requestError) {
        NSLog(@"error %@", requestError);
    }
    
    // Store response data in a dictionary
    NSMutableDictionary *response_data = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:received_data options:NSJSONReadingAllowFragments error:nil]];
    
    NSLog(@"[date response = %@", response_data);
}

@end

//
//  AdvertiserViewController.m
//  Divvy
//
//  Created by Neel Mouleeswaran on 10/11/13.
//  Copyright (c) 2013 omics. All rights reserved.
//

#import "AdvertiserViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "PeerBrowserViewController.h"

static NSString * const serviceType = @"service"; // --> it is now a hash of the user profile url (uniq)

static NSString * const messageKey = @"message-key"; // Message key

@interface AdvertiserViewController () <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;

// This advertises the peer to nearby peers with the discovery packet
@property (nonatomic, strong) MCNearbyServiceAdvertiser *nearbyServiceAdvertiser;

@end

@implementation AdvertiserViewController
@synthesize activity_indicator;
@synthesize pay_button;
@synthesize bal_label;
@synthesize nav_bar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
   // [[self view]setUserInteractionEnabled:YES];
    
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    
    // Usu. only store 1 IH (from the host)
    InvitationHandlers = [[NSMutableArray alloc]init];
    
    // Initialize the peer
    _peerID = [[MCPeerID alloc]initWithDisplayName:@"peer"];
    
    // Initialize the session
    _session = [[MCSession alloc]initWithPeer:_peerID];
    _session.delegate = self;
    
    NSLog(@"advertising %@", serviceType);
    
     // Initialize the service advertiser - service type matches that of the host
    _nearbyServiceAdvertiser = [[MCNearbyServiceAdvertiser alloc]initWithPeer:_peerID discoveryInfo:nil serviceType:serviceType];
    _nearbyServiceAdvertiser.delegate = self;

    // Start advertising this peer to the host and other peers
    [_nearbyServiceAdvertiser startAdvertisingPeer];
    
    NSLog(@"%@ is an advertiser", [_peerID displayName]);
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_nearbyServiceAdvertiser stopAdvertisingPeer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Called when this peer receives an invitation from another peer (usu. host)
-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background processing
        
        // Copy & store the invitation handler
        [InvitationHandlers addObject:[invitationHandler copy]];
        
        // Copy & store context (invitation data)
        invitationData = context;
        // Decrypt the invitation data
        NSError *error;
        //decryptedInvitationData = [RNDecryptor decryptData:invitationData withPassword:@"divvy-ios" error:&error];
        
        // Get the host id from the invite data
        NSString *host_id = [[NSString alloc]initWithData:invitationData encoding:NSUTF8StringEncoding];
        
        // Store the host id securely in the keychain so the advertiser can make a payment
        //[SSKeychain setPassword:host_id forService:@"venmo_api" account:@"host_id"];
        
        // Respond to peer (usu. host)
        invitationHandler([@YES boolValue], _session);
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Update the UI/send notifications based on the results of the background processing
            
            [activity_indicator stopAnimating];
            
           // [GlobalFunctions displayAlertDialogWithTitle:@"Connected to host" message:@"" cancelButtonTitle:@"OK"];
            
            [activity_indicator setHidden:YES];
            [wait_message_field setHidden:YES];
            
            [payment_field setHidden:NO];
            [pay_button setHidden:NO];
            [payment_field becomeFirstResponder];
            
        });
    });
}

// Eventually use this to tell advertisers about tip, etc.
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"AdvertiserVC received data");
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    //NSLog(@"peer changed state");
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}


- (IBAction)back_button_clicked:(id)sender {
    // TODO: Notify of payment cancellation
    
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction)pay_clicked:(id)sender {
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background processing
        
        //NSLog(@"pay_clicked / keyboard dismissed");
        
       // NSString *access_token = [SSKeychain passwordForService:@"venmo_api" account:@"access_token"];
       // NSString *host_id = [SSKeychain passwordForService:@"venmo_api" account:@"host_id"];
        
        //NSLog(@"host id = %@", host_id);
        
        // Get  potential error code from resulting transaction
        
        __block BOOL payment_processed = NO;
        
    // Create a NSURLSession to submit an HTTP POST request to Venmo
       
        /*
        
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
        NSString *paymentURL = @"https://api.venmo.com/payments";
    
        NSURL * url = [NSURL URLWithString:paymentURL];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        NSString *params = [NSString stringWithFormat:@"access_token=%@&user_id=%@&amount=%f&note=%@", access_token, host_id, [[payment_field text] floatValue], [GlobalFunctions genRandStringLength:5]];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *request_error) {
                    
                                                               
           NSString *code;
                                                               
           //NSLog(@"Response:%@ %@\n", response, request_error);
                                                               
            if(request_error == nil)
           {
               
               // Store response data in a dictionary
               NSMutableDictionary *response_data = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
               
               //NSLog(@"response = %@", response_data);
               
               if([response_data objectForKey:@"error" ] != nil) {
                   NSLog(@"error processing payment!");
                   
                   // Get the error code
                   code = [[response_data objectForKey:@"error"]objectForKey:@"code"];
                   
                   // There is an error on Venmo's side
                   payment_processed = NO;
                   
                   //[[NSUserDefaults standardUserDefaults]setObject:code forKey:@"error_code"];
                   
                   // Get the error code set
                   NSString *path_to_error_file = [[NSBundle mainBundle]pathForResource:@"Venmo_Errors" ofType:@"plist"];
                   NSDictionary *error_codes = [[NSDictionary alloc]initWithContentsOfFile:path_to_error_file];
                   NSString *error_message = [error_codes objectForKey:code];
                   
                   NSLog(@"error codes = %@", error_codes);
                   
                   [GlobalFunctions displayAlertDialogWithTitle:@"Error!" message:error_message cancelButtonTitle:@"OK"];
                   
               }
               
               else {
                   // The payment went through
                   NSLog(@"payment appears to have been processed");
                   
                   payment_processed = YES;
                   
                   //[[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"error_code"];
                   
                   
                   [payment_field resignFirstResponder];
                   [[self navigationController]popViewControllerAnimated:YES];

               }
               
            }
                
                                                               
            else {
                // There was a problem with the POST request
                payment_processed = NO;
                
                code = @"1234";
                
                //[[NSUserDefaults standardUserDefaults]setObject:code forKey:@"error_code"];
            }
                   
                                                               
       }];
        
        [dataTask resume];
        
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [self updateBalLabel];
            
        });
         
         */
    });

        
        
    
}

@end

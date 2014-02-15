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
#import "CustomShapes.h"

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
@synthesize feed_table;


@synthesize amount_field;
@synthesize enter_button;


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
    
    [enter_button setAlpha:0.0];
    [amount_field setAlpha:0.0];
    
   // [[self view]setUserInteractionEnabled:YES];
    
    [super viewDidLoad];
    
    peerIDs = [[NSMutableArray alloc]init];
    
    pic = 0;
	
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
    
    if(![peerIDs containsObject:peerID]) {
        NSLog(@"invite from %@", peerID);
        
        pic++;
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
        
        
        if(pic == 1) {
            UIImage *bgImage = [UIImage imageNamed:@"nikhil.png"];
            NSLog(@"image = %@", bgImage);
            UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
            [new_peer_button setTag:1];
            CGPoint center = CGPointMake(196, 50);
            new_peer_button.center = center;
            [new_peer_button addTarget:self action:@selector(temp_circleClicked) forControlEvents:UIControlEventTouchUpInside];
            [self fadeIn:new_peer_button];
        }
        
        else if(pic == 2) {
            UIImage *bgImage = [UIImage imageNamed:@"dave.png"];
            NSLog(@"image = %@", bgImage);
            UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
            [new_peer_button setTag:1];
            CGPoint center = CGPointMake(196, 150);
            new_peer_button.center = center;
            [new_peer_button addTarget:self action:@selector(temp_circleClicked) forControlEvents:UIControlEventTouchUpInside];
            [self fadeIn:new_peer_button];
        }
        
        else if(pic == 3) {
            UIImage *bgImage = [UIImage imageNamed:@"kortina.png"];
            NSLog(@"image = %@", bgImage);
            UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
            [new_peer_button setTag:1];
            CGPoint center = CGPointMake(196, 250);
            new_peer_button.center = center;
            [new_peer_button addTarget:self action:@selector(temp_circleClicked) forControlEvents:UIControlEventTouchUpInside];
            [self fadeIn:new_peer_button];
        }
    }
    
    
    
}

-(void)temp_circleClicked {
        // bring up a keyboard
    [amount_field becomeFirstResponder];
    
    
    
    // fade in field and enter button
    
    [UIView animateWithDuration:0.3 animations:^{
        amount_field.alpha = 1;
        enter_button.alpha = 1;
    } completion: ^(BOOL finished) {
        
        
    }];
    
    
}

// Eventually use this to tell advertisers about tip, etc.
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"AdvertiserVC received data, %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    
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

// Assumes button has not been added to view yet
-(void)fadeIn: (UIButton *)button {
    button.alpha = 0;
    [peers_view addSubview:button];
    [UIView animateWithDuration:0.3 animations:^{
        button.alpha = 1;
    } completion: ^(BOOL finished) {
        // Auto invite the peer
       // [self circleWasClicked:button];
        
    }];
}

// Will remove button from the view upon completion
-(void)fadeOut: (UIButton *)button {
    button.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        button.alpha = 0;
    } completion: ^(BOOL finished) {
        [button removeFromSuperview];
        NSLog(@"removed button from superview");
    }];
    
}

- (IBAction)enter_clicked:(id)sender {
    // make the transaction
    
    
    // notify the peer
}
@end

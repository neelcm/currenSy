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
@synthesize description_field;


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
    
    NSLog(@"%@",[[UIDevice currentDevice]identifierForVendor]);
    
    [enter_button setAlpha:0.0];
    [amount_field setAlpha:0.0];
    [description_field setAlpha:0.0];
    
   // [[self view]setUserInteractionEnabled:YES];
    
    [super viewDidLoad];
    
    peerIDs = [[NSMutableArray alloc]init];
    peerButtons = [[NSMutableArray alloc]init];
    transactions = [[NSMutableArray alloc]init];
    
    for(int i = 0; i <= 3; i++) {
        [peerIDs addObject:[[MCPeerID alloc] initWithDisplayName:@"test"]];
        [peerButtons addObject:[[UIButton alloc] init]];
    }
    
    NSLog(@"pids = %@", peerIDs);
    
    
    
    pic = 0;
    clicked_button_index = 0;
	
    // Do any additional setup after loading the view.
    
    // Usu. only store 1 IH (from the host)
    InvitationHandlers = [[NSMutableArray alloc]init];
    
    // Initialize the peer
    _peerID = [[MCPeerID alloc]initWithDisplayName:@"peer"];
    
    [peerIDs insertObject:_peerID atIndex:0];
    
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
        
        NSString *pid = [peerID displayName];
        
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
        
        
        if([pid isEqualToString:@"D4835411-BBD6-4D68-8F67-9EC06FA085E1"]) {
            
            [peerIDs insertObject:peerID atIndex:1];

            // neel's iphone
            
            UIImage *bgImage = [UIImage imageNamed:@"nikhil.png"];
            NSLog(@"image = %@", bgImage);
            UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
            [new_peer_button setTag:1];
            CGPoint center = CGPointMake(196, 50 + 100*([[_session connectedPeers] count]));
            new_peer_button.center = center;
            [new_peer_button addTarget:self action:@selector(temp_circleClicked1) forControlEvents:UIControlEventTouchUpInside];
            [peerButtons insertObject:new_peer_button atIndex:0];
            [self fadeIn:new_peer_button];
        }
        
        else if([pid isEqualToString:@"8CE045FB-BD29-4076-A161-850307DC4174"]) {
            [peerIDs insertObject:peerID atIndex:2];

            
            // nikhil's iphone
            
            UIImage *bgImage = [UIImage imageNamed:@"kevin.png"];
            NSLog(@"image = %@", bgImage);
            UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
            [new_peer_button setTag:2];
            CGPoint center = CGPointMake(196, 50 + 100*([[_session connectedPeers] count]));
            new_peer_button.center = center;
            [new_peer_button addTarget:self action:@selector(temp_circleClicked2) forControlEvents:UIControlEventTouchUpInside];
            [peerButtons insertObject:new_peer_button atIndex:1];
            [self fadeIn:new_peer_button];
        }
        
        else if([pid isEqualToString:@"0229A3A7-B81C-4622-B7CA-F2C1FBC8549B"]) {
            [peerIDs insertObject:peerID atIndex:3];

            
            // ipod touch
            
            UIImage *bgImage = [UIImage imageNamed:@"tony.png"];
            NSLog(@"image = %@", bgImage);
            UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
            [new_peer_button setTag:3];
            CGPoint center = CGPointMake(196, 50 + 100*([[_session connectedPeers] count]));
            new_peer_button.center = center;
            [new_peer_button addTarget:self action:@selector(temp_circleClicked3) forControlEvents:UIControlEventTouchUpInside];
            [peerButtons insertObject:new_peer_button atIndex:2];
            [self fadeIn:new_peer_button];
        }
    }
    
    
    
}

-(void)temp_circleClicked1 {
        // bring up a keyboard
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        clicked_button_index = 1;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [amount_field becomeFirstResponder];

            // fade in field and enter button
            
            [UIView animateWithDuration:0.3 animations:^{
                amount_field.alpha = 1;
                enter_button.alpha = 1;
                description_field.alpha = 1;
            } completion: ^(BOOL finished) {
                
                
            }];
        });
        
    });
    
    
    
}


-(void)temp_circleClicked2 {
    // bring up a keyboard
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        clicked_button_index = 2;

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [amount_field becomeFirstResponder];
            
            // fade in field and enter button
            
            [UIView animateWithDuration:0.3 animations:^{
                amount_field.alpha = 1;
                enter_button.alpha = 1;
                description_field.alpha = 1;
            } completion: ^(BOOL finished) {
                
                
            }];
        });
        
    });
    
   
    
}


-(void)temp_circleClicked3 {
    // bring up a keyboard
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        clicked_button_index = 3;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [amount_field becomeFirstResponder];
            
            // fade in field and enter button
            
            [UIView animateWithDuration:0.3 animations:^{
                amount_field.alpha = 1;
                enter_button.alpha = 1;
                description_field.alpha = 1;
            } completion: ^(BOOL finished) {
                
                
            }];
            
        });
        
    });
    
    
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
    if(state == MCSessionStateNotConnected) {
        int index = [peerIDs indexOfObject:peerID];
        [self fadeOut:[peerButtons objectAtIndex:index - 1]];
    }
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}


- (IBAction)back_button_clicked:(id)sender {
    // TODO: Notify of payment cancellation
    
    [[self navigationController]popViewControllerAnimated:YES];
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
    
    // dismiss keyboard
    [amount_field resignFirstResponder];
    [description_field resignFirstResponder];
    
    // make the transaction

    NSError *error;
    NSString *msg = [amount_field text];
    // notify the peer
    
    NSLog(@"pids again = %@", peerIDs);
    
    [_session sendData:[msg dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:[peerIDs objectAtIndex:clicked_button_index]] withMode:MCSessionSendDataReliable error:&error];
    
    if(error) NSLog(@"the error = %@", error);
    
    
    NSString *name = @"";
    
    if(clicked_button_index == 1) {
        name = @"Nikhil Srinivasan";
    }
    else if(clicked_button_index == 2) {
        name = @"Kevin Brenner";
    }
    else if(clicked_button_index == 3) {
        name = @"Tony Puente";
    }
    
    NSArray *info = [[NSArray alloc]initWithObjects:name, [description_field text], [NSDate date], nil];
    
    [transactions addObject:info];
    
    // dismiss the circle
    [self fadeOut:[peerButtons objectAtIndex:clicked_button_index - 1]];
    
    [amount_field setText:@""];
    [description_field setText:@""];
    
    [UIView animateWithDuration:0.3 animations:^{
        amount_field.alpha = 0;
        enter_button.alpha = 0;
        description_field.alpha = 0;
    } completion: ^(BOOL finished) {
        
        
    }];
    
    
   // [feed_table reloadData];
    [feed_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [transactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSArray *info = [transactions objectAtIndex:[indexPath row]];
    
    NSDate *date = [info objectAtIndex:2];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                   dateStyle:NSDateFormatterShortStyle
                                   timeStyle:NSDateFormatterShortStyle];
    
    [[cell textLabel]setText:[info objectAtIndex:0]];
    [[cell detailTextLabel]setText:[[[info objectAtIndex:1] stringByAppendingString:@"     "]stringByAppendingString:dateString]];
    
    
    
    return cell;
    
}





@end

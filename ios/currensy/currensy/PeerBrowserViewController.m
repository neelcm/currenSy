//
//  PeerBrowserViewController.m
//  Divvy
//
//  Created by Neel Mouleeswaran on 10/10/13.
//  Copyright (c) 2013 omics. All rights reserved.
//

#import "PeerBrowserViewController.h"
#import "CustomShapes.h"

static NSString * const serviceType = @"service"; // --> it is now a hash of the user profile url (uniq)
static NSString * const messageKey = @"message-key";
static NSString * const tablesVCName = @"name"; // Generic name of every TableVC

@interface PeerBrowserViewController () <MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>

// This session keeps track of AdvertiserVC
@property (nonatomic, strong) MCSession *session;

// This browser finds AdvertiserVC with the hashed service type
@property (nonatomic, strong) MCNearbyServiceBrowser *peerBrowser;

// This advertises the tablesVC with the discovery packet
//@property (nonatomic, strong) MCNearbyServiceAdvertiser *nearbyServiceAdvertiser;

@end

@implementation PeerBrowserViewController

@synthesize peers_view;
@synthesize done_button;
@synthesize tab_name;
@synthesize bal_label;
@synthesize name_label;
@synthesize connected_label;
@synthesize arrow;

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
    
    arrow.alpha = 0;
    
    NSString *pid = [[[UIDevice currentDevice]identifierForVendor] UUIDString];
    
    
    [super viewDidLoad];
    
    connected_label.alpha = 0;
    
    UIImage *bgImage;
    
    NSLog(@"pid = %@", pid);
    
    if([pid isEqualToString:@"1FB6C90D-F22E-432A-A27F-9DA41CEC01D3"]) {
        // neel's iphone
        bgImage = [UIImage imageNamed:@"nikhil.png"];
        [name_label setText:@"Nikhil Srinivasan"];
        
    }
    
    else if([pid isEqualToString:@"8CE045FB-BD29-4076-A161-850307DC4174"]) {
        // nikhil's iphone
        bgImage = [UIImage imageNamed:@"kevin.png"];
                [name_label setText:@"Kevin Michelson"];
    }
    
    else if([pid isEqualToString:@"0229A3A7-B81C-4622-B7CA-F2C1FBC8549B"]) {
        // ipod touch
        bgImage = [UIImage imageNamed:@"tony.png"];
                [name_label setText:@"Tony Alvarez"];
    }
    
    UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
    [new_peer_button setTag:0];
    CGPoint center = CGPointMake(160, 10);
    new_peer_button.center = center;
    [self fadeIn:new_peer_button];
    
    
    // Initialize arrays
    peerIDs = [[NSMutableArray alloc]init];
    peer_slots = [[NSMutableArray alloc]init];
    peer_buttons = [[NSMutableArray alloc]init];
    
    // Set coordinates of slots in the grid
    [self setSlots];
    
    // Set the id of the host
    
    
    hostID = [[MCPeerID alloc]initWithDisplayName:pid];
    
    _peerBrowser = [[MCNearbyServiceBrowser alloc]initWithPeer:hostID serviceType:serviceType];
    _peerBrowser.delegate = self;
    
    // Initialize the session
    _session = [[MCSession alloc]initWithPeer:hostID];

    _session.delegate = self;
    
    // Start searching for peers nearby
    [_peerBrowser startBrowsingForPeers];
    
    NSLog(@"browsing for peers");
}

-(void)viewWillDisappear:(BOOL)animated {
    [_peerBrowser stopBrowsingForPeers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done_button_clicked:(id)sender {
    // What happens here
}


-(void) circleWasClicked:(UIButton *) sender  {
    
    NSLog(@"inviting %@", [peerIDs objectAtIndex:[sender tag]]);
    
    // Get the PeerID of the circle that was clicked
    MCPeerID *pID = [peerIDs objectAtIndex:[sender tag]];
    
    NSLog(@"inviting with id %@", [pID displayName]);
    
    NSData *context = [[hostID displayName] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Invite the peer with context:host_id (so the peer knows it's being connected)
    [_peerBrowser invitePeer:pID toSession:_session withContext:context timeout:30];
}

-(void)temp_circleClicked {

    
    
    [_peerBrowser invitePeer:[peerIDs objectAtIndex:0] toSession:_session withContext:nil timeout:30];
    
}


-(void)createCircle:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    // Extract the first name from the full name
    //NSString *full_name = [info objectForKey:@"display_name"];
    //NSString *first_name = [[full_name componentsSeparatedByString:@" "] objectAtIndex:0];
    
    int tag = [[NSNumber numberWithInteger:[peerIDs indexOfObject:peerID]]intValue];
    
    // Background image is high-res profile picture
    UIImage *bgImage = [UIImage imageNamed:@"neel.png"];
    
    NSLog(@"image = %@", bgImage);
    
    UIButton *new_peer_button = [CustomShapes createCircleWithImage:bgImage];
    
    // Button tag = array index
    [new_peer_button setTag:tag];
    
    // Find out where to put the button
    CGPoint center = [self findCenter];
    new_peer_button.center = center;
    
    //[new_peer_button addTarget:self action:@selector(temp_circleClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [new_peer_button setUserInteractionEnabled:NO];
    
    [self temp_circleClicked];
    
    [self fadeIn:new_peer_button];
    
    
    
    // fade in and out merch label
    [UIView animateWithDuration:0.75
                     animations:^(void) {
                         connected_label.alpha = 1;
                         arrow.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"animation finished");
                     }];

    
    [UIView animateWithDuration:0.5
                          delay:4.0
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^(void) {
                         connected_label.alpha = 0;
                     }
                     completion:^(BOOL finished){
                        
                         
                     }];
    
    
    
    [peer_buttons addObject:new_peer_button];
    
}

-(UIButton *)getButtonForTag: (int)tag {
    
    return (UIButton *)[peers_view viewWithTag:tag];
}


// Found an advertiser, add them to the session
-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    if(![peerIDs containsObject:peerID]) {
        NSLog(@"creating circle for %@", peerID);
        
        // Add this peerID to the list of active peers
        [peerIDs addObject:peerID];
        
        // Create a circle for this peer
        [self createCircle:peerID withDiscoveryInfo:info];
    }
    
  
    
}


// If a peer is lost, its respective button needs to be removed
-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
    NSLog(@"lost peer: %@", [peerID displayName]);

    
    int index = [peerIDs indexOfObject:peerID];
    
    UIButton *button = (UIButton *)[peer_buttons objectAtIndex:index];
    
    // Mark spot on the grid as free
    [self markSlotAsFree:[button center]];
    
    /*
    [UIView animateWithDuration:1.5
                     animations:^(void) {
                         [[[button subviews]objectAtIndex:0]setAlpha:0];
                         [[[button subviews]objectAtIndex:1]setAlpha:0.7];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"animation finished");
                         [self fadeOut:button];
                     }];
     
     */
    
    [self fadeOut:button]; 
    
    
    [peerIDs removeObjectAtIndex:index];
    [peer_buttons removeObjectAtIndex:index];
    
    NSLog(@"now connected peers = %@", [_session connectedPeers]);
    
    // Reflect the loss of a peer to all the tables
  //  [self performSelectorInBackground:@selector(updateTables) withObject:nil];
    
}


// Filters the connected peers and finds out which ones are advertisers
-(int)numberOfConnectedAdvertisers: (NSArray *)connected_peers {
    
    int i;
    int num_connected_advertisers = 0;
    
    // A peer is an advertiser if it's not the peerID of a TablesVC (DisplayName = tablesVCName) and it's not the empty id (DisplayName = @"no_object")
    
    NSArray *copy = [connected_peers copy];
    
    for(i=0;i<[copy count];i++) {
        if(![[(MCPeerID *)[copy objectAtIndex:i]displayName]isEqualToString:tablesVCName] && ![[(MCPeerID *)[copy objectAtIndex:i]displayName]isEqualToString:@"no_object"]) {
            num_connected_advertisers++;
        }
    }
    
    return num_connected_advertisers;
}

// Sets up the 3x3 grid with 2D locations
-(void)setSlots {
    
    NSMutableArray *slot0 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:50], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot1 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:130], [NSNumber numberWithInt:50], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot2 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:210], [NSNumber numberWithInt:50], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot3 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:130], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot4 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:130], [NSNumber numberWithInt:130], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot5 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:210], [NSNumber numberWithInt:130], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot6 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:50], [NSNumber numberWithInt:210], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot7 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:130], [NSNumber numberWithInt:210], [NSNumber numberWithInt:0], nil];
    
    NSMutableArray *slot8 = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:210], [NSNumber numberWithInt:210], [NSNumber numberWithInt:0], nil];
    
    [peer_slots addObject:slot0];
    [peer_slots addObject:slot1];
    [peer_slots addObject:slot2];
    [peer_slots addObject:slot3];
    [peer_slots addObject:slot4];
    [peer_slots addObject:slot5];
    [peer_slots addObject:slot6];
    [peer_slots addObject:slot7];
    [peer_slots addObject:slot8];
    
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

// Finds the CGPoint of the center of a button as per the next available spot on the grid
-(CGPoint)findCenter {
    
    return CGPointMake(160, 130);
    
    /*
    for(int i = 0; i < [peer_slots count]; i++) {
        NSMutableArray *slotI = [peer_slots objectAtIndex:i];
        
        // NSLog(@"spot 2 = %d, i=%d", [(NSNumber *)[slotI objectAtIndex:2] integerValue], i);
        
        if([(NSNumber *)[slotI objectAtIndex:2] integerValue] == 0) {
            // We have a free slot
            
            // Mark this slot as taken
            [slotI replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:1]];
            
            [peer_slots replaceObjectAtIndex:i withObject:slotI];
            
            // NSLog(@"spot 2 replaced = %d, i=%d", [(NSNumber *)[slotI objectAtIndex:2] integerValue], i);
            
            // UNDO
            return CGPointMake([(NSNumber *)[slotI objectAtIndex:0] integerValue], [(NSNumber *)[slotI objectAtIndex:1] integerValue]);
            
        }
    }
    
    return CGPointMake(-1, -1);
     
     */
}

-(void)markSlotAsFree: (CGPoint)center {
    
    // Grab the x and y coordinates
    int x = center.x;
    int y = center.y;
    
    for(int i = 0; i < [peer_slots count]; i++) {
        NSMutableArray *slotI = [peer_slots objectAtIndex:i];
        
        if(x == [(NSNumber *)[slotI objectAtIndex:0]integerValue] && y == [(NSNumber *)[slotI objectAtIndex:1]integerValue]) {
            
            // Found the slot
            
            // Mark this slot as free
            [slotI replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:0]];
            
            [peer_slots replaceObjectAtIndex:i withObject:slotI];
        }
    }
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
    NSLog(@"Did finish receiving resource");
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *amt = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction complete - " message:[@"You sent ฿" stringByAppendingString:amt] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [alert show];
                        
        });
        
    });
    
    
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"Received stream");
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
    NSLog(@"Did start receiving resource");
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    //
    NSLog(@"state changed");
}

- (void)nearbyConnectionDataForPeer:(MCPeerID *)peerID withCompletionHandler:(void (^)(NSData *connectionData, NSError *error))completionHandler {
    
}

- (IBAction)back_button_clicked:(id)sender {
    // End the session/advertiser etc
    [self viewWillDisappear:YES];
    [[self navigationController]popViewControllerAnimated:YES];
}


@end

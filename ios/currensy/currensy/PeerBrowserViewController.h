//
//  PeerBrowserViewController.h
//  Divvy
//
//  Created by Neel Mouleeswaran on 02/14/2014.
//  Copyright (c) 2014 bitpass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PeerBrowserViewController : UIViewController <MCNearbyServiceBrowserDelegate, MCSessionDelegate> {
    
    NSMutableArray *peerIDs; // Stores every PeerID seen
   // NSMutableArray *tablePeerIDs; // PeerID of every table that sent this Peer data
    
    NSMutableArray *peer_buttons; // Stores UIButton* for every peer seen
    MCPeerID *clicked_peerID; // PeerID of the clicked circle
    
    MCPeerID *hostID; // This VC MCPeerID
    
    NSMutableArray *peer_slots; // "Slots" in the 3x3 grid for circles to populate
    
}
@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UIView *peers_view;
@property (weak, nonatomic) IBOutlet UILabel *tab_name;
@property (weak, nonatomic) IBOutlet UILabel *bal_label;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property (weak, nonatomic) IBOutlet UIButton *done_button;
- (IBAction)enter_clicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *connected_label;

- (IBAction)back_button_clicked:(id)sender;
- (IBAction)done_button_clicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *enter_button;
@property (weak, nonatomic) IBOutlet UITextField *amount_field;

-(void) circleWasClicked:(UIButton *) sender;

-(void)createCircle:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info;

-(void)temp_circleClicked;

@end

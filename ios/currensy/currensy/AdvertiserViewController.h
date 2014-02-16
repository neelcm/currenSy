//
//  AdvertiserViewController.h
//  Divvy
//
//  Created by Neel Mouleeswaran on 10/11/13.
//  Copyright (c) 2013 omics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertiserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    __weak IBOutlet UIView *peers_view;
    NSMutableArray *InvitationHandlers; // Stores all invitation handlers (MCSession *) from nearby peers
    NSData *invitationData; // Invitation data from the peer (usu. host) - contains user id
    NSData *decryptedInvitationData; // Decrypted version of invitationData
    
    NSMutableArray *peerIDs;
    NSMutableArray *peerButtons;
    
    NSMutableArray *invoices;
    NSMutableArray *invoice_list;
    
    
    NSMutableArray *transactions;
    
    __weak IBOutlet UITextField *payment_field;
    __weak IBOutlet UILabel *wait_message_field;
    
    int pic;
    
    int clicked_button_index;
    
}
@property (weak, nonatomic) IBOutlet UITextField *description_field;

@property (weak, nonatomic) IBOutlet UITextField *amount_field;

@property (weak, nonatomic) IBOutlet UIButton *enter_button;

@property (weak, nonatomic) IBOutlet UITableView *invoice_table;

- (IBAction)enter_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_indicator;
@property (weak, nonatomic) IBOutlet UIButton *pay_button;
@property (weak, nonatomic) IBOutlet UINavigationBar *nav_bar;
@property (weak, nonatomic) IBOutlet UILabel *bal_label;
- (IBAction)done_clicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *feed_table;

@end

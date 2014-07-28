//
//  StartViewController.h
//  In Rhythm
//
//  Created by Mark Meyer on 7/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SCUI.h"

#import "TrackListTableViewController.h"

@interface StartViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)startBtnTapped:(id)sender;
- (IBAction)searchBtnTapped:(id)sender;
- (IBAction)loginBtnTapped:(id)sender;

@end

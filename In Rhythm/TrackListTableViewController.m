//
//  TrackListTableViewController.m
//  In Rhythm
//
//  Created by Mark Meyer on 7/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "TrackListTableViewController.h"

@implementation TrackListTableViewController

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    cell.textLabel.text = [track objectForKey:@"title"];
    cell.detailTextLabel.text = [[track objectForKey:@"user"] objectForKey:@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
    NSString *streamURL = [track objectForKey:@"stream_url"];
    
    SCAccount *account = [SCSoundCloud account];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 self.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [self.player prepareToPlay];
                 [self.player play];
                 //NSLog(@"%@", [self.player.settings allKeys]);
                 NSLog(@"Channel Layout: %@", [self.player.settings objectForKey:AVChannelLayoutKey]);
                 NSLog(@"Bit rate: %@", [self.player.settings objectForKey:AVEncoderBitRateKey]);
                 NSLog(@"Format: %@", [self.player.settings objectForKey:AVFormatIDKey]);
                 NSLog(@"Sample Rate: %@", [self.player.settings objectForKey:AVSampleRateKey]);
             }];
}
@end

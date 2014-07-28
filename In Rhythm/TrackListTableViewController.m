//
//  TrackListTableViewController.m
//  In Rhythm
//
//  Created by Mark Meyer on 7/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "TrackListTableViewController.h"

@implementation TrackListTableViewController

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
    AudioPlayer *aplayer = [AudioPlayer sharedInstance];
    aplayer.track = [[NSDictionary alloc] initWithDictionary:track];
    
    NSString *streamURL = [track objectForKey:@"stream_url"];
    
    SCAccount *account = [SCSoundCloud account];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:streamURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *playerError;
                 AudioPlayer *aplayer = [AudioPlayer sharedInstance];
                 
                 aplayer.player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                 [aplayer.player prepareToPlay];
                 [aplayer.player setMeteringEnabled:YES];
                 [self performSegueWithIdentifier:@"playSegue" sender:nil];
             }];
}
@end

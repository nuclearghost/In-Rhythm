//
//  AudioPlayer.h
//  In Rhythm
//
//  Created by Mark Meyer on 7/27/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (AudioPlayer*)sharedInstance;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSDictionary *track;

@end

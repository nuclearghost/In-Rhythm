//
//  MyScene.m
//  In Rhythm
//
//  Created by Mark Meyer on 7/26/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "MyScene.h"
#import "MeterTable.h"

@implementation MyScene {
    MeterTable meterTable;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        AudioPlayer *aplayer = [AudioPlayer sharedInstance];
        
        myLabel.text = [aplayer.track objectForKey:@"title"];
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    AudioPlayer *aplayer = [AudioPlayer sharedInstance];
    [aplayer.player play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*
     for (UITouch *touch in touches) {
     CGPoint location = [touch locationInNode:self];
     
     SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
     
     sprite.position = location;
     
     SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
     
     [sprite runAction:[SKAction repeatActionForever:action]];
     
     [self addChild:sprite];
     }
     */
}

-(void)update:(CFTimeInterval)currentTime {
    AudioPlayer *aplayer = [AudioPlayer sharedInstance];
    [aplayer.player updateMeters];
    
    float scale = 0.5;
    
    float power = 0.0f;
    for (int i = 0; i < [aplayer.player numberOfChannels]; i++) {
        power += [aplayer.player averagePowerForChannel:i];
    }
    power /= [aplayer.player numberOfChannels];
    
    float level = meterTable.ValueAt(power);
    scale = level * 5;
    
    NSLog(@"Power: %f, Level: %f, Scale: %f", power, level, scale);

    
    //[emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.scale"];
}

@end
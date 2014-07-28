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
    NSMutableArray *emitterArray;
    int birthRate;
    int emitterInsertPos;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        AudioPlayer *aplayer = [AudioPlayer sharedInstance];

        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = [aplayer.track objectForKey:@"title"];
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        self->birthRate = 100;
        self->emitterInsertPos = 0;
        self->emitterArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    AudioPlayer *aplayer = [AudioPlayer sharedInstance];
    [aplayer.player play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        //add effect at touch location
        if ([self->emitterArray count] == 5) {
            SKEmitterNode *toRemove = self->emitterArray[self->emitterInsertPos];
            [toRemove removeFromParent];
            [self->emitterArray removeObjectAtIndex:self->emitterInsertPos];
        }
        SKEmitterNode *newEmitter = [self newExplosion:location.x : location.y];
        [self addChild: newEmitter];
        [self->emitterArray insertObject:newEmitter atIndex:self->emitterInsertPos];
        self->emitterInsertPos = (self->emitterInsertPos + 1) % 5;
        //self->birthRate = 100 / [self->emitterArray count];
    }
}

- (SKEmitterNode *) newExplosion: (float)posX : (float) posy
{
    SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"SparkParticle" ofType:@"sks"]];
    emitter.position = CGPointMake(posX,posy);
    //emitter.name = @"explosion";
    //emitter.targetNode = self.scene;
    //emitter.zPosition=2.0;
    return emitter;
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
    scale = level * 2;
    
    
    NSLog(@"Power: %f, Level: %f, Scale: %f, Birth Rate: %d", power, level, scale, self->birthRate);

    
    for (int i = 0; i < [self->emitterArray count]; ++i){
        SKEmitterNode *emitterNode = self->emitterArray[i];
        emitterNode.particleScale = scale;
        emitterNode.particleBirthRate = self->birthRate * scale;
    }
     
}

@end

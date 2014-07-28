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
    int maxEmitters;
    double samples;
    double x1;
    double x2;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:0.36 blue:0 alpha:1.0];
        
        AudioPlayer *aplayer = [AudioPlayer sharedInstance];
        
        [self createLabels:aplayer.track];
        
        self->birthRate = 100;
        self->emitterInsertPos = 0;
        self->maxEmitters = 5;
        self->emitterArray = [[NSMutableArray alloc] initWithCapacity:self->maxEmitters];
        
        self->samples = 0;
        self->x1 = 0;
        self->x2 = 0;
    }
    return self;
}

/*
 - (void)didMoveToView:(SKView *)view {
 AudioPlayer *aplayer = [AudioPlayer sharedInstance];
 [aplayer.player play];
 }
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    AudioPlayer *aplayer = [AudioPlayer sharedInstance];
    if (![aplayer.player isPlaying]) {
        [aplayer.player play];
        
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            [self addEmitter:location];
        }
        
        [self.vc.navigationController setNavigationBarHidden:YES animated:YES];
        
        [self enumerateChildNodesWithName:@"tap" usingBlock: ^(SKNode *node, BOOL *stop)
         {
             [node removeFromParent];
         }];
    } else {
        [self.vc.navigationController setNavigationBarHidden:!self.vc.navigationController.navigationBarHidden animated:YES];
    }
    
}

- (void) addEmitter:(CGPoint)location {
    if ([self->emitterArray count] == self->maxEmitters) {
        SKEmitterNode *toRemove = self->emitterArray[self->emitterInsertPos];
        [toRemove removeFromParent];
        [self->emitterArray removeObjectAtIndex:self->emitterInsertPos];
    }
    SKEmitterNode *newEmitter = [self newExplosion:location.x : location.y];
    [self addChild: newEmitter];
    [self->emitterArray insertObject:newEmitter atIndex:self->emitterInsertPos];
    self->emitterInsertPos = (self->emitterInsertPos + 1) % self->maxEmitters;
}

- (SKEmitterNode *) newExplosion: (float)posX : (float) posy
{
    SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"SparkParticle" ofType:@"sks"]];
    emitter.position = CGPointMake(posX,posy);
    return emitter;
}

-(void)update:(CFTimeInterval)currentTime {
    AudioPlayer *aplayer = [AudioPlayer sharedInstance];
    
    if ([aplayer.player isPlaying]) {
        [aplayer.player updateMeters];
        
        float scale = 0.5;
        float power = 0.0f;
        
        for (int i = 0; i < [aplayer.player numberOfChannels]; i++) {
            power += [aplayer.player averagePowerForChannel:i];
        }
        power /= [aplayer.player numberOfChannels];
        
        float level = meterTable.ValueAt(power);
        scale = level * 2;
        
        for (int i = 0; i < [self->emitterArray count]; ++i){
            SKEmitterNode *emitterNode = self->emitterArray[i];
            emitterNode.particleScale = scale;
            emitterNode.particleBirthRate = self->birthRate * scale;
        }
        
        self->samples++;
        self->x1 += scale;
        self->x2 += pow(scale, 2);
        
        double mean = self->x1/self->samples;
        
        double stddev = sqrt((self->x2/self->samples) - pow(mean, 2));
        
        //NSLog(@"Power: %f, Level: %f, Scale: %f, Mean:%f, StdDev: %f", power, level, scale, mean, stddev);
        
        if (self->samples > 300 && scale - mean > stddev) {
            [self addEmitter:CGPointMake( (CGFloat)(arc4random() % (int)self.scene.size.width), (CGFloat)(arc4random() % (int)self.scene.size.height))];
        }
    }
}

- (void) createLabels:(NSDictionary *)track {
    SKLabelNode *titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    titleLabel.text = [track objectForKey:@"title"];
    titleLabel.fontSize = 20;
    titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
    [self addChild:titleLabel];
    
    SKLabelNode *artistLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    artistLabel.text = [[track objectForKey:@"user"] objectForKey:@"username"];
    artistLabel.fontSize = 18;
    artistLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame) - 30);
    [self addChild:artistLabel];
    
    SKLabelNode *tapLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    tapLabel.text = @"Tap to Play";
    tapLabel.name = @"tap";
    tapLabel.fontSize=20;
    tapLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                    CGRectGetMidY(self.frame) - 120);
    [self addChild:tapLabel];
}

@end

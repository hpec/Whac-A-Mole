/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#include <stdlib.h>
#define WIDTH_WINDOW 480
#define HEIGHT_WINDOW 320
#define MARGIN 20
#define NUM_ROWS 4
#define NUM_COLUMNS 6
#define DELAY_IN_SECONDS 0.15
#define NUM_MICE 16


@interface GameLayer (PrivateMethods)
@end

NSMutableArray* grid;
NSMutableArray* mice;
NSMutableArray* has_mice;
NSMutableArray* control_buttons;
CCDirector* director;

int score;
bool died;



@implementation GameLayer

@synthesize helloWorldString, helloWorldFontName;
@synthesize helloWorldFontSize;

-(id) init
{
	if ((self = [super init]))
	{
        CCLOG(@"%@ init", NSStringFromClass([self class]));

        CCSprite *sprite = [CCSprite spriteWithFile:@"grass_texture.jpg"];
//        CCSprite *pause =[CCSprite spriteWithFile:@"pause_button.png"];
//        CCSprite *resume =[CCSprite spriteWithFile:@"images.jpeg"];
//        pause.position = ccp(30,30);
//        resume.position = ccp(450,20);
        
//        control_buttons = [[NSMutableArray alloc] init];
//        [control_buttons addObject:pause];
//        [control_buttons addObject:resume];
        
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:-1];
//        [self addChild:pause];
//        [self addChild:resume];


        died = false;
        grid = [[NSMutableArray alloc] init];
        for (int row = 0; row < NUM_ROWS; row++ )
        {
            NSMutableArray* subArr = [[NSMutableArray alloc] init ];
            for (int col = 0; col < NUM_COLUMNS; col++ )
            {
                NSNumber *item = @0;
                [subArr addObject:item];
            }
            [grid addObject:subArr];
        }


		director = [CCDirector sharedDirector];

		// get the hello world string from the config.lua file
		[KKConfig injectPropertiesFromKeyPath:@"HelloWorldSettings" target:self];

		glClearColor(0.2f, 0.2f, 0.4f, 1.0f);


        // initiate mice.

        has_mice = [[NSMutableArray alloc] init ];
        mice =[[NSMutableArray alloc] init];
        for (int i = 0; i < NUM_MICE; i ++)[mice addObject:[NSNull null]];

        for (int i = 0; i < 16; i++)
        {
            NSNumber *item = [NSNumber numberWithInt: 0];
            [has_mice addObject:item];
        }

        [self schedule:@selector(nextFrame) interval:1];
        [self scheduleUpdate];
	}

	return self;
}

-(void) draw
{


}


-(void) update: (ccTime) delta
{

    KKInput* input = [KKInput sharedInput];
    CGPoint pos       = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
    CGPoint pause_pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
    CGPoint resume_pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
    


    if([input anyTouchEndedThisFrame])
    {
        if (!died){
            for (int i = 0; i < NUM_MICE; i++) {
                CCSprite *mouse = [mice objectAtIndex:i];
                if (mouse!=(id)[NSNull null] && CGRectContainsPoint(mouse.boundingBox, pos)) {
                    NSLog(@"Hit" );
                    [self removeChild:mouse];
                    [mice replaceObjectAtIndex:i withObject:[NSNull null]];
                }
//                CCSprite *pause =  [control_buttons objectAtIndex:0];
//                CCSprite *resume = [control_buttons objectAtIndex:1];
//                if (CGRectContainsPoint(pause.boundingBox,pause_pos)){
////                    [[CCDirector sharedDirector] stopAnimation];
//                    [[CCDirector sharedDirector] pause];
//                }
//                if (CGRectContainsPoint(resume.boundingBox,resume_pos)){
//                    [[CCDirector sharedDirector] stopAnimation];
//                    [[CCDirector sharedDirector] resume];
//                    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
//                    [[CCDirector sharedDirector] startAnimation];
//                }
                
                }
            }
        }
        
    }



-(void) nextFrame
{
    if (!died) {
        [self addMouse];
    }
}

-(void) addMouse
{
    NSMutableArray* no_mice_arr = [[NSMutableArray alloc] init ];
    for (int i = 0; i < NUM_MICE;i++){
        CCSprite *mouse = [mice objectAtIndex:i];
        if (mouse==(id)[NSNull null]){
            NSNumber *item  = [NSNumber numberWithInt: i];
            [no_mice_arr addObject:item];
        }
        
    }
    NSUInteger arrayLength = [no_mice_arr count];

    int length = (int)arrayLength;

    if (length != 0){
        int r = arc4random() % length;

        NSNumber *idx = [no_mice_arr objectAtIndex:r];
        int mice_index = [idx integerValue];

        NSNumber *one = [NSNumber numberWithInt:1];
        [has_mice replaceObjectAtIndex:mice_index withObject:one];

        // get mouse co-or
        int row_idx = mice_index/4;
        int col_idx = mice_index%4;
        float row_unit = WIDTH_WINDOW/4;
        float col_unit = HEIGHT_WINDOW/4;
        float x = row_idx*row_unit + row_unit/2;
        float y = col_idx*col_unit + col_unit/2;

        CCSprite *a_mouse =[CCSprite spriteWithFile: @"cut_mouse.png"];
        a_mouse.position = ccp(x,y);
        [mice replaceObjectAtIndex:mice_index withObject:a_mouse];
        [self addChild:a_mouse];
    }
    else{
        died = true;
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"You Lost!"
                                               fontName:helloWorldFontName
                                               fontSize:helloWorldFontSize];
        label.position = director.screenCenter;
        label.color = ccRED;
        [self addChild:label z:100];
    }
}


@end

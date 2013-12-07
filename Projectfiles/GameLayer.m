/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim.
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#include <stdlib.h>
//#define WIDTH_WINDOW 480
//#define HEIGHT_WINDOW 320
#define MARGIN 20
#define NUM_ROWS 4
#define NUM_COLUMNS 6
#define DELAY_IN_SECONDS 0.01
#define NUM_MICE 16


@interface GameLayer (PrivateMethods)
@end

NSMutableArray* grid;
NSMutableArray* mice;
NSMutableArray* has_mice;
NSMutableArray* control_buttons;
int WIDTH_WINDOW;
int HEIGHT_WINDOW;
CCDirector* director;
CCMenu *restartButton;
CCLabelTTF* score_label;
float timePassed;
float difficulty;
int mice_left_to_increase_difficulty;

int score;
bool died;



@implementation GameLayer

@synthesize helloWorldString, helloWorldFontName;
@synthesize helloWorldFontSize;

-(void) setInitialValues {
    CGSize size = [UIScreen mainScreen].bounds.size;
    WIDTH_WINDOW = size.height;
    HEIGHT_WINDOW = size.width;
    score = 0;
    died = false;
    timePassed = 0;
    difficulty = 0.7;
    mice_left_to_increase_difficulty = 6;
    CCMenuItemImage *menuItem = [CCMenuItemImage itemWithNormalImage:@"vid_replay.png"
                                                       selectedImage:@"vid_replay.png"
                                                              target:self
                                                            selector:@selector(restart)];
    
    restartButton = [CCMenu menuWithItems:menuItem, nil];
    restartButton.position = ccp(WIDTH_WINDOW/2, HEIGHT_WINDOW/2 - 50);;
}

-(void) restart {
    [self removeChild:restartButton];
    for (int i = 0; i < NUM_MICE; i++) {
        [self removeChild:[mice objectAtIndex:i]];
        [mice replaceObjectAtIndex:i withObject:(id)[NSNull null]];
    }
    [self setInitialValues];
    [score_label setString:[NSString stringWithFormat:@"Score: %d", score]];

}

-(id) init
{
	if ((self = [super init]))
	{
        [self setInitialValues];
        
        CCLOG(@"%@ init", NSStringFromClass([self class]));

        CCSprite *sprite = [CCSprite spriteWithFile:@"freeze-cheese.jpeg"];
        [self resizeSprite:sprite toWidth:WIDTH_WINDOW toHeight:HEIGHT_WINDOW];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:-1];
        
//        CCSprite *pause =[CCSprite spriteWithFile:@"pause_button.png"];
//        CCSprite *resume =[CCSprite spriteWithFile:@"images.jpeg"];
//        pause.position = ccp(30,30);
//        resume.position = ccp(450,20);
        
//        control_buttons = [[NSMutableArray alloc] init];
//        [control_buttons addObject:pause];
//        [control_buttons addObject:resume];
        
        
//        [self addChild:pause];
//        [self addChild:resume];

		director = [CCDirector sharedDirector];
        
        

        // initiate mice.

        has_mice = [[NSMutableArray alloc] init ];
        mice =[[NSMutableArray alloc] init];
        for (int i = 0; i < NUM_MICE; i ++)[mice addObject:[NSNull null]];

        for (int i = 0; i < 16; i++)
        {
            NSNumber *item = [NSNumber numberWithInt: 0];
            [has_mice addObject:item];
        }
        
        // init score labels
        
        score_label = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Helvetica" fontSize:24];
        score_label.position = ccp(WIDTH_WINDOW - 100, HEIGHT_WINDOW - 20);
        [self addChild:score_label];

        [self schedule:@selector(nextFrame) interval:DELAY_IN_SECONDS];
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
                    [self removeChild:mouse];
                    [mice replaceObjectAtIndex:i withObject:[NSNull null]];
                    score += 100;
                    mice_left_to_increase_difficulty--;
                    if (mice_left_to_increase_difficulty <=0) {
                        difficulty = max(difficulty - 0.1, difficulty * 4 / 5);
                        mice_left_to_increase_difficulty = 6;
                    }
                    [score_label setString:[NSString stringWithFormat:@"Score: %d", score]];
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
        timePassed += DELAY_IN_SECONDS;
        if (timePassed >= difficulty) {
            [self addMouse];
            timePassed = 0;
        }
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
        float col_unit = HEIGHT_WINDOW*0.9/4;
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
        [self addChild:label z:1000];
//        CCLabelBMFont *startLabel = [CCLabelBMFont labelWithString:@"Restart Game" fntFile:<#(NSString *)#>];
//        CCMenuItemLabel *startItem = [CCMenuItemLabel itemWithLabel:startLabel target:self selector:@selector(restart:)];
//        startItem.scale = 1;
//        CCMenuItemSprite *playButton = CCMenuItemSprite::create(GameButton::buttonWithText("Restart!", true), NULL, this, menu_selector());
//        CCMenu *menu = [CCMenu menuWithItems:startItem,nil];
//        menu.position = ccp(WIDTH_WINDOW / 2, HEIGHT_WINDOW / 2 - 20);
//        [self addChild:menu];

        [self addChild:restartButton];
    }
}

-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}

@end

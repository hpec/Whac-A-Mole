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
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:-1];

        
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
        
				
		CCDirector* director = [CCDirector sharedDirector];

		// get the hello world string from the config.lua file
		[KKConfig injectPropertiesFromKeyPath:@"HelloWorldSettings" target:self];
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:helloWorldString 
											   fontName:helloWorldFontName 
											   fontSize:helloWorldFontSize];
		label.position = director.screenCenter;
		label.color = ccGREEN;
		[self addChild:label];

		// print out which platform we're on
		NSString* platform = @"(unknown platform)";
		
		if (director.currentPlatformIsIOS)
		{
			// add code 
			platform = @"iPhone/iPod Touch";
			
			if (director.currentDeviceIsIPad)
				platform = @"iPad";

			if (director.currentDeviceIsSimulator)
				platform = [NSString stringWithFormat:@"%@ Simulator", platform];
		}
		else if (director.currentPlatformIsMac)
		{
			platform = @"Mac OS X";
		}
		
		CCLabelTTF* platformLabel = nil;
		if (director.currentPlatformIsIOS) 
		{
			// how to add custom ttf fonts to your app is described here:
			// http://tetontech.wordpress.com/2010/09/03/using-custom-fonts-in-your-ios-application/
			float fontSize = (director.currentDeviceIsIPad) ? 48 : 28;
			platformLabel = [CCLabelTTF labelWithString:platform 
											   fontName:@"Ubuntu Condensed"
											   fontSize:fontSize];
		}
		else if (director.currentPlatformIsMac)
		{
			// Mac builds have to rely on fonts installed on the system.
			platformLabel = [CCLabelTTF labelWithString:platform 
											   fontName:@"Zapfino" 
											   fontSize:32];
		}

		platformLabel.position = director.screenCenter;
		platformLabel.color = ccYELLOW;
		[self addChild:platformLabel];
		
		id movePlatform = [CCMoveBy actionWithDuration:0.2f 
											  position:CGPointMake(0, 50)];
		[platformLabel runAction:movePlatform];
        
        
		glClearColor(0.2f, 0.2f, 0.4f, 1.0f);
        
        [self schedule:@selector(nextFrame) interval:DELAY_IN_SECONDS];
        
        // initiate mice.
        
        has_mice = [[NSMutableArray alloc] init ];
//        for (int count = 0; count < 10; count++ )
//        {
//            
//            
//            CCSprite *a_mouse =[CCSprite spriteWithFile: @"cut_mouse.png"];
//            int x = arc4random()%200;
//            int y = arc4random()%200;
//            a_mouse.position =ccp(x,y);
//            
//            [mice addObject:a_mouse];
//        }
//        
//        for (CCSprite* a_mouse in mice){
//            [self addChild:a_mouse];
//        }
//        [self scheduleUpdate];
        
    

        for (int i = 0; i < 16; i++)
        {
            NSNumber *item = [NSNumber numberWithInt: 0];
            [has_mice addObject:item];
        }
        printf("****\n");
        NSLog(@"array: %@", has_mice);
        printf("&&&&\n");
        //[self addMouse];
	}

	return self;
}

-(void) draw
{
//    float cellWidth = (WIDTH_WINDOW - 2 * MARGIN) / NUM_COLUMNS;
//    float cellHeight = (HEIGHT_WINDOW - 2 * MARGIN) / NUM_ROWS;
//    ccColor4F rectColor = ccc4f(0.5, 0.5, 0.5, 1.0);
//    for (int i = 0; i < NUM_COLUMNS; i++) {
//        for (int j = 0; j < NUM_ROWS; j++) {
//            ccDrawRect(ccp(MARGIN + i * cellWidth, MARGIN + j * cellHeight), ccp(MARGIN + (i+1) * cellWidth, MARGIN + (j+1) * cellHeight));
//        }
//    }
//    glEnable(GL_LINE_SMOOTH);
//    glColor4ub(255, 255, 255, 255);
//    glLineWidth(2);
//    CGPoint vertices2[] = { ccp(79,299), ccp(134,299), ccp(134,229), ccp(79,229) };
//    ccDrawPoly(vertices2, 4, YES);

}


-(void) update: (ccTime) delta
{
    
    KKInput* input = [KKInput sharedInput];
    CGPoint pos = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
    
//    if ([input anyTouchBeganThisFrame])
//    {
//        int x = pos.x;
//        int y = pos.y;
//        if(x >= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
//            if (done == true)
//            {
//                done = false;
//            }
//            else
//            {
//                done = true;
//            }
//            else if (x <= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET) {
//                [self resetArrays];
//                done = true;
//            }
//            else
//            {
//                int row = (y - Y_OFF_SET) / CELL_WIDTH;
//                int col = x / CELL_WIDTH;
//                
//                if([[[grid objectAtIndex:row] objectAtIndex: col] integerValue] == 1)
//                {
//                    [[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@0];
//                }
//                else
//                {
//                    [[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@1];
//                }
//            }
//    }
//    
//    
//    else if ([input anyTouchEndedThisFrame])
//    {
//        priorX = 500;
//        priorY = 500;
//    }
    
//    if([input touchesAvailable])
//    {
//		{
//			float x = pos.x;
//			float y = pos.y;
//			
//			if(x >= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
//			{
//			}
//			else if(x <= WIDTH_WINDOW / 2 && y > HEIGHT_GAME + Y_OFF_SET)
//			{
//			}
//			else
//			{
//				int row = (int)(y - Y_OFF_SET) / CELL_WIDTH;
//				int col = (int)x / CELL_WIDTH;
//				float y1 = (float) ((y - 21.0) / 20.0);
//				float x1 = (float) (x / 20.0);
//				float cellYSmall = row;
//				float cellYBig = row + 1;
//				float cellXSmall = col;
//				float cellXBig = col + 1;
//				
//				if ((priorX != 500.0)
//					&& ((priorX < cellXSmall && x1 > cellXSmall && (double) row <= y1 && (double) row >= y1 - 1.0)
//                        || (priorX > cellXBig && x1 < cellXBig && (double) row <= y1 && (double) row >= y1 - 1.0)
//                        || (priorY > cellYBig && y1 < cellYBig && (double) col <= x1 && (double) col >= x1 - 1.0)
//                        || (priorY < cellYSmall && y1 > cellXSmall && (double) col <= x1 && (double) col >= x1 - 1.0))
//					)
//				{
//                    
//					//make corresponding position in array alive or dead
//					if([[[grid objectAtIndex:row] objectAtIndex: col] integerValue] == 1)
//					{
//						[[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@0];
//                        //an abbreviation for [NSNumber numberWithInt: 0] is @0
//					}
//					else
//					{
//						[[grid objectAtIndex:row] replaceObjectAtIndex:col withObject:@1];
//                        //an abbreviation for [NSNumber numberWithInt: 1] is @1
//					}
//				}
//				priorX = x1;
//				priorY = y1;
//			}
//		}
//    }
    
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
        NSNumber *mynum = [has_mice objectAtIndex:i];
        int x = [mynum integerValue];
        if (x == 0){
            NSNumber *item = [NSNumber numberWithInt: i];
            [no_mice_arr addObject:item];
        }
    }
    NSUInteger arrayLength = [no_mice_arr count];
  
    int length = (int)arrayLength;

    if (length != 0){
        int r = arc4random() % length;

        NSNumber *idx = [no_mice_arr objectAtIndex:r];
        int mice_index = [idx integerValue];
        printf("***********\n");
        printf("%d\n",mice_index);
        printf("&&&&&&&&\n");
//        printf("%d", length);
        NSNumber *one = [NSNumber numberWithInt:1];
        [has_mice replaceObjectAtIndex:mice_index withObject:one];
        
        // get mouse co-or
        int row_idx = mice_index/4;
        int col_idx = mice_index%4;
        float row_unit = WIDTH_WINDOW/4;
        float col_unit = HEIGHT_WINDOW/4;
        float x = row_idx*row_unit + row_unit/2;
        float y = col_idx*col_unit + col_unit/2;
        
//        printf("%f %f",x,y);
        CCSprite *a_mouse =[CCSprite spriteWithFile: @"cut_mouse.png"];
        a_mouse.position = ccp(x,y);
        [self addChild:a_mouse];
    }
    //[self scheduleUpdate];
}

@end

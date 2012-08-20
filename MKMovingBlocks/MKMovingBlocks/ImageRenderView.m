//
//  ImageRenderView.m
//  MKMovingBlocks
//
//  Created by indideveloper on 8/21/12.
//  Copyright (c) 2012 IndiDeveloper. All rights reserved.
//

#import "ImageRenderView.h"

#define rows 8
@interface ImageRenderView()
@property (nonatomic,retain) NSMutableArray* slideImages;

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
@end


@implementation ImageRenderView

@synthesize slideImages = _slideImages;

- (void)dealloc {
	
	[self.slideImages removeAllObjects];
	self.slideImages = nil;
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.slideImages = [[[NSMutableArray alloc] init] autorelease];
		
		for (int i = 1; i < 10; i++) {
            [self.slideImages addObject:[self imageWithBorderFromImage:[[CacheManager sharedInstance] imageNamed:[NSString stringWithFormat:@"image%d.png", i]]]];
        }
        
		for (int i = 0; i < rows; i++) {
			UIImage* img = [self.slideImages objectAtIndex:arc4random() % [self.slideImages count]];
			int size = frame.size.width;
			
			UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
			imageView.frame = CGRectMake(0, 0, size - 6, size - 6);
			
            
			imageView.center = CGPointMake(self.frame.size.width/2, i * self.frame.size.height/8);
			
			[self addSubview:imageView];
			[imageView release];
		}
        
    }
    return self;
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
	CGSize size = [source size];
	UIGraphicsBeginImageContext(size);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetBlendMode(context, kCGBlendModeClear);
	CGContextSetRGBStrokeColor(context, 1.0, 0.5, 1.0, 1.0);
	CGContextStrokeRectWithWidth(context, rect,4);
	UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return testImg;
}

- (void)setPositionX:(float)posX {
	CGRect old_frame = self.frame;
	
	
    float x = old_frame.origin.x - posX;
	if ((old_frame.origin.x + self.frame.size.width*2) < (self.frame.size.width)) {
		self.frame = CGRectMake(old_frame.size.width * 7, old_frame.origin.y, old_frame.size.width, old_frame.size.height);
	} else {
		self.frame = CGRectMake(x, old_frame.origin.y, old_frame.size.width, old_frame.size.height);
	}
	
	
}
@end

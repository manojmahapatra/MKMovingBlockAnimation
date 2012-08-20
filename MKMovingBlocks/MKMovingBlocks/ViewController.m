//
//  ViewController.m
//  MKMovingBlocks
//
//  Created by indideveloper on 8/21/12.
//  Copyright (c) 2012 IndiDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "ImageRenderView.h"

#define COLOR_BG [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0]
#define MATRIX_OFFSET 400
#define RADIANS( degrees ) ( degrees * M_PI / 180.0f )
#define PERSPECTIVE_ANGLE 15.0f


#define WIDTH_OF_SCROLL_PAGE 320
#define HEIGHT_OF_SCROLL_PAGE 352
#define WIDTH_OF_IMAGE 320
#define HEIGHT_OF_IMAGE 352
#define LEFT_EDGE_OFSET 6

#define SIZE 128.0

@interface ViewController ()
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) NSMutableArray* slideImages;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, assign) CAGradientLayer *gradient;

- (void)makePerspective;

@end

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize slideImages = _slideImages;
@synthesize gradient = _gradient;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = COLOR_BG;
	self.view.clipsToBounds = YES;
        
    CGRect scrollFrame;
    scrollFrame.origin.x = 0;
    scrollFrame.origin.y = 0;
    scrollFrame.size.width = self.view.frame.size.width + 500;
    scrollFrame.size.height = self.view.frame.size.height + 500;
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:scrollFrame] autorelease];
    
    self.scrollView.backgroundColor = COLOR_BG;
    
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    self.scrollView.userInteractionEnabled = NO;
    
    self.slideImages = [[[NSMutableArray alloc] init] autorelease];
    
    int rows = 8;
    
    
    int total_count = 8;
    
    for (int i = 0; i < total_count;i++) {
        ImageRenderView *imageView = [[ImageRenderView alloc] initWithFrame:CGRectMake(i * (SIZE+LEFT_EDGE_OFSET), 0, SIZE + LEFT_EDGE_OFSET, SIZE * rows)];
        
        [self.scrollView addSubview:imageView];
        [self.slideImages addObject:imageView];
        [imageView release];
    }
    
    
    [self.scrollView setContentSize:CGSizeMake(WIDTH_OF_SCROLL_PAGE, self.scrollView.frame.size.height)];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.scrollView.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], nil];
    self.gradient.startPoint = CGPointMake(0.1, 0.5);
    self.gradient.endPoint = CGPointMake(0.9, 0.5);
    
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView scrollRectToVisible:CGRectMake(WIDTH_OF_IMAGE*2,0,WIDTH_OF_IMAGE,self.scrollView.frame.size.height) animated:NO];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(scrollView1:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.scrollView.layer addSublayer:self.gradient];
    [self makePerspective];
    self.scrollView.alpha = 0.0;
    
    ////
    
    CC_DIRECTOR_END();
    
    
    // Create an CCGLView with a RGB8 color buffer, and a depth buffer f 0-bits
    CCGLView *glView = [CCGLView viewWithFrame:[[UIScreen mainScreen] bounds]
                                   pixelFormat:kEAGLColorFormatRGBA8
                                   depthFormat:GL_DEPTH_COMPONENT24_OES
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    
    director_ = (CCDirectorIOS*)[CCDirector sharedDirector];
    
    director_.wantsFullScreenLayout = YES;
    // Display Milliseconds Per Frame
    [director_ setDisplayStats:YES];
    
    // set FPS at 60
    [director_ setAnimationInterval:1.0/60];
    
    // attach the openglView to the director
    [director_ setView:glView];
    
    // 3D projection
    [director_ setProjection:kCCDirectorProjection3D];
    
    // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    if( ! [director_ enableRetinaDisplay:YES] )
        CCLOG(@"Retina Display Not supported");
    
    UINavigationController *navController_ = [[[UINavigationController alloc] initWithRootViewController:director_] autorelease];
    navController_.navigationBarHidden = YES;
    
    [director_ setDelegate:nil];
    

    [self.view addSubview:navController_.view];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
    [sharedFileUtils setEnableFallbackSuffixes:YES];
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];
    [sharedFileUtils setiPadSuffix:@"-ipad"];
    [sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];
    
    movingBlockVC = [[MovingBlockContainer alloc] initWithNibName:nil bundle:nil];
	[movingBlockVC view];
	
	CGRect old = movingBlockVC.view.frame;
	
	
	
	[self.view addSubview:movingBlockVC.view];
    movingBlockVC.view.frame = CGRectMake(-old.size.width, -old.size.height, old.size.width, old.size.height);
    movingBlockVC.view.hidden = YES;
	
    [self.view sendSubviewToBack:movingBlockVC.view];
    
    director_.view.hidden = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [UIView	animateWithDuration:0.7
					 animations:^(void) {
						 self.scrollView.alpha = 1.0;
					 } completion:^(BOOL finished) {}];
}


- (void)makePerspective {
	self.scrollView.layer.opaque = NO;
	self.scrollView.layer.needsDisplayOnBoundsChange = YES;
	self.scrollView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
	CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
	rotationAndPerspectiveTransform.m34 = 1.0 / -(MATRIX_OFFSET);
	
	float angle = -(PERSPECTIVE_ANGLE);
	
	rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, RADIANS(angle), 0.0f, 1.0f, 0.0f);
	self.scrollView.layer.transform =  rotationAndPerspectiveTransform;
	
	
    rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, -200, -270, -300);
	self.scrollView.layer.transform =  rotationAndPerspectiveTransform;
	
	self.scrollView.layer.magnificationFilter = kCAFilterTrilinear;
	self.scrollView.layer.minificationFilter = kCAFilterTrilinear;
    
	[self.scrollView.layer setPosition:CGPointMake(200, 360)];
	
	
	CATransform3D zOrdertransfrom = CATransform3DIdentity;
	zOrdertransfrom = CATransform3DTranslate(zOrdertransfrom, 0, 0, 10000);
}

- (void) scrollView1:(float)ti {
    
	for (ImageRenderView* v in self.slideImages) {
		[v setPositionX:0.4];
	}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

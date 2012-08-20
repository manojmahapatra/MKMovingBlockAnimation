//
//  ViewController.h
//  MKMovingBlocks
//
//  Created by indideveloper on 8/21/12.
//  Copyright (c) 2012 IndiDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovingBlockContainer.h"

@interface ViewController : UIViewController<UIScrollViewDelegate>
{
    CCDirectorIOS* director_;
    MovingBlockContainer *movingBlockVC;
}
@end

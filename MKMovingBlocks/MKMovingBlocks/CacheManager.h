//
//  CacheManager.h
//  MKMovingBlocks
//
//  Created by indideveloper on 8/21/12.
//  Copyright (c) 2012 IndiDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
+ (id)sharedInstance;
- (UIImage *)imageNamed:(NSString *)imageName;
- (void)releaseImageNamed:(NSString *)imageName;
@end

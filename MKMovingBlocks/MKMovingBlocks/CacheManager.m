//
//  CacheManager.m
//  MKMovingBlocks
//
//  Created by indideveloper on 8/21/12.
//  Copyright (c) 2012 IndiDeveloper. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager()
@property (nonatomic, readonly) NSMutableDictionary *imageCache;
@end


@implementation CacheManager

@synthesize imageCache = _imageCache;

- (void)dealloc {
    [_imageCache release];
    
    [super dealloc];
}

+ (id)sharedInstance {
    static id sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[self class] new];
    }
    
    return sharedInstance;
}

- (id)retain {
    return self;
}

- (id)autorelease {
    return self;
}

- (oneway void)release {
    //do nothing
}

- (unsigned)retainCount {
    return NSNotFound;
}

- (NSMutableDictionary *)imageCache {
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary new];
    }
    
    return _imageCache;
}

- (UIImage *)imageNamed:(NSString *)imageName {
    UIImage *result = [self.imageCache objectForKey:imageName];
    if (!result) {
        result = [UIImage imageNamed:imageName];
        if (result) {
            [self.imageCache setObject:result forKey:imageName];
        }
    }
    
    return result;
}

- (void)releaseImageNamed:(NSString *)imageName {
    [self.imageCache removeObjectForKey:imageName];
}

@end

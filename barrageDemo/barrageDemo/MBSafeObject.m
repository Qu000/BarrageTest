//
//  MBSafeObject.m
//  MBLive_iOS
//
//  Created by qujiahong on 2018/3/9.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "MBSafeObject.h"
@interface MBSafeObject()
{
    __weak id _object;
    SEL _sel;
}
@end

@implementation MBSafeObject

- (instancetype)initWithObject:(id)object
{
    if (self = [super init]) {
        _object = object;
        _sel = nil;
    }
    return self;
}

- (instancetype)initWithObject:(id)object withSelector:(SEL)selector
{
    if(self = [super init])
    {
        _object = object;
        _sel = selector;
    }
    return self;
}

- (void)excute
{
    if (_object && _sel && [_object respondsToSelector:_sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_object performSelector:_sel withObject:nil];
#pragma clang diagnostic pop
    }
}
@end

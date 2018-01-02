//
//  XYDataBlock.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataBlock.h"

@interface XYDataBlock ()

@property (nonatomic, copy, readwrite) id etag;

@property (nonatomic, assign, readwrite) XYDataBlockStatus status;

@end

@implementation XYDataBlock

- (instancetype)init
{
    if (self = [super init]) {
        self.etag = @(0);
        self.status = XYDataBlockStatusNone;
    }
    
    return self;
}

- (void)markNormal
{
    [self switchBlockStatusTo:XYDataBlockStatusNone];
}

- (void)markDeleted
{
    [self switchBlockStatusTo:XYDataBlockStatusDeleted];
}

- (void)markModified
{
    [self switchBlockStatusTo:XYDataBlockStatusModified];
}

#pragma mark - protocol methods

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status
{
    return @{};
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
    return @{};
}

#pragma mark - private

- (void)switchBlockStatusTo:(XYDataBlockStatus)status
{
    self.status = status;
}

@end

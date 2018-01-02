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

#pragma mark - private

- (void)switchBlockStatusTo:(XYDataBlockStatus)status
{
    self.status = status;
}

@end

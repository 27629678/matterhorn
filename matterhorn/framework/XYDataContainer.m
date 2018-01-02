//
//  XYDataContainer.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataContainer.h"

@implementation XYDataContainer

#pragma mark - protocol methods

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status
{
    return @{};
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
    return @{};
}

#pragma mark - json serialization methods

- (NSDictionary *)jsonDictionary
{
    return @{};
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)json
{
    return nil;
}

@end

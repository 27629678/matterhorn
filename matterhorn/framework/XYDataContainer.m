//
//  XYDataContainer.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataContainer.h"

#import "XYDataRuntimeUtils.h"

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

- (NSDictionary *)allETags {
    return @{};
}


#pragma mark - json serialization methods

- (NSDictionary *)jsonDictionary
{
    NSDictionary *json = nil;
    NSError *error = [XYDataRuntimeUtils populateValues:&json fromContainer:self];
    if (error) {
        NSCAssert(NO, error.description);
        
        return nil;
    }
    
    return json;
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)json
{
    if (self = [super init]) {
        [XYDataRuntimeUtils retrieveContainer:self fromJson:json];
    }
    
    return self;
}

@end

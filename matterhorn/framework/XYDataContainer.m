//
//  XYDataContainer.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataContainer.h"

#import "XYClassProperty.h"
#import "XYDataRuntimeUtils.h"

@implementation XYDataContainer

#pragma mark - protocol methods

- (NSDictionary *)allETags
{
    return [self etagsForStatus:XYDataBlockStatusAll];
}

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status
{
    NSMutableDictionary *etags = [NSMutableDictionary dictionary];
    NSDictionary *p2p = propertiesOf(self, [XYMergeableContainer class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        id value = [self valueForKey:property_name];
        
        // ignore custom data type
        if ([value conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            return;
        }
        
        // XYDataProtocol object
        if ([value conformsToProtocol:@protocol(XYDataProtocol)])
        {
            [etags setValue:[value etagsForStatus:status] forKey:property_name];
            
            return;
        }
        
        NSCAssert(NO, @"invalid data type.");
    }];
    
    return etags;
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
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

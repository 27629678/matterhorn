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
#import "XYDataObjectExtension.h"

@interface XYDataObject ()

- (NSDictionary *)serverKey2LocalKey;

- (NSDictionary *)localKey2ServerKey;

@end    // XYDataObject Extension

@implementation XYDataContainer

#pragma mark - protocol methods

- (void)merge:(NSDictionary *)json
{
    NSDictionary *p2p = propertiesOf(self, [XYMergeableContainer class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        NSString *server_key = [self.localKey2ServerKey objectForKey:property_name];
        id obj = [json objectForKey:(server_key.length > 0 ? server_key : property_name)];
        if (!obj) {
            return;
        }
        
        id value = [self valueForKey:property_name];
        if (!value) {
            value = [property.cls new];
        }
        
        if ([value conformsToProtocol:@protocol(XYDataProtocol)]) {
            [value merge:obj];
            
            return;
        }
        
        // ignore custom data type obj
        if ([value conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            return;
        }
        
        NSCAssert(NO, @"unhandled key:", (server_key.length > 0 ? server_key : property_name), @"value", obj);
    }];
}

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
        
        // if no value of the property_name, initiate a new one if it confirms to XYDataProtocol protocol
        if (!value) {
            id instance = [property.cls new];
            if (![instance conformsToProtocol:@protocol(XYDataProtocol)]) {
                return;
            }
            
            value = instance;
        }
        
        // ignore custom data type
        if ([value conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            return;
        }
        
        // XYDataProtocol object
        if ([value conformsToProtocol:@protocol(XYDataProtocol)])
        {
            id obj = [value etagsForStatus:status];
            NSString *server_key = [self.localKey2ServerKey objectForKey:property_name];
            [etags setValue:obj forKey:(server_key.length > 0 ? server_key : property_name)];
            
            return;
        }
        
        NSCAssert(NO, @"invalid data type.");
    }];
    
    return etags;
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    NSDictionary *p2p = propertiesOf(self, [XYMergeableContainer class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        id value = [self valueForKey:property_name];
        if (!value) {
            if ([self.requiredProperties containsObject:property_name]) {
                NSCAssert(NO, @"required value for key:", property_name);
            }
            
            return;
        }
        
        // ignore custom data type
        if ([value conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            return;
        }
        
        // XYDataProtocol object
        if ([value conformsToProtocol:@protocol(XYDataProtocol)])
        {
            id obj = [value valuesForStatus:status];
            NSString *server_key = [self.localKey2ServerKey objectForKey:property_name];
            [values setValue:obj forKey:(server_key.length > 0 ? server_key : property_name)];
            
            return;
        }
        
        NSCAssert(NO, @"invalid data type.");
    }];
    
    return values;
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

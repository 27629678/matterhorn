//
//  XYDataBlock.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataBlock.h"

#import "XYClassProperty.h"
#import "XYDataRuntimeUtils.h"
#import "XYDataObjectExtension.h"

@interface XYDataObject ()

- (NSDictionary *)serverKey2LocalKey;

- (NSDictionary *)localKey2ServerKey;

@end    // XYDataObject Extension

@interface XYDataBlock ()

@property (nonatomic, copy) NSNumber *timestamp;
@property (nonatomic, copy, readwrite) NSNumber *status;
@property (nonatomic, copy, readwrite) id<NSCopying> etag;

@end

@implementation XYDataBlock

- (instancetype)init
{
    if (self = [super init]) {
        self.status = @(XYDataBlockStatusNone);
    }
    
    return self;
}

- (void)markNormal
{
    [self switchBlockStatusTo:XYDataBlockStatusNone];
    self.timestamp = @([NSDate date].timeIntervalSince1970);
}

- (void)markDeleted
{
    [self switchBlockStatusTo:XYDataBlockStatusDeleted];
    self.timestamp = @([NSDate date].timeIntervalSince1970);
}

- (void)markModified
{
    [self switchBlockStatusTo:XYDataBlockStatusModified];
    self.timestamp = @([NSDate date].timeIntervalSince1970);
}

- (NSArray *)ignoredProperties
{
    return @[ @"etag", @"timestamp", @"status"];
}

#pragma mark - protocol methods

- (void)merge:(NSDictionary *)json
{
    NSDictionary *p2p = propertiesOf(self, [XYMergeableObject class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        NSString *server_key = [self.localKey2ServerKey objectForKey:property_name];
        id obj = [json objectForKey:(server_key.length > 0 ? server_key : property_name)];
        if (!obj) {
            return;
        }
        
        if ([obj isKindOfClass:property.cls] &&
            ([XYDataRuntimeUtils.primitiveClasses containsObject:property.cls] ||
             [XYDataRuntimeUtils.primitiveContainerClasses containsObject:property.cls]))
        {
            [self setValue:obj forKey:property_name];
            
            return;
        }
        
        NSCAssert(NO, @"unhandled key:", (server_key.length > 0 ? server_key : property_name), @"value", obj);
    }];
    
    [self markNormal];
}

- (NSDictionary *)allETags
{
    return [self etagsForStatus:XYDataBlockStatusAll];
}

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status
{
    if (status != XYDataBlockStatusAll && status != self.status.unsignedIntegerValue) {
        return nil;
    }
    
    return @{ kXYDataKey_ETag: self.etag };
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
    if (status != XYDataBlockStatusAll && status != self.status.unsignedIntegerValue) {
        return nil;
    }
    
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    NSDictionary *p2p = propertiesOf(self, [XYMergeableObject class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        if ([self.ignoredProperties containsObject:property_name]) {
            return;
        }
        
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
        
        // ignore XYDataProtocol object
        if ([value conformsToProtocol:@protocol(XYDataProtocol)]) {
            NSCAssert(NO, @"MUST NOT BE XYDataProtocol object!");
            
            return;
        }
        
        if ([[XYDataRuntimeUtils primitiveClasses] containsObject:property.cls] ||
            [[XYDataRuntimeUtils primitiveContainerClasses] containsObject:property.cls])
        {
            NSString *server_key = [self.localKey2ServerKey objectForKey:property_name];
            [values setValue:value forKey:(server_key.length > 0 ? server_key : property_name)];
            
            return;
        }
        
        NSCAssert(NO, @"invalid data type.");
    }];
    
    return values.copy;
}

#pragma mark - json serialization methods

- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setValue:self.etag forKey:kXYDataKey_ETag];
    [json setValue:self.status forKey:kXYDataKey_Status];
    [json setValue:self.timestamp forKey:kXYDataKey_Date];
    
    // values
    NSMutableDictionary *values = nil;
    NSError *error = [XYDataRuntimeUtils populateValues:&values fromBlock:self];
    if (error) {
        NSCAssert(NO, error.description);
        
        return json.copy;
    }
    
    [json setValue:values forKey:kXYDataKey_Value];
    
    return json.copy;
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)json
{
    if (self = [super init]) {
        self.etag = [json objectForKey:kXYDataKey_ETag];
        self.status = [json objectForKey:kXYDataKey_Status];
        self.timestamp = [json objectForKey:kXYDataKey_Date];
        
        [XYDataRuntimeUtils retrieveBlock:self fromJson:[json objectForKey:kXYDataKey_Value]];
    }
    
    return self;
}

#pragma mark - private

- (void)switchBlockStatusTo:(XYDataBlockStatus)status
{
    self.status = @(status);
}

#pragma mark - getter & setter

- (id<NSCopying>)etag
{
    if (!_etag) {
        _etag = @"no-etag";
    }
    
    return _etag;
}

@end

//
//  XYDataRuntimeUtils.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataRuntimeUtils.h"

#import "XYDataProtocol.h"
#import "XYClassProperty.h"
#import "XYDataObject.h"
#import "XYMergeableObject.h"
#import "XYMergeableContainer.h"
#import "XYDataObjectExtension.h"

@implementation XYDataRuntimeUtils

+ (void)retrieveBlock:(XYMergeableObject *)block fromJson:(NSDictionary *)json
{
    NSDictionary *p2p = propertiesOf(block, [XYMergeableObject class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        if (property_name.length == 0) {
            NSCAssert(NO, @"");
            return;
        }
        
        if ([block.ignoredProperties containsObject:property_name]) {
            return;
        }
        
        id value = [json objectForKey:property_name];
        
        // primitive type
        if ([[XYDataRuntimeUtils primitiveClasses] containsObject:property.cls]) {
            [block setValue:value forKey:property_name];
            
            return;
        }
        
        // primitive container type
        if ([[XYDataRuntimeUtils primitiveContainerClasses] containsObject:property.cls]) {
            [block setValue:value forKey:property_name];
            
            return;
        }
        
        // custom object type
        if ([property.cls conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            id instance = [[property.cls alloc] initWithCustomJsonDictionary:value];
            [block setValue:instance forKey:property_name];
            
            return;
        }
        
        NSCAssert(NO, @"invalid data type");
    }];
}

+ (void)retrieveContainer:(XYMergeableContainer *)container fromJson:(NSDictionary *)json
{
    NSDictionary *p2p = propertiesOf(container, [XYMergeableContainer class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        if (property_name.length == 0) {
            NSCAssert(NO, @"");
            return;
        }
        
        if ([container.ignoredProperties containsObject:property_name]) {
            return;
        }
        
        id instance = [property.cls alloc];
        id json_obj = [json objectForKey:property_name];
        
        // block & container
        if ([instance isKindOfClass:[XYMergeableObject class]] ||
            [instance isKindOfClass:[XYMergeableContainer class]])
        {
            instance = [instance initWithJsonDictionary:json_obj];
            [container setValue:instance forKey:property_name];
            
            return;
        }
        
        NSCAssert(NO, @"invalid data type");
    }];
}

+ (NSError *)populateValues:(NSDictionary *__autoreleasing *)dict fromBlock:(XYMergeableObject *)block
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSDictionary *p2p = propertiesOf(block, [XYMergeableObject class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        if (property_name.length == 0) {
            NSCAssert(NO, @"");
            return;
        }
        
        if ([block.ignoredProperties containsObject:property_name]) {
            return;
        }
        
        id json_obj = nil;
        id value = [block valueForKey:property_name];
        if ([property.cls conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            json_obj = [value jsonDictionaryForCustom];
        }
        else if ([[XYDataRuntimeUtils primitiveClasses] containsObject:property.cls]) {
            json_obj = value;
        }
        else if ([[XYDataRuntimeUtils primitiveContainerClasses] containsObject:property.cls]) {
            // TODO: handle list and map type object
        }
        
        [json setValue:json_obj forKey:property_name];
    }];
    
    *dict = json.copy;
    
    return nil;
}

+ (NSError *)populateValues:(NSDictionary *__autoreleasing *)dict fromContainer:(XYMergeableContainer *)container
{
    __block NSError *error = nil;
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    NSDictionary *p2p = propertiesOf(container, [XYMergeableContainer class]);
    [p2p enumerateKeysAndObjectsUsingBlock:^(NSString *property_name, XYClassProperty *property, BOOL *stop) {
        id json_obj = nil;
        id value = [container valueForKey:property_name];
        
        // container
        if ([value isKindOfClass:[XYMergeableContainer class]]) {
            XYMergeableContainer *c = [container valueForKey:property_name];
            if (!c) {
                return;
            }
            
            error = [XYDataRuntimeUtils populateValues:&json_obj fromContainer:c];
            if (error) {
                *stop = YES;
            }
            
            [json setObject:json_obj forKey:property_name];
            
            return;
        }
        
        // block
        if ([value isKindOfClass:[XYMergeableObject class]]) {
            json_obj = [value jsonDictionary];
        }
        // custom object
        else if ([property.cls conformsToProtocol:@protocol(XYCustomDataJsonSerializationProtocol)]) {
            json_obj = [value jsonDictionaryForCustom];
        }
        // primitive object
        else {
            json_obj = value;
        }
        
        [json setValue:json_obj forKey:property_name];
    }];
    
    *dict = json.copy;

    return error;
}

#pragma mark - private

+ (NSArray<Class> *)primitiveClasses
{
    static NSArray *classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = @[ [NSNull class],
                     [NSString class],
                     [NSNumber class],
                     [NSMutableString class]
                     ];
    });
    
    return classes;
}

+ (NSArray<Class> *)primitiveContainerClasses
{
    static NSArray *classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = @[ [NSArray class],
                     [NSMutableArray class],
                     [NSDictionary class],
                     [NSMutableDictionary class]
                     ];
    });
    
    return classes;
}

@end

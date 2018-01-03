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
    
}

+ (void)retrieveContainer:(XYMergeableContainer *)container fromJson:(NSDictionary *)json
{
    
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
        else if (![[XYDataRuntimeUtils primitiveClass] containsObject:property.cls]) {
            NSCAssert(NO, @"invalid data type!!!");
            return;
        }
        else {
            json_obj = value;
        }
        
        [json setValue:json_obj forKey:property_name];
    }];
    
    *dict = json;
    
    return nil;
}

+ (NSError *)populateValues:(NSDictionary *__autoreleasing *)dict fromContainer:(XYMergeableContainer *)container
{
    
//    if ([property.cls isKindOfClass:[XYMergeableContainer class]]) {
//        XYMergeableContainer *container = [block valueForKey:property_name];
//        if (!container) {
//            return;
//        }
//
//        NSMutableDictionary *container_dict = [NSMutableDictionary dictionary];
//        error = [XYDataRuntimeUtils populateValues:&container_dict fromContainer:container];
//        if (error) {
//            *stop = YES;
//        }
//
//        [json setObject:container_dict forKey:property_name];
//    }
    return nil;
}

#pragma mark - private

+ (NSArray<Class> *)primitiveClass
{
    static NSArray *classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = @[ [NSNull class],
                     [NSString class],
                     [NSNumber class],
                     [NSMutableString class],
                     [NSArray class],
                     [NSMutableArray class],
                     [NSDictionary class],
                     [NSMutableDictionary class]
                     ];
    });
    
    return classes;
}

@end

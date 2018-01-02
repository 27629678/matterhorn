//
//  XYDataRuntimeUtils.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYMergeableObject, XYMergeableContainer;

@interface XYDataRuntimeUtils : NSObject

+ (void)retrieveBlock:(XYMergeableObject *)block fromJson:(NSDictionary *)json;

+ (void)retrieveContainer:(XYMergeableContainer *)container fromJson:(NSDictionary *)json;

+ (NSError *)populateValues:(NSDictionary **)dict fromBlock:(XYMergeableObject *)block;

+ (NSError *)populateValues:(NSDictionary **)dict fromContainer:(XYMergeableContainer *)container;

@end

//
//  XYDataObjectExtension.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataObject.h"

@interface XYDataObject ()

- (NSArray *)ignoredProperties;

- (NSArray *)requiredProperties;

- (NSDictionary<NSString *, NSString *> *)transformDictionary;  // NSDictionary<ServerKey, LocalKey>

@end

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

- (NSDictionary *)serverKey2LocalKey;

- (NSDictionary *)localKey2ServerKey;

- (void)transformServerKey:(NSString *)s toLocalProperty:(NSString *)l;

@end

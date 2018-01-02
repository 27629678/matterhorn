//
//  XYDataProtocol.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYDataConstant.h"

@protocol XYDataProtocol <NSObject>

- (NSDictionary *)allETags;

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status;

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status;

@end    // XYDataProtocol

@protocol XYDataJsonSerializationProtocol <NSObject>

- (NSDictionary *)jsonDictionary;

- (instancetype)initWithJsonDictionary:(NSDictionary *)json;

@end    // XYDataSerializationProtocol

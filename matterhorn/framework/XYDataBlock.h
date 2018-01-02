//
//  XYDataBlock.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYMergeableObject.h"

#import "XYDataProtocol.h"

@interface XYDataBlock : XYMergeableObject <XYDataProtocol, XYDataJsonSerializationProtocol>

@property (nonatomic, copy, readonly) NSNumber *status;

@property (nonatomic, copy, readonly) id<NSCopying> etag;

- (void)markModified;

- (void)markDeleted;

@end

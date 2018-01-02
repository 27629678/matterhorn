//
//  XYDataBlock.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYMergeableObject.h"

#import "XYDataConstant.h"

@interface XYDataBlock : XYMergeableObject

@property (nonatomic, copy, readonly) id etag;

@property (nonatomic, assign, readonly) XYDataBlockStatus status;

- (void)markModified;

- (void)markDeleted;

@end

//
//  XYDataBlock.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYDataConstant.h"
#import "XYMergeableObject.h"

@interface XYDataBlock : XYMergeableObject

@property (nonatomic, copy, readonly) id etag;

@property (nonatomic, assign, readonly) XYDataBlockStatus status;

- (void)markModified;

- (void)markDeleted;

@end

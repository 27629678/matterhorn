//
//  XYDataConstant.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XY_MATTER_HORN_DEBUG 0

typedef NS_ENUM(NSUInteger, XYDataBlockStatus) {
    XYDataBlockStatusNone,                  // marked normal
    XYDataBlockStatusModified,              // marked modified
    XYDataBlockStatusDeleted,               // marked deleted
};

extern NSString* const kXYDataKey_ETag;
extern NSString* const kXYDataKey_Date;
extern NSString* const kXYDataKey_Value;

@interface XYDataConstant : NSObject

@end

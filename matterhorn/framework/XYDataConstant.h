//
//  XYDataConstant.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XYDataBlockStatus) {
    XYDataBlockStatusNone,                  // marked normal
    XYDataBlockStatusModified,              // marked modified
    XYDataBlockStatusDeleted,               // marked deleted
};

@interface XYDataConstant : NSObject

@end

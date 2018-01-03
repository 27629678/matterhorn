//
//  XYDataContainer.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYMergeableContainer.h"

#import "XYDataBlock.h"
#import "XYDataProtocol.h"

@interface XYDataContainer : XYMergeableContainer <XYDataProtocol, XYDataJsonSerializationProtocol>

@end

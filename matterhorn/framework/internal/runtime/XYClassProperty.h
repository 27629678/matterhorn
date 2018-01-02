//
//  XYClassProperty.h
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYClassProperty : NSObject

@property (nonatomic, assign) Class cls;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *protocol;

@property (nonatomic, assign) BOOL isMutable;

@property (nonatomic, assign, getter=isReadonly) BOOL readonly;

@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

extern NSDictionary<NSString *, XYClassProperty *>* propertiesOf(id target, Class final_cls);

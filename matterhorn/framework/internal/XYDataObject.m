//
//  XYDataObject.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataObject.h"

#import "XYDataObjectExtension.h"

@interface XYDataObject ()

@property (nonatomic, strong) NSMutableDictionary *s2l;
@property (nonatomic, strong) NSMutableDictionary *l2s;

@end

@implementation XYDataObject

#pragma mark - getter & setter

- (NSMutableDictionary *)s2l
{
    if (!_s2l) {
        _s2l = [NSMutableDictionary dictionary];
    }
    
    return _s2l;
}

- (NSMutableDictionary *)l2s
{
    if (!_l2s) {
        _l2s = [NSMutableDictionary dictionary];
    }
    
    return _l2s;
}

#pragma mark - extension

- (NSArray *)ignoredProperties
{
    return @[];
}

- (NSArray *)requiredProperties
{
    return @[];
}

- (NSDictionary *)serverKey2LocalKey
{
    return self.s2l.copy;
}

- (NSDictionary *)localKey2ServerKey
{
    return self.l2s.copy;
}

- (void)transformServerKey:(NSString *)s toLocalProperty:(NSString *)l
{
    if (s.length * l.length == 0) {
        return;
    }
    
    [self.s2l setObject:s forKey:l];
    [self.l2s setObject:l forKey:s];
}

@end

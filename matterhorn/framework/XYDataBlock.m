//
//  XYDataBlock.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataBlock.h"

#import "XYDataRuntimeUtils.h"

@interface XYDataBlock ()

@property (nonatomic, assign) long timestamp;
@property (nonatomic, copy, readwrite) id<NSCopying> etag;
@property (nonatomic, assign, readwrite) XYDataBlockStatus status;

@end

@implementation XYDataBlock

- (instancetype)init
{
    if (self = [super init]) {
        self.status = XYDataBlockStatusNone;
    }
    
    return self;
}

- (void)markNormal
{
    [self switchBlockStatusTo:XYDataBlockStatusNone];
}

- (void)markDeleted
{
    [self switchBlockStatusTo:XYDataBlockStatusDeleted];
}

- (void)markModified
{
    [self switchBlockStatusTo:XYDataBlockStatusModified];
}

#pragma mark - protocol methods

- (NSDictionary *)allETags
{
    return @{ kXYDataKey_ETag: self.etag };
}

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status
{
    if (status != self.status) {
        return nil;
    }
    
    return @{ kXYDataKey_ETag: self.etag };
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
    if (status != self.status) {
        return nil;
    }
    
    NSMutableDictionary *values = nil;
    NSError *error = [XYDataRuntimeUtils populateValues:&values fromBlock:self];
    if (error) {
        NSCAssert(NO, error.description);
        
        return nil;
    }
    
    return values.copy;
}

#pragma mark - json serialization methods

- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:self.etag forKey:kXYDataKey_ETag];
    [json setObject:@(self.status) forKey:kXYDataKey_Status];
    [json setObject:@(self.timestamp) forKey:kXYDataKey_Date];
    
    // values
    NSMutableDictionary *values = nil;
    NSError *error = [XYDataRuntimeUtils populateValues:&values fromBlock:self];
    if (error) {
        NSCAssert(NO, error.description);
        
        return json.copy;
    }
    
    [json setValue:values forKey:kXYDataKey_Value];
    
    return json.copy;
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)json
{
    if (self = [super init]) {
        [XYDataRuntimeUtils retrieveBlock:self fromJson:json];
    }
    
    return self;
}

#pragma mark - private

- (void)switchBlockStatusTo:(XYDataBlockStatus)status
{
    self.status = status;
}

#pragma mark - getter & setter

- (id<NSCopying>)etag
{
    if (!_etag) {
        _etag = @"no-etag";
    }
    
    return _etag;
}

@end

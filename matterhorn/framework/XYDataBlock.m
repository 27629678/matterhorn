//
//  XYDataBlock.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYDataBlock.h"

#import "XYDataRuntimeUtils.h"
#import "XYDataObjectExtension.h"

@interface XYDataBlock ()

@property (nonatomic, copy) NSNumber *timestamp;
@property (nonatomic, copy, readwrite) NSNumber *status;
@property (nonatomic, copy, readwrite) id<NSCopying> etag;

@end

@implementation XYDataBlock

- (instancetype)init
{
    if (self = [super init]) {
        self.status = @(XYDataBlockStatusNone);
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

- (NSArray *)ignoredProperties
{
    return @[ @"etag", @"timestamp", @"status"];
}

#pragma mark - protocol methods

- (NSDictionary *)allETags
{
    return [self etagsForStatus:XYDataBlockStatusAll];
}

- (NSDictionary *)etagsForStatus:(XYDataBlockStatus)status
{
    if (status != XYDataBlockStatusAll && status != self.status.unsignedIntegerValue) {
        return nil;
    }
    
    return @{ kXYDataKey_ETag: self.etag };
}

- (NSDictionary *)valuesForStatus:(XYDataBlockStatus)status
{
    if (status != XYDataBlockStatusAll && status != self.status.unsignedIntegerValue) {
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
    [json setValue:self.etag forKey:kXYDataKey_ETag];
    [json setValue:self.status forKey:kXYDataKey_Status];
    [json setValue:self.timestamp forKey:kXYDataKey_Date];
    
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
        self.etag = [json objectForKey:kXYDataKey_ETag];
        self.status = [json objectForKey:kXYDataKey_Status];
        self.timestamp = [json objectForKey:kXYDataKey_Date];
        
        [XYDataRuntimeUtils retrieveBlock:self fromJson:[json objectForKey:kXYDataKey_Value]];
    }
    
    return self;
}

#pragma mark - private

- (void)switchBlockStatusTo:(XYDataBlockStatus)status
{
    self.status = @(status);
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

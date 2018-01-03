//
//  main.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYMatterhorn.h"

#import "XYClassProperty.h"
#import "XYMergeableObject.h"

@interface Setting1 : XYDataBlock

@property NSString *version;

@end

@implementation Setting1

@end

@interface Setting2 : XYDataBlock

@property NSString *greeting;

@end

@implementation Setting2

@end

@interface Setting3 : XYDataBlock

@property NSNumber *latitude;

@property NSNumber *longtitude;

@end

@implementation Setting3

@end

@interface Container1 : XYDataContainer

@property Setting1 *s1;

@property Setting2 *s2;

@end

@implementation Container1

@end

@interface Container2 : XYDataContainer

@property Container1 *c1;

@property Setting3 *s3;

@end

@implementation Container2

@end

XYDataBlock *data_block_constructor(void);

XYDataContainer *data_container_constructor(void);

int test_data_block(void);

int test_run_time_utils(void);

int test_data_block_deserialization(void);

int test_data_container_deserialization(void);

NSDictionary *test_data_block_serialization(void);

NSDictionary *test_data_container_serialization(void);

int test_data_etags(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"-- BEGIN ...");
        
        assert(test_data_block() == 0);
        
        assert(test_run_time_utils() == 0);
        
        assert(test_data_block_serialization().count > 0);
        
        assert(test_data_container_serialization().count > 0);
        
        assert(test_data_block_deserialization() == 0);
        
        assert(test_data_container_deserialization() == 0);
        
        assert(test_data_etags() == 0);
        
        NSLog(@"-- END.");
    }
    
    return 0;
}

XYDataBlock *data_block_constructor() {
    Setting1 *s1 = [Setting1 new];
    s1.version = @"1.0.0";
    
    return s1;
}

XYDataContainer *data_container_constructor() {
    Setting1 *s1 = [Setting1 new];
    s1.version = @"1.0.0";
    
    Setting2 *s2 = [Setting2 new];
    s2.greeting = @"hello, world.";
    
    Container1 *c1 = [Container1 new];
    c1.s1 = s1;
    c1.s2 = s2;
    
    Setting3 *s3 = [Setting3 new];
    s3.latitude = @(1.0);
    s3.longtitude = @(20.3);
    
    Container2 *c2 = [Container2 new];
    c2.c1 = c1;
    c2.s3 = s3;
    
    return c2;
}

int test_data_block() {
    XYDataBlock *block = [XYDataBlock new];
    
    assert(block.status.unsignedIntegerValue == XYDataBlockStatusNone);
    
    [block markModified];
    assert(block.status.unsignedIntegerValue == XYDataBlockStatusModified);
    
    [block markDeleted];
    assert(block.status.unsignedIntegerValue == XYDataBlockStatusDeleted);
    
    NSLog(@"-- Block test passed!");
    
    return 0;
}

int test_run_time_utils() {
    XYDataBlock *block = data_block_constructor();
    NSDictionary *properties = propertiesOf(block, [XYMergeableObject class]);
    assert(properties.count > 0);
    
    return 0;
}

NSDictionary *test_data_block_serialization() {
    XYDataBlock *block = data_block_constructor();
    NSDictionary *json = block.jsonDictionary;
    
    assert(json.count > 0);
    
    return json;
}

NSDictionary *test_data_container_serialization() {
    XYDataContainer *container = data_container_constructor();
    NSDictionary *json = container.jsonDictionary;
    
    assert(json.count > 0);
    
    return json;
}

int test_data_block_deserialization() {
    NSDictionary *json = test_data_block_serialization();
    Setting1 *s1 = [[Setting1 alloc] initWithJsonDictionary:json];
    
    assert([s1.version isEqualToString:@"1.0.0"]);
    
    return 0;
}

int test_data_container_deserialization() {
    NSDictionary *json = test_data_container_serialization();
    Container2 *c2 = [[Container2 alloc] initWithJsonDictionary:json];
    
    assert([c2.c1.s1.version isEqualToString:@"1.0.0"]);
    
    return 0;
}

int test_data_etags() {
    XYDataContainer *container = data_container_constructor();
    NSDictionary *etags = [container etagsForStatus:XYDataBlockStatusAll];
    
    assert(etags.count > 0);
    
    return 0;
}


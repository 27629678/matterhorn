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

int test_data_block(void);

int test_run_time_utils(void);

int test_data_block_serialization(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"-- BEGIN ...");
        
        assert(test_data_block() == 0);
        
        NSLog(@"-- END.");
        
        assert(test_run_time_utils() == 0);
        
        assert(test_data_block_serialization() == 0);
    }
    
    return 0;
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
    Setting1 *s1 = [Setting1 new];
    s1.version = @"1.0.0";
    
    NSDictionary *properties = propertiesOf(s1, [XYMergeableObject class]);
    assert(properties.count > 0);
    
    return 0;
}

int test_data_block_serialization() {
    Setting1 *s1 = [Setting1 new];
    s1.version = @"1.0.0";
    NSDictionary *json = s1.jsonDictionary;
    
    assert(json.count > 0);
    
    return 0;
}

//
//  main.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XYMatterhorn.h"

int test_data_block(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"-- BEGIN ...");
        
        assert(test_data_block() == 0);
        
        NSLog(@"-- END.");
    }
    return 0;
}

int test_data_block() {
    XYDataBlock *block = [XYDataBlock new];
    
    assert([block.etag isEqualToNumber:@(0)]);
    assert(block.status == XYDataBlockStatusNone);
    
    [block markModified];
    assert(block.status == XYDataBlockStatusModified);
    
    [block markDeleted];
    assert(block.status == XYDataBlockStatusDeleted);
    
    NSLog(@"-- Block test passed!");
    
    return 0;
}

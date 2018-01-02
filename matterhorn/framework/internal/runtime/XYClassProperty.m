//
//  XYClassProperty.m
//  matterhorn
//
//  Created by hzyuxiaohua on 02/01/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "XYClassProperty.h"

#import <objc/runtime.h>

@implementation XYClassProperty

- (BOOL)isValid
{
    if (self.name.length == 0) {
        return NO;
    }
    
    if (self.cls == NULL) {
        return NO;
    }
    
    if (self.isReadonly) {
        return NO;
    }
    
    return YES;
}

#pragma mark - override
- (NSString *)description
{
    return [NSString stringWithFormat:@"<name:%@, cls:%@, protocol:%@, is mutable:%@, is readonly:%@>",
            self.name, NSStringFromClass(self.cls), self.protocol, @(self.isMutable), @(self.isReadonly)];
}

@end

NSDictionary<NSString *, XYClassProperty *>* propertiesOf(id target, Class final_cls)
{
    if (final_cls == NULL) {
        final_cls = [NSObject class];
    }
    
    if (![target isKindOfClass:final_cls]) {
        return nil;
    }
    
    NSMutableDictionary *p2p = [NSMutableDictionary dictionary];
    
    NSString *class = nil;
    NSScanner *scanner = nil;
    Class cls = [target class];
    while (cls != final_cls) {
        unsigned int property_count = 0;
        objc_property_t *objc_properties = class_copyPropertyList(cls, &property_count);
        for (unsigned int idx = 0; idx < property_count; idx ++) {
            XYClassProperty *property = [XYClassProperty new];
            objc_property_t objc_property = objc_properties[idx];
            
            // name
            const char* objc_property_name = property_getName(objc_property);
            property.name = [NSString stringWithUTF8String:objc_property_name];
            
            // attris
            const char* objc_property_attris = property_getAttributes(objc_property);
            NSString *property_attris = [NSString stringWithUTF8String:objc_property_attris];
            NSArray *attris = [property_attris componentsSeparatedByString:@","];
            
            // filter 64b BOOLs
            if ([property_attris hasPrefix:@"Tc"]) {
                continue;
            }
            
            // read only
            if ([attris containsObject:@"R"]) {
                property.readonly = YES;
            }
            
            // new scanner
            scanner = [NSScanner scannerWithString:property_attris];
            [scanner scanUpToString:@"T" intoString:nil];
            [scanner scanString:@"T" intoString:nil];
            
            if ([scanner scanString:@"@\"" intoString:nil]) {
                [scanner scanUpToCharactersFromSet:
                 [NSCharacterSet characterSetWithCharactersInString:@"\"<"] intoString:&class];
                
                // class
                property.cls = NSClassFromString(class);
                
                // is mutable
                property.isMutable = [class rangeOfString:@"Mutable"].location != NSNotFound;
                
                // protocol
                while ([scanner scanString:@"<" intoString:nil]) {
                    NSString* protocol_name = nil;
                    [scanner scanUpToString:@">" intoString:&protocol_name];
                    
                    if (protocol_name.length > 0) {
                        property.protocol = protocol_name;
                    }
                    
                    [scanner scanString:@">" intoString:nil];
                }
            }
            
            if (!property.isValid) {
                continue;
            }
            
            [p2p setObject:property forKey:property.name];
        }
        
        cls = [cls superclass];
    }
    
    return p2p.copy;
}

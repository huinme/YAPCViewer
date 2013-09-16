//
//  NSManagedObject+SafetyMapping.m
//  YAPCViewer
//
//  Created by kshuin on 8/3/13.
//  Copyright (c) 2013 www.huin-lab.com. All rights reserved.
//

#import "NSManagedObject+SafetyMapping.h"

@implementation NSManagedObject (SafetyMapping)

- (void)setAttriutesWithDict:(NSDictionary *)dict
{
    NSDictionary *attributes = [[self entity] attributesByName];

    NSSet *attrSet = [NSSet setWithArray:[attributes allKeys]];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        if(![attrSet containsObject:key]){
            return ;
        }

        if([value isEqual:[NSNull null]]){
            [self setValue:nil forKey:key];
            return;
        }

        NSAttributeType attributeType = [[attributes objectForKey:key] attributeType];
        if(NSFloatAttributeType == attributeType || NSDoubleAttributeType == attributeType){
            value = @([value doubleValue]);
        }else
            if(NSInteger16AttributeType == attributeType
               || NSInteger32AttributeType == attributeType
               || NSInteger64AttributeType == attributeType
               || NSBooleanAttributeType == attributeType){
                value = @([value intValue]);
            }

        [self setValue:value forKey:key];
    }];
}

@end

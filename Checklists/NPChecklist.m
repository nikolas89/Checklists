//
//  NPChecklist.m
//  Checklists
//
//  Created by Plumb on 5/14/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPChecklist.h"
#import "NPChecklistItem.h"

@implementation NPChecklist

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc]initWithCapacity:20];
        self.iconName = @"No Icon";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

- (NSInteger)countUncheckedItems {
    
    NSInteger count = 0;
    for (NPChecklistItem *item in self.items) {
        
        if (!item.checked) {
            count += 1;
        }
    }
    return count;
}

- (NSComparisonResult)compare:(NPChecklist *)otherChecklist
{
    return [self.name localizedStandardCompare:otherChecklist.name];
}

@end

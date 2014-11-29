//
//  NPChecklist.h
//  Checklists
//
//  Created by Plumb on 5/14/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPChecklist : NSObject <NSCoding>

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *items;
@property (copy, nonatomic) NSString *iconName;

- (NSInteger)countUncheckedItems;

@end

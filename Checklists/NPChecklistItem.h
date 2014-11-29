//
//  ChecklistItem.h
//  Checklists
//
//  Created by Plumb on 5/11/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPChecklistItem : NSObject <NSCoding>

@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL checked;

@property (copy, nonatomic) NSDate *dueDate;
@property (assign, nonatomic) BOOL shouldRemind;
@property (assign, nonatomic) NSInteger itemId;

- (void)toggleChecked;
- (void)scheduleNotification;

@end

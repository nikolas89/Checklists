//
//  ChecklistItem.m
//  Checklists
//
//  Created by Plumb on 5/11/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPChecklistItem.h"
#import "NPDataModel.h"

@implementation NPChecklistItem

- (void)toggleChecked {
    
    self.checked = !self.checked;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemId = [NPDataModel nextChecklistItemId];
    }
    return self;
}

- (void)dealloc {
    
   UILocalNotification *existingNotification = [self notificationForThisItem];

   if (existingNotification) {
        NSLog(@"Removing exiting notification %@", existingNotification);
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
   }
}

- (void)scheduleNotification {
    
    UILocalNotification *existingNotification = [self notificationForThisItem];
    
    if (existingNotification) {
        NSLog(@"Found an exiting notification %@", existingNotification);
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
    
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemId": @(self.itemId)};
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        
        NSLog(@"Scheduled notification %@ for itemId %ld", localNotification, (long)self.itemId);
    }
}

- (UILocalNotification *)notificationForThisItem {
    
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    for (UILocalNotification *notification in allNotifications) {
        
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        
        if (number && [number integerValue] == self.itemId) {
            return notification;
        }
    }
    return nil;
}

@end

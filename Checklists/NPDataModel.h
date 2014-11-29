//
//  NPDataModel.h
//  Checklists
//
//  Created by Plumb on 5/16/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPDataModel : NSObject

@property (strong, nonatomic) NSMutableArray *lists;

+ (NSInteger)nextChecklistItemId;

- (void)saveChecklists;
- (NSInteger)indexOfSelectedChecklist;
- (void)setIndexOfSelectedChecklist:(NSInteger)index;
- (void)sortChecklists;

@end

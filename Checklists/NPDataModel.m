//
//  NPDataModel.m
//  Checklists
//
//  Created by Plumb on 5/16/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPDataModel.h"
#import "NPChecklist.h"

@implementation NPDataModel

+ (NSInteger)nextChecklistItemId {
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  NSInteger itemId = [userDefaults integerForKey:@"ChecklistItemId"];
  [userDefaults setInteger:itemId + 1 forKey:@"ChecklistItemId"];
  
  [userDefaults synchronize];
  return itemId;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}

- (NSString *)documentsDirectory {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path firstObject];
    return documentsDirectory;
}

- (NSString *)dataFilePath {
    
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)saveChecklists {
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadChecklists {
    
    NSString *path = [self dataFilePath];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.lists = [unarchiver decodeObjectForKey:@"Checklists"];
        [unarchiver finishDecoding];
        
    } else {
        
        self.lists = [[NSMutableArray alloc]initWithCapacity:20];
    }
}

- (void)sortChecklists {
    
    [self.lists sortUsingSelector:@selector(compare:)];
}

#pragma mark - RegisterDefaults

- (void)registerDefaults {
    
    NSDictionary *dictionary = @{@"ChecklistItem" : @-1,
                                 @"FirstTime" : @YES,
                                 @"ChecklistItemId" : @0,};
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
}

- (NSInteger)indexOfSelectedChecklist {
    
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"ChecklistIndex"];
}

- (void)setIndexOfSelectedChecklist:(NSInteger)index {
    
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"ChecklistIndex"];
}

- (void)handleFirstTime {
    
    BOOL firstTime = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTime"];
    
    if (firstTime) {
        
        NPChecklist *checklist = [[NPChecklist alloc]init];
        checklist.name = @"List";
        
        [self.lists addObject:checklist];
        [self setIndexOfSelectedChecklist:0];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstTime"];
    }
}

@end

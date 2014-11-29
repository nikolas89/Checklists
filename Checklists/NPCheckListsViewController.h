//
//  NPViewController.h
//  Checklists
//
//  Created by Plumb on 5/10/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPItemDetailViewController.h"

@class NPChecklist;

@interface NPChecklistViewController : UITableViewController <NPItemDetailViewControllerDelegate>

@property (strong, nonatomic) NPChecklist *checklist;

@end

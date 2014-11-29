//
//  NPAllListsViewController.h
//  Checklists
//
//  Created by Plumb on 5/14/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPListDetailViewController.h"

@class NPDataModel;

@interface NPAllListsViewController : UITableViewController <NPListDetailViewControllerDelegte, UINavigationControllerDelegate>

@property (strong, nonatomic) NPDataModel *dataModel;

@end

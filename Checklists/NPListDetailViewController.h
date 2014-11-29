//
//  NPListDetailViewController.h
//  Checklists
//
//  Created by Plumb on 5/14/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPIconPickerViewController.h"

@class NPListDetailViewController;
@class NPChecklist;

@protocol NPListDetailViewControllerDelegte <NSObject>

- (void)listDetailViewControllerDidCancel:(NPListDetailViewController *)controller;
- (void)listDetailViewController:(NPListDetailViewController *)controller didFinishAdditingChecklist:(NPChecklist *)checklist;
- (void)listDetailViewController:(NPListDetailViewController *)controller didFinishEditingChecklist:(NPChecklist *)checklist;

@end



@interface NPListDetailViewController : UITableViewController <UITextFieldDelegate, NPIconPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) id <NPListDetailViewControllerDelegte> delegate;
@property (strong, nonatomic) NPChecklist *checklistToEdit;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (IBAction)cancelAction;
- (IBAction)doneAction;

@end

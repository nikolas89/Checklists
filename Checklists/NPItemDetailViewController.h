//
//  NPAddItemViewController.h
//  Checklists
//
//  Created by Plumb on 5/12/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NPItemDetailViewController;
@class NPChecklistItem;

@protocol NPItemDetailViewControllerDelegate <NSObject>

- (void)addItemDetailViewControllerDidCancel:(NPItemDetailViewController *)controller;
- (void)addItemDetailViewController:(NPItemDetailViewController *)controller didfinishAdditingItem:(NPChecklistItem *)item;
- (void)addItemDetailViewController:(NPItemDetailViewController *)controller didfinishEditingItem:(NPChecklistItem *)item;

@end



@interface NPItemDetailViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) id <NPItemDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) NPChecklistItem *itemToEdit;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

- (IBAction)camcelAction;
- (IBAction)doneAction;

@end

//
//  NPIconPickerViewController.h
//  Checklists
//
//  Created by Plumb on 5/17/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NPIconPickerViewController;

@protocol NPIconPickerViewControllerDelegate <NSObject>

- (void)iconPicker:(NPIconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end



@interface NPIconPickerViewController : UITableViewController

@property (weak, nonatomic) id <NPIconPickerViewControllerDelegate> delegate;

@end

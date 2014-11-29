//
//  NPListDetailViewController.m
//  Checklists
//
//  Created by Plumb on 5/14/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPListDetailViewController.h"
#import "NPChecklist.h"

@interface NPListDetailViewController ()

@end

@implementation NPListDetailViewController {
    
    NSString *_iconName;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if (self.checklistToEdit) {
        self.title = @"Edit Checklist";
        self.textField.text = self.checklistToEdit.name;
        self.doneBarButton.enabled = YES;
        _iconName = self.checklistToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:_iconName];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _iconName = @"Folder";
    }
    return self;
}

#pragma mark - Actions

- (IBAction)cancelAction {
    
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)doneAction {
    
    if (!self.checklistToEdit) {

        NPChecklist *checklist = [[NPChecklist alloc]init];
        checklist.name = self.textField.text;
        checklist.iconName = _iconName;
        
        [self.delegate listDetailViewController:self didFinishAdditingChecklist:checklist];
    } else {
        self.checklistToEdit.name = self.textField.text;
        self.checklistToEdit.iconName = _iconName;
        
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self.checklistToEdit];
    }
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return indexPath;
        
    } else {
        
        return nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        
        NPIconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - NPIconPickerViewControllerDelegate

- (void)iconPicker:(NPIconPickerViewController *)picker didPickIcon:(NSString *)theIconName {
    
    _iconName = theIconName;
    self.iconImageView.image = [UIImage imageNamed:_iconName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

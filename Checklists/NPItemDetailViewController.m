//
//  NPAddItemViewController.m
//  Checklists
//
//  Created by Plumb on 5/12/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPItemDetailViewController.h"
#import "NPChecklistItem.h"

@interface NPItemDetailViewController ()

@end

@implementation NPItemDetailViewController {
    
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if (self.itemToEdit != nil) {
        self.title = @"Edit item";
        self.textField.text = self.itemToEdit.text;
        self.doneBarButton.enabled = YES;
        self.switchControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
    } else {
        self.switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    [self updateDueDateLabel];
}

- (void)updateDueDateLabel {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}

#pragma mark - Action

- (IBAction)camcelAction {
    
    [self.delegate addItemDetailViewControllerDidCancel:self];
}

- (IBAction)doneAction {
    
    if (!self.itemToEdit) {
        NPChecklistItem *item = [[NPChecklistItem alloc]init];
        item.text = self.textField.text;
        item.checked = NO;
        item.shouldRemind = self.switchControl.on;
        item.dueDate = _dueDate;
        [item scheduleNotification];
        
        [self.delegate addItemDetailViewController:self didfinishAdditingItem:item];
      
    } else {
      
        self.itemToEdit.text = self.textField.text;
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = _dueDate;
        [self.itemToEdit scheduleNotification];
        
        [self.delegate addItemDetailViewController:self didfinishEditingItem:self.itemToEdit];
    }
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        return indexPath;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 217.0f;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.textField resignFirstResponder];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        } else {
            [self hideDatePicker];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
        
    } else {
        
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1 && _datePickerVisible) {
        return 3;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 & indexPath.row == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
      
    } else {
      
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self hideDatePicker];
}

#pragma mark - DatePicker 

- (void)showDatePicker {
    
    _datePickerVisible = YES;
    
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker *)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

- (void)hideDatePicker {
    
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

@end

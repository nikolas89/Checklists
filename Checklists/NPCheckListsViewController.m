//
//  NPViewController.m
//  Checklists
//
//  Created by Plumb on 5/10/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPChecklistsViewController.h"
#import "NPChecklistItem.h"
#import "NPChecklist.h"

@interface NPChecklistViewController ()

@end

@implementation NPChecklistViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = self.checklist.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.checklist.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem"];
    
    NPChecklistItem *item = self.checklist.items[indexPath.row];
    
    [self configureCheckmarkForCell:cell withChacklistItem:item];
    [self configureTextForCell:cell withChecklistItem:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NPChecklistItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withChacklistItem:item];
}

#pragma mark - Private

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChacklistItem:(NPChecklistItem *)item {
    
    UILabel *label = (UILabel *)[cell viewWithTag:1001];
    
    if (item.checked) {
        label.text = @"√";
    } else {
        label.text = @"";
    }
    label.textColor = self.view.tintColor;
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(NPChecklistItem *)item {
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = [NSString stringWithFormat:@"%@", item.text];
}

#pragma mark - NPItemDetailViewControllerDelegate

- (void)addItemDetailViewControllerDidCancel:(NPItemDetailViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemDetailViewController:(NPItemDetailViewController *)controller didfinishAdditingItem:(NPChecklistItem *)item {
    
    NSInteger newRowIndex = [self.checklist.items count];
    [self.checklist.items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addItemDetailViewController:(NPItemDetailViewController *)controller didfinishEditingItem:(NPChecklistItem *)item {
    
    NSUInteger index = [self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        NPItemDetailViewController *controller = (NPItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"EditItem"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        NPItemDetailViewController *controller = (NPItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.checklist.items[indexPath.row];
    }
}

@end

//
//  NPAllListsViewController.m
//  Checklists
//
//  Created by Plumb on 5/14/14.
//  Copyright (c) 2014 Plumb. All rights reserved.
//

#import "NPAllListsViewController.h"
#import "NPChecklist.h"
#import "NPChecklistsViewController.h"
#import "NPChecklistItem.h"
#import "NPDataModel.h"

@interface NPAllListsViewController ()

@end

@implementation NPAllListsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    self.navigationController.delegate = self;
    NSInteger index = [self.dataModel indexOfSelectedChecklist];
    if (index >= 0 && index < [self.dataModel.lists count]) {
        
        NPChecklist *checklist = self.dataModel.lists[index];
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModel.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NPChecklist *checklist = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSInteger count = [checklist countUncheckedItems];
   
    if ([checklist.items count] == 0) {
        cell.detailTextLabel.text = @"(No Items)";
    } else if (count == 0) {
        cell.detailTextLabel.text = @"All Done";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Remaining", (long)count];
    }
    cell.imageView.image = [UIImage imageNamed:checklist.iconName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    
    NPChecklist *checklist = self.dataModel.lists[indexPath.row];
    
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    
    NPListDetailViewController *controller = (NPListDetailViewController *)navigationController.topViewController;
    controller.delegate = self;
    
    NPChecklist *checklist = self.dataModel.lists[indexPath.row];
    controller.checklistToEdit = checklist;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
      
      NPChecklistViewController *controller = segue.destinationViewController;
      controller.checklist = sender;
      
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        NPListDetailViewController *controller = (NPListDetailViewController *)navigationController.topViewController;
        
        controller.delegate = self;
        controller.checklistToEdit = nil;
    }
}

#pragma mark - NPListDetailViewControllerDelegte

- (void)listDetailViewControllerDidCancel:(NPListDetailViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(NPListDetailViewController *)controller didFinishAdditingChecklist:(NPChecklist *)checklist {
    
    [self.dataModel.lists addObject:checklist];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(NPListDetailViewController *)controller didFinishEditingChecklist:(NPChecklist *)checklist {
    
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (viewController == self) {
        
        [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}

@end

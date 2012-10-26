//
//  DisclaimerViewController.m
//  DirkJan
//
//  Created by Hendrik Bruinsma on 08-09-12.
//  Copyright (c) 2012 Hendrik Bruinsma. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "Const.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

@synthesize licenses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.licenses = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Disclaimer" ofType:@"plist"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"DISCLAIMER_TITLE", @"");
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
    return [[self.licenses objectAtIndex:section] objectForKey:@"License"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.licenses count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    }
    
    cell.textLabel.text = [[self.licenses objectAtIndex:indexPath.section] objectForKey:@"Title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

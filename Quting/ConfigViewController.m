//
//  ConfigViewController.m
//  Quting
//
//  Created by Johnil on 13-5-29.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "ConfigViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import "iVersion.h"
@interface ConfigViewController ()

@end

@implementation ConfigViewController {
    NSArray *names;
    NSArray *icons;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    names = @[@"关于", @"帮助"];
    icons = @[@"info.png", @"help.png"];

    self.tableView.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1];
    self.tableView.backgroundView = bgView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated{
    self.tableView.frame = CGRectMake(60, 0, 270, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-.5, 320, .5)];
        line.backgroundColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1];
        [cell addSubview:line];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.imageView.image = imageNamed([icons objectAtIndex:indexPath.row]);
    cell.textLabel.text = [names objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        AboutViewController *help = [[AboutViewController alloc] init];
        UINavigationController *tempNavi = [[UINavigationController alloc] initWithRootViewController:help];
        [tempNavi.navigationBar setBackgroundImage:imageNamed(@"navi_background.png") forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:tempNavi animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BACKTOMAIN object:nil];
        }];
    }
    if (indexPath.row==1) {
        HelpViewController *help = [[HelpViewController alloc] init];
        UINavigationController *tempNavi = [[UINavigationController alloc] initWithRootViewController:help];
        [tempNavi.navigationBar setBackgroundImage:imageNamed(@"navi_background.png") forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:tempNavi animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:BACKTOMAIN object:nil];
        }];
    }
}

@end

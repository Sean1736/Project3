//
//  ViewController.m
//  Project3
//
//  Created by Cindy Barnsdale on 5/17/16.
//  Copyright © 2016 Dr Tech PC. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"



@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// This declares we want a NSMutableArray
@property NSMutableArray *titles;
// Add another property for descriptions
@property NSMutableArray *descriptions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Taking the properties above and loading them into memory. Both new or alloc init do the same thing, just alloc init gives you more options.
    self.titles = [NSMutableArray new];
    self.descriptions = [[NSMutableArray alloc]init];
    
}
//Displaying titles of our dreams in a list (Custom method we create for what to do when we want to present an alert to the user so they can add a dream.)

-(void)presentDreamEntry{
//make an instance of the UIAlertController
    // Instead of alloc init, use alertControllerWithTitle, NSString: set title, message:nil, style: UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter New Dream" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //Add text field with default background text for the user to insert their response. Dream Title is a description of what to put in the box.
            // The configurationHandler is where we set any properties we want for the text field before something is typed in the text field. Textfield.placeholder is in reference to the _Nonnull textField
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Dream Title";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Dream Description";
    }];
    
    // Add a cancel and a save action
        // Again we use WithTitle instead of alloc init but we use ActionWithTitle. NSString set title, style: UIAlertActionStyleCancel (This makes sense), handler: nil (If they hit cancel we don't want anything to happen)
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    //For Save we use UIAlertActionStyleDefault instead of cancel, then we want a handler at the end. If they hit save, we want UITextField
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // We create a text area called textField1 that references the text above Dream Title and since there is only one of them in the array we use .firstObject. If there are multiple options you can say objectAtIndex:0 1 2 etc.
        UITextField *textField1 = alertController.textFields.firstObject;
        // If the user wants to save their results in the titles box.
        [self.titles addObject:textField1.text];
        // If the user wants to save their results from the description box. Just copying alertController from above, does same as textField1.text except we are using the lastObject.
        [self.descriptions addObject:alertController.textFields.lastObject.text];
        // We want to reload the data
        [self.tableView reloadData];
    }];
    // We need to add these actions to the alertcontroller.
    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];
    // completion is nil since that would be any code that we would want to happen after the viewcontroller.
    [self presentViewController:alertController animated:true completion:nil];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellID"];
// Final step: Now that we have added a string to the array, we haven't told the code to change the text in the cells, we insert this:
    //Note: the indexPath is referencing the code right above. Row will give us the corresponding row in our array that we are trying to display in our tableview.
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    // Now that we went to storyboard and changed prototype cells properties to subtitles, we add this:
    cell.detailTextLabel.text = [self.descriptions objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Now since we have this array we can use that to determine the number of rowns in sections. Instead of return 1; use this:
    return self.titles.count;
}


// Adding edit button functionality to the app.
- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    if(self.editing) {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    } else {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";
    }
}
// Once edit is clicked these two items (canMoveRow & moveRow) provide the ability to move the order of the items in each row.
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
return true;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // When we move the order of the row, if we click it, the results on the next page don't update, this fixes the issue.
    NSString *title = [self.titles objectAtIndex:sourceIndexPath.row];
    [self.titles removeObject:title];
    [self.titles insertObject:title atIndex:destinationIndexPath.row];
    NSString *description = [self.descriptions objectAtIndex:sourceIndexPath.row];
    [self.descriptions removeObject:description];
    [self.descriptions insertObject:description atIndex:destinationIndexPath.row];
}

- (IBAction)onAddButtonPressed:(UIBarButtonItem *)sender {
    
    // Calling presentDreamEntry from above in the addButtonPressed.
    [self presentDreamEntry];
}


/* Video 4: Objective is to show a full detailed description on a new page in the app once you click the title.
 
 Add a new view controller in storyboard, drag in a segway(control drag) from prototype cell into new view controller (hit show), drag in a text view, make a new corresponding class file for this new view controller (cocoa class -> DetailedViewController subclass of: UIViewController), select the new view controller and change class to DetailedViewController, set an outlet for the text field to dvc.m, set two @property in dvc.h. (titleString & descriptionString)
 */

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController *dvc = segue.destinationViewController;
    // Since we added @property in dvc.h titleString and descriptionString are visible.
    // Set to titles array
    // Instead of indexpath.row we will call self.tableView.indexPathForSelectedRow.row. Will give us an index path for whatever row the user taps. Repeat for descriptionString.
    dvc.titleString = [self.titles objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    dvc.descriptionString = [self.descriptions objectAtIndex:self.tableView.indexPathForSelectedRow.row];
}

// Adding a delete button for items in the row.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.titles removeObjectAtIndex:indexPath.row];
    [self.descriptions removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end

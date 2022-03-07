//
//  ViewController.m
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import "ViewController.h"
#import "NewTask.h"
#import "ShowTask.h"
#import "Task.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableTodo;
@property (weak, nonatomic) IBOutlet UIImageView *backGround;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneItemOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *todoItemOutlet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *progressItemOutlet;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *allListOutlet;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelOutlet;

@end

@implementation ViewController{
    NSMutableArray *todoHigh, *todoMed,*todoLow,*searchTempArray,*allListArray;
    NSMutableArray *progressH,*progressM,*progressL;
    NSMutableArray *doneH,*doneM,*doneL;
    int screenStatus;
    BOOL isSearching;
    NSString *searchByNameStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    todoHigh = [[NSMutableArray alloc] init];
    todoMed = [[NSMutableArray alloc] init];
    todoLow = [[NSMutableArray alloc] init];
    
    progressH = [[NSMutableArray alloc] init];
    progressM = [[NSMutableArray alloc] init];
    progressL = [[NSMutableArray alloc] init];
    
    doneH = [[NSMutableArray alloc] init];
    doneM = [[NSMutableArray alloc] init];
    doneL = [[NSMutableArray alloc] init];
    
    searchTempArray = [[NSMutableArray alloc] init];
    allListArray = [[NSMutableArray alloc] init];
    
    [self getArrayFromUserDefault:todoHigh withKey:@"todoHigh"];
    [self getArrayFromUserDefault:todoMed withKey:@"todoMed"];
    [self getArrayFromUserDefault:todoLow withKey:@"todoLow"];
    [self getArrayFromUserDefault:progressH withKey:@"progressH"];
    [self getArrayFromUserDefault:progressM withKey:@"progressM"];
    [self getArrayFromUserDefault:progressL withKey:@"progressL"];
    [self getArrayFromUserDefault:doneH withKey:@"doneH"];
    [self getArrayFromUserDefault:doneM withKey:@"doneM"];
    [self getArrayFromUserDefault:doneL withKey:@"doneL"];
    
    
    self.searchBar.delegate = self;
    _todoItemOutlet.tintColor = UIColor.redColor;
    [_searchBar setHidden:true];
    screenStatus =0;
    searchByNameStr = @"";
    
    
    if (todoHigh.count>0 || todoMed.count>0 || todoLow.count>0 || allListArray.count>0) {
        [_tableTodo setHidden:NO];
        [_backGround setHidden:YES];
    }else{
        [_tableTodo setHidden:YES];
        [_backGround setHidden:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableTodo reloadData];
    if ([allListArray count] > 0) {
        [allListArray removeAllObjects];
    }
    [allListArray addObjectsFromArray:todoHigh];
    [allListArray addObjectsFromArray:todoMed];
    [allListArray addObjectsFromArray:todoLow];
    [allListArray addObjectsFromArray:progressH];
    [allListArray addObjectsFromArray:progressM];
    [allListArray addObjectsFromArray:progressL];
    [allListArray addObjectsFromArray:doneH];
    [allListArray addObjectsFromArray:doneM];
    [allListArray addObjectsFromArray:doneL];
}


-(NSMutableArray*)getArrayFromUserDefault:(NSMutableArray *)myArray withKey:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSSet *set=[NSSet setWithArray:@[[NSMutableArray class],[Task class]]];
    NSMutableArray<Task*> *unarchive=(NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:NULL];
    [myArray addObjectsFromArray:unarchive];
    return myArray;
}
-(void)setArrayInUserDefault:(NSMutableArray *)myArray withKey:(NSString *)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:myArray requiringSecureCoding:YES error:NULL];
    [defaults setObject:data forKey:keyName];
}


- (void)setTask:(Task *)task withKey:(char)key{
    unichar firstChar = [[task.prio lowercaseString] characterAtIndex:0];
    if (firstChar == 'h') {
        [todoHigh addObject : task];
    }
    else if (firstChar == 'm'){
        [todoMed addObject : task];
    }
    else{
        [todoLow addObject : task];
    }
    
    if (todoHigh.count>0 || todoMed.count>0 || todoLow.count>0) {
        [_tableTodo setHidden:NO];
        [_backGround setHidden:YES];
    }else{
        [_tableTodo setHidden:YES];
        [_backGround setHidden:NO];
    }
    
    [_searchBar setHidden:true];
    [_titleLabelOutlet setHidden:false];
    _titleLabelOutlet.text=@"To Do List";
    _progressItemOutlet.tintColor = UIColor.systemYellowColor;
    _allListOutlet.tintColor = UIColor.systemYellowColor;
    _todoItemOutlet.tintColor = UIColor.redColor;
    _doneItemOutlet.tintColor = UIColor.systemYellowColor;
    screenStatus=0;
    
    
    [self setArrayInUserDefault:todoHigh withKey:@"todoHigh"];
    [self setArrayInUserDefault:todoMed withKey:@"todoMed"];
    [self setArrayInUserDefault:todoLow withKey:@"todoLow"];
    [self.tableTodo reloadData];
}



- (IBAction)addTask:(id)sender {
    NewTask *newTask = [self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
    newTask.key='0';     //  open new task screen to do: (new task)
    [newTask setTaskProtocol : self];
    [self.navigationController pushViewController:newTask animated: NO];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    @try
    {
        isSearching=YES;
        [searchTempArray removeAllObjects];
        if ([searchText length] > 0)
        {
            for (int i = 0; i < [allListArray count] ; i++)
            {
                searchByNameStr = [[allListArray objectAtIndex:i]name];
                if (searchByNameStr.length >= searchText.length)
                {
                    NSRange titleResultsRange = [searchByNameStr rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResultsRange.length > 0)
                    {
                        [searchTempArray addObject:[allListArray objectAtIndex:i]];
                    }
                }
            }
        }
        else
        {
            [searchTempArray addObjectsFromArray:allListArray];
        }
        [self.tableTodo reloadData];
    }
    @catch (NSException *exception) {
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)SearchBar
{
    if ([SearchBar.text length] > 0) {
        isSearching=YES;
    }else{
        isSearching=NO;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
    theSearchBar.text=@"";
    [searchTempArray removeAllObjects];
    isSearching=NO;
    [self.tableTodo reloadData];
    //[theSearchBar resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (screenStatus == 3) {
        return 1;
    }else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (screenStatus == 3) {
        if (isSearching) {
            return [searchTempArray count];
        }else{
            return [allListArray count];
        }
    }else {
        switch (section) {
            case 0:
                if (screenStatus==0) {
                    return [todoHigh count];
                }else if (screenStatus==1){
                    return [progressH count];
                }else if (screenStatus==2){
                    return [doneH count];
                }
                break;
            case 1:
                if (screenStatus==0) {
                    return [todoMed count];
                }else if (screenStatus==1){
                    return [progressM count];
                }else if (screenStatus==2){
                    return [doneM count];
                }
                break;
            case 2:
                if (screenStatus==0) {
                    return [todoLow count];
                }else if (screenStatus==1){
                    return [progressL count];
                }else if (screenStatus==2){
                    return [doneL count];
                }
                break;
            default:
                return 0;
                break;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *title = [cell viewWithTag:1];
    UILabel *Date = [cell viewWithTag:2];
    UIImageView *priority = [cell viewWithTag:3];
    UILabel *status = [cell viewWithTag:4];
    if (screenStatus == 3) {
        if (isSearching) {
            title.text=[[searchTempArray objectAtIndex:indexPath.row]name];
            Date.text = [[searchTempArray objectAtIndex:indexPath.row] cdate];
            priority.image = [UIImage imageNamed : [[searchTempArray objectAtIndex:indexPath.row]prio]];
            status.text = [[searchTempArray objectAtIndex:indexPath.row]status];
        }else{
            title.text=[[allListArray objectAtIndex:indexPath.row]name];
            Date.text = [[allListArray objectAtIndex:indexPath.row] cdate];
            priority.image = [UIImage imageNamed : [[allListArray objectAtIndex:indexPath.row]prio]];
            status.text = [[allListArray objectAtIndex:indexPath.row]status];
        }
        
    }else{
        if (screenStatus==0) {
            switch (indexPath.section) {
                case 0:
                    title.text = [[todoHigh objectAtIndex:indexPath.row] name];
                    Date.text = [[todoHigh objectAtIndex:indexPath.row] cdate];
                    priority.image = [UIImage imageNamed : @"High"];
                    break;
                    
                case 1:
                    title.text = [[todoMed objectAtIndex:indexPath.row]name];
                    Date.text = [[todoMed objectAtIndex:indexPath.row] cdate];
                    priority.image =[UIImage imageNamed: @"Med"];
                    break;
                    
                case 2:
                    title.text = [[todoLow objectAtIndex:indexPath.row] name];
                    Date.text = [[todoLow objectAtIndex:indexPath.row] cdate];
                    priority.image =[UIImage imageNamed: @"Low"];
                    break;
                default:
                    break;
            }
            status.text = @"TO DO";
            
        }else if (screenStatus==1){
            switch (indexPath.section) {
                case 0:
                    title.text = [[progressH objectAtIndex:indexPath.row] name];
                    Date.text = [[progressH objectAtIndex:indexPath.row] cdate];
                    priority.image = [UIImage imageNamed : @"High"];
                    break;
                    
                case 1:
                    title.text = [[progressM objectAtIndex:indexPath.row]name];
                    Date.text = [[progressM objectAtIndex:indexPath.row] cdate];
                    priority.image =[UIImage imageNamed: @"Med"];
                    break;
                    
                case 2:
                    title.text = [[progressL objectAtIndex:indexPath.row] name];
                    Date.text = [[progressL objectAtIndex:indexPath.row] cdate];
                    priority.image =[UIImage imageNamed: @"Low"];
                    break;
                default:
                    break;
            }
            status.text = @"Progress";
            
        }else if (screenStatus==2){
            switch (indexPath.section) {
                case 0:
                    title.text = [[doneH objectAtIndex:indexPath.row] name];
                    Date.text = [[doneH objectAtIndex:indexPath.row] cdate];
                    priority.image = [UIImage imageNamed : @"Kigh"];
                    break;
                    
                case 1:
                    title.text = [[doneM objectAtIndex:indexPath.row]name];
                    Date.text = [[doneM objectAtIndex:indexPath.row] cdate];
                    priority.image =[UIImage imageNamed: @"Med"];
                    break;
                    
                case 2:
                    title.text = [[doneL objectAtIndex:indexPath.row] name];
                    Date.text = [[doneL objectAtIndex:indexPath.row] cdate];
                    priority.image =[UIImage imageNamed: @"Low"];
                    break;
                default:
                    break;
            }
            status.text = @"Done";
        }
    }
    cell.contentView.layer.cornerRadius =25;
    cell.contentView.layer.borderWidth =5;
    cell.contentView.layer.borderColor = UIColor.whiteColor.CGColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowTask *showTask=[self.storyboard instantiateViewControllerWithIdentifier:@"showTask"];
    if (screenStatus == 3) {
        if (isSearching) {
            showTask.showName = [[searchTempArray objectAtIndex:indexPath.row]name];
            showTask.showDesc = [[searchTempArray objectAtIndex:indexPath.row]desc];
            showTask.showDate = [[searchTempArray objectAtIndex:indexPath.row]cdate];
            showTask.showStatus = [[searchTempArray objectAtIndex:indexPath.row]status];
        }else{
            showTask.showName = [[allListArray objectAtIndex:indexPath.row]name];
            showTask.showDesc = [[allListArray objectAtIndex:indexPath.row]desc];
            showTask.showDate = [[allListArray objectAtIndex:indexPath.row]cdate];
            showTask.showStatus = [[allListArray objectAtIndex:indexPath.row]status];
        }
        
        [self.navigationController pushViewController : showTask animated:YES];
    }else {
        if (screenStatus==0) {
            switch (indexPath.section) {
                case 0:
                    showTask.showName = [[todoHigh objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[todoHigh objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[todoHigh objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[todoHigh objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[todoHigh objectAtIndex:indexPath.row]status];
                    showTask.showH = todoHigh;
                    showTask.index = indexPath.row;
                    break;
                case 1:
                    showTask.showName = [[todoMed objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[todoMed objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[todoMed objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[todoMed objectAtIndex:indexPath.row]prio];
                    showTask.showStatus =[[todoMed objectAtIndex:indexPath.row]status];
                    showTask.showM = todoMed;
                    showTask.index = indexPath.row;
                    break;
                case 2:
                    showTask.showName = [[todoLow objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[todoLow objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[todoLow objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[todoLow objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[todoLow objectAtIndex:indexPath.row]status];
                    showTask.showL = todoLow;
                    showTask.index = indexPath.row;
                    break;
                default:
                    break;
            }
        }else if (screenStatus==1) {
            switch (indexPath.section) {
                case 0:
                    showTask.showName = [[progressH objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[progressH objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[progressH objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[progressH objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[progressH objectAtIndex:indexPath.row]status];
                    showTask.showH = progressH;
                    showTask.index = indexPath.row;
                    break;
                case 1:
                    showTask.showName = [[progressM objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[progressM objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[progressM objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[progressM objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[progressM objectAtIndex:indexPath.row]status];
                    showTask.showM = progressM;
                    showTask.index = indexPath.row;
                    break;
                case 2:
                    showTask.showName = [[progressL objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[progressL objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[progressL objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[progressL objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[progressL objectAtIndex:indexPath.row]status];
                    showTask.showL = progressL;
                    showTask.index = indexPath.row;
                    break;
                default:
                    break;
            }
        }else if (screenStatus==2) {
            switch (indexPath.section) {
                case 0:
                    showTask.showName = [[doneH objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[doneH objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[doneH objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[doneH objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[doneH objectAtIndex:indexPath.row]status];
                    showTask.showH = doneH;
                    showTask.index = indexPath.row;
                    break;
                case 1:
                    showTask.showName = [[doneM objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[doneM objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[doneM objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[doneM objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[doneM objectAtIndex:indexPath.row]status];
                    showTask.showM = doneM;
                    showTask.index = indexPath.row;
                    break;
                case 2:
                    showTask.showName = [[doneL objectAtIndex:indexPath.row]name];
                    showTask.showDesc = [[doneL objectAtIndex:indexPath.row]desc];
                    showTask.showDate = [[doneL objectAtIndex:indexPath.row]cdate];
                    showTask.showPriority = [[doneL objectAtIndex:indexPath.row]prio];
                    showTask.showStatus = [[doneL objectAtIndex:indexPath.row]status];
                    showTask.showL = doneL;
                    showTask.index = indexPath.row;
                    break;
                default:
                    break;
            }
            
        }
        
        [self.navigationController pushViewController : showTask animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (screenStatus != 3) {
        switch (section) {
            case 0:
                return @"HIGH Priority";
                break;
            case 1:
                return @"MED Priority";
                break;
            case 2:
                return @"LOW Priority";
                break;
            default:
                return @"";
                break;
        }
    }else
        return @"";
}




- (void)editTask:(Task *)task index:(NSInteger)index{
    unichar firstChar = [[task.prio lowercaseString] characterAtIndex:0];
    
    if ([task.status isEqualToString:@"TODO"]) {  //if select todo
        if (firstChar == 'h') {
            [todoHigh replaceObjectAtIndex:index withObject:task];
        }
        else if (firstChar == 'm'){
            [todoMed replaceObjectAtIndex:index withObject:task];
        }
        else{
            [todoLow replaceObjectAtIndex:index withObject:task];
        }
        
    }else if ([task.status isEqualToString:@"PROGRESS"]) {  //if select progress
        if (firstChar == 'h') {
            if (screenStatus==1) {
                [progressH replaceObjectAtIndex:index withObject:task];
            }else{
                [progressH addObject:task];
                [todoHigh removeObjectAtIndex:index];
            }
        }
        else if (firstChar == 'm'){
            if (screenStatus==1) {
                [progressM replaceObjectAtIndex:index withObject:task];
            }else{
                [progressM addObject:task];
                [todoMed removeObjectAtIndex:index];
            }
        }
        else{
            if (screenStatus==1) {
                [progressL replaceObjectAtIndex:index withObject:task];
            }else{
                [progressL addObject:task];
                [todoLow removeObjectAtIndex:index];
            }
        }
        
        if (todoHigh.count>0 || todoMed.count>0 || todoLow.count>0) {
            [_tableTodo setHidden:NO];
            [_backGround setHidden:YES];
        }else{
            [_tableTodo setHidden:YES];
            [_backGround setHidden:NO];
        }
        
    }else if([task.status isEqualToString:@"DONE"]){ //if select done
        if (firstChar == 'h') {
            [doneH addObject:task];
            [progressH removeObjectAtIndex:index];
        }
        else if (firstChar == 'm'){
            [doneM addObject:task];
            [progressM removeObjectAtIndex:index];
        }
        else{
            [doneL addObject:task];
            [progressL removeObjectAtIndex:index];
        }
        
        if (progressH.count>0 || progressM.count>0 || progressL.count>0) {
            [_tableTodo setHidden:NO];
            [_backGround setHidden:YES];
        }else{
            [_tableTodo setHidden:YES];
            [_backGround setHidden:NO];
        }
    }
    [self setArrayInUserDefault:self->todoHigh withKey:@"todoHigh"];
    [self setArrayInUserDefault:self->todoMed withKey:@"todoMed"];
    [self setArrayInUserDefault:self->todoLow withKey:@"todoLow"];
    
    [self setArrayInUserDefault:self->progressH withKey:@"progressH"];
    [self setArrayInUserDefault:self->progressM withKey:@"progressM"];
    [self setArrayInUserDefault:self->progressL withKey:@"progressL"];
    
    [self setArrayInUserDefault:self->doneH withKey:@"doneH"];
    [self setArrayInUserDefault:self->doneM withKey:@"doneM"];
    [self setArrayInUserDefault:self->doneL withKey:@"doneL"];
    [self.tableTodo reloadData];
}




- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableTodo) {
        UIContextualAction *edit = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Edit" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Editing" message:@"Are you sure to edit this Task ?" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *edit =[UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                NewTask *newTask = [self.storyboard instantiateViewControllerWithIdentifier:@"newTask"];
                newTask.key='1';               //  open new task screen to do: (edit)
                if (self->screenStatus==0) {
                    
                    switch (indexPath.section) {
                        case 0:
                            newTask.editName = [[self->todoHigh objectAtIndex:indexPath.row]name];
                            newTask.editDesc = [[self->todoHigh objectAtIndex:indexPath.row]desc];
                            newTask.editDate = [[self->todoHigh objectAtIndex:indexPath.row]cdate];
                            newTask.editPriority = [[self->todoHigh objectAtIndex:indexPath.row]prio];
                            newTask.editStatus=[[self->todoHigh objectAtIndex:indexPath.row]status];
                            newTask.index = indexPath.row;
                            break;
                        case 1:
                            newTask.editName = [[self->todoMed objectAtIndex:indexPath.row]name];
                            newTask.editDesc = [[self->todoMed objectAtIndex:indexPath.row]desc];
                            newTask.editDate = [[self->todoMed objectAtIndex:indexPath.row]cdate];
                            newTask.editPriority = [[self->todoMed objectAtIndex:indexPath.row]prio];
                            newTask.editStatus=[[self->todoMed objectAtIndex:indexPath.row]status];
                            newTask.index = indexPath.row;
                            break;
                        case 2:
                            newTask.editName = [[self->todoLow objectAtIndex:indexPath.row]name];
                            newTask.editDesc = [[self->todoLow objectAtIndex:indexPath.row]desc];
                            newTask.editDate = [[self->todoLow objectAtIndex:indexPath.row]cdate];
                            newTask.editPriority = [[self->todoLow objectAtIndex:indexPath.row]prio];
                            newTask.editStatus=[[self->todoLow objectAtIndex:indexPath.row]status];
                            newTask.index = indexPath.row;
                            break;
                        default:
                            break;
                    }
                }else if (self->screenStatus==1){
                    // newTask.key='2';                   // edit from progress
                    switch (indexPath.section) {
                        case 0:
                            newTask.editName = [[self->progressH objectAtIndex:indexPath.row]name];
                            newTask.editDesc = [[self->progressH objectAtIndex:indexPath.row]desc];
                            newTask.editDate = [[self->progressH objectAtIndex:indexPath.row]cdate];
                            newTask.editPriority = [[self->progressH objectAtIndex:indexPath.row]prio];
                            newTask.editStatus=[[self->progressH objectAtIndex:indexPath.row]status];
                            newTask.index = indexPath.row;
                            break;
                        case 1:
                            newTask.editName = [[self->progressM objectAtIndex:indexPath.row]name];
                            newTask.editDesc = [[self->progressM objectAtIndex:indexPath.row]desc];
                            newTask.editDate = [[self->progressM objectAtIndex:indexPath.row]cdate];
                            newTask.editPriority = [[self->progressM objectAtIndex:indexPath.row]prio];
                            newTask.editStatus=[[self->progressM objectAtIndex:indexPath.row]status];
                            newTask.index = indexPath.row;
                            break;
                        case 2:
                            newTask.editName = [[self->progressL objectAtIndex:indexPath.row]name];
                            newTask.editDesc = [[self->progressL objectAtIndex:indexPath.row]desc];
                            newTask.editDate = [[self->progressL objectAtIndex:indexPath.row]cdate];
                            newTask.editPriority = [[self->progressL objectAtIndex:indexPath.row]prio];
                            newTask.editStatus=[[self->progressL objectAtIndex:indexPath.row]status];
                            newTask.index = indexPath.row;
                            break;
                        default:
                            break;
                    }
                }
                
                [newTask setEditTaskProtocol:self];
                [self.navigationController pushViewController:newTask animated:YES];
                
            }];
            
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
            [alert addAction:edit];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:NULL];
        }];
        
        //-------------------------------------------------------------------------------------------------
        UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"DELETE TASK!!" message:@"Are You Sure to delete task?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:NULL];
            [alert addAction:cancel];
            
            UIAlertAction *delete =[UIAlertAction actionWithTitle:@"delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self->screenStatus==0) {
                    switch (indexPath.section) {
                        case 0:
                            [self->todoHigh removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        case 1:
                            [self->todoMed removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        case 2:
                            [self->todoLow removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        default:
                            break;
                    }
                    if (self->todoHigh.count==0 && self->todoMed.count==0 && self->todoLow.count==0) {
                        [self->_tableTodo setHidden:YES];
                        [self->_backGround setHidden:NO];
                    }
                    [self setArrayInUserDefault:self->todoHigh withKey:@"todoHigh"];
                    [self setArrayInUserDefault:self->todoMed withKey:@"todoMed"];
                    [self setArrayInUserDefault:self->todoLow withKey:@"todoLow"];
                    
                }else if(self->screenStatus==1){
                    switch (indexPath.section) {
                        case 0:
                            [self->progressH removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        case 1:
                            [self->progressM removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        case 2:
                            [self->progressL removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        default:
                            break;
                    }
                    
                    if (self->progressH.count==0 && self->progressM.count==0 && self->progressL.count==0) {
                        [self->_tableTodo setHidden:YES];
                        [self->_backGround setHidden:NO];
                    }
                    [self setArrayInUserDefault:self->progressH withKey:@"progressH"];
                    [self setArrayInUserDefault:self->progressM withKey:@"progressM"];
                    [self setArrayInUserDefault:self->progressL withKey:@"progressL"];
                }else if(self->screenStatus==2){
                    switch (indexPath.section) {
                        case 0:
                            [self->doneH removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        case 1:
                            [self->doneM removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        case 2:
                            [self->doneL removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            break;
                        default:
                            break;
                    }
                    if (self->doneH.count==0 && self->doneM.count==0 && self->doneL.count==0) {
                        [self->_tableTodo setHidden:YES];
                        [self->_backGround setHidden:NO];
                    }
                    [self setArrayInUserDefault:self->doneH withKey:@"doneH"];
                    [self setArrayInUserDefault:self->doneM withKey:@"doneM"];
                    [self setArrayInUserDefault:self->doneL withKey:@"doneL"];
                }
//                else{
//                    [self->allListArray removeObjectAtIndex:indexPath.row];
//                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//                    if (self->allListArray.count==0 ) {
//                        [self->_tableTodo setHidden:YES];
//                        [self->_backGround setHidden:NO];
//                    }
//                }
                
                [self.tableTodo reloadData];
            }];
            [alert addAction: delete];
            [self presentViewController:alert animated:YES completion:NULL];
        }];
        
        edit.image  = [UIImage systemImageNamed:@"square.and.pencil"];
        edit.backgroundColor=[UIColor systemYellowColor];
        delete.image  = [UIImage systemImageNamed:@"trash"];
        delete.backgroundColor = [UIColor redColor];
        
        UISwipeActionsConfiguration *actionsEditAndDelete = [UISwipeActionsConfiguration configurationWithActions:[[NSArray alloc] initWithObjects:delete,edit, nil]];
        
        UISwipeActionsConfiguration *actionDelete = [UISwipeActionsConfiguration configurationWithActions:[[NSArray alloc] initWithObjects:delete, nil]];
        
        if (screenStatus==0 || screenStatus==1) {
            return actionsEditAndDelete;
        }else if(screenStatus==2){
            return actionDelete;
        }else{
            return 0;
        }
    }
    return 0;
}




- (IBAction)TOdo:(id)sender {
    [_titleLabelOutlet setHidden:false];
    _titleLabelOutlet.text=@"To Do List";
     [_searchBar setHidden:true];
    _progressItemOutlet.tintColor = UIColor.systemYellowColor;
    _allListOutlet.tintColor = UIColor.systemYellowColor;
    _todoItemOutlet.tintColor = UIColor.redColor;
    _doneItemOutlet.tintColor = UIColor.systemYellowColor;
    screenStatus = 0;
    if (todoHigh.count>0 || todoMed.count>0 || todoLow.count>0) {
        [_tableTodo setHidden:NO];
        [_backGround setHidden:YES];
    }else{
        [_tableTodo setHidden:YES];
        [_backGround setHidden:NO];
    }
    [self.tableTodo reloadData];
}

- (IBAction)progress:(id)sender {
    [_titleLabelOutlet setHidden:false];
    _titleLabelOutlet.text=@"Progress List";
     [_searchBar setHidden:true];
    _progressItemOutlet.tintColor = UIColor.redColor;
    _allListOutlet.tintColor = UIColor.systemYellowColor;
    _todoItemOutlet.tintColor = UIColor.systemYellowColor;
    _doneItemOutlet.tintColor = UIColor.systemYellowColor;
    screenStatus = 1;
    if (progressH.count>0 || progressM.count>0 || progressL.count>0) {
        [_tableTodo setHidden:NO];
        [_backGround setHidden:YES];
    }else{
        [_tableTodo setHidden:YES];
        [_backGround setHidden:NO];
    }
    [self.tableTodo reloadData];
    
}

- (IBAction)done:(id)sender {
    [_titleLabelOutlet setHidden:false];
    _titleLabelOutlet.text=@"Done List";
    [_searchBar setHidden:true];
    _allListOutlet.tintColor = UIColor.systemYellowColor;
    _progressItemOutlet.tintColor = UIColor.systemYellowColor;
    _todoItemOutlet.tintColor = UIColor.systemYellowColor;
    _doneItemOutlet.tintColor = UIColor.redColor;
    screenStatus = 2;
    if (doneH.count>0 || doneM.count>0 || doneL.count>0) {
        [_tableTodo setHidden:NO];
        [_backGround setHidden:YES];
    }else{
        [_tableTodo setHidden:YES];
        [_backGround setHidden:NO];
    }
    [self.tableTodo reloadData];
}

- (IBAction)allList:(id)sender {
    [_titleLabelOutlet setHidden:true];
    [_searchBar setHidden:false];
    _allListOutlet.tintColor = UIColor.redColor;
    _progressItemOutlet.tintColor = UIColor.systemYellowColor;
    _todoItemOutlet.tintColor = UIColor.systemYellowColor;
    _doneItemOutlet.tintColor = UIColor.systemYellowColor;
    screenStatus = 3;
    
    if ([allListArray count] > 0) {
        [allListArray removeAllObjects];
    }
    [allListArray addObjectsFromArray:todoHigh];
    [allListArray addObjectsFromArray:todoMed];
    [allListArray addObjectsFromArray:todoLow];
    [allListArray addObjectsFromArray:progressH];
    [allListArray addObjectsFromArray:progressM];
    [allListArray addObjectsFromArray:progressL];
    [allListArray addObjectsFromArray:doneH];
    [allListArray addObjectsFromArray:doneM];
    [allListArray addObjectsFromArray:doneL];
    
    if (allListArray.count>0) {
        [_tableTodo setHidden:NO];
        [_backGround setHidden:YES];
    }else{
        [_tableTodo setHidden:YES];
        [_backGround setHidden:NO];
    }
    [self.tableTodo reloadData];
}

@end

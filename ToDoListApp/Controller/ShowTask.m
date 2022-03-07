//
//  ShowTask.m
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import "ShowTask.h"
#import "Task.h"
#import "ViewController.h"

@interface ShowTask ()
@property (weak, nonatomic) IBOutlet UILabel *taskN;
@property (weak, nonatomic) IBOutlet UITextView *taskD;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation ShowTask

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskN.text=_showName;
    _taskD.text=_showDesc;
    _dateLabel.text= _showDate;
    _statusLabel.text=_showStatus;
}


- (IBAction)edite:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Are You Sure to edite task?" message:@"Insert new data" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:NULL];
    [alert addAction:cancel];
    
    UIAlertAction *save=[UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray * textfields = alert.textFields;
        UITextField *title = textfields[0];
        UITextField *desc = textfields[1];
        UITextField *date = textfields[2];
        //NSLog(@"%@:%@",setTitle.text,passwordfiled.text);
        [self.taskN setText:title.text];
        [self.taskD setText:desc.text];
        [self.dateLabel setText:date.text];
        
        Task *task = [Task new];
        task.name = title.text;
        task.cdate = date.text;
        task.desc =desc.text;
        
        unichar firstChar = [[self.showPriority lowercaseString] characterAtIndex:0];
        if (firstChar == 'h') {
           [self.showH replaceObjectAtIndex :self.index withObject:task];
        }
        else if (firstChar == 'm'){
            [self.showM replaceObjectAtIndex :self.index withObject:task];
        }
        else{
            [self.showL replaceObjectAtIndex :self.index withObject:task];
        }
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Task Name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter Description";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Enter new date";
    }];
    [alert addAction:save];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


@end

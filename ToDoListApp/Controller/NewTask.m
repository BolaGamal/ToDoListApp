//
//  NewTask.m
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import "NewTask.h"
#import "Task.h"
#import <UIKit/UIKit.h>



@interface NewTask () 
@property (weak, nonatomic) IBOutlet UITextField *taskName;
@property (weak, nonatomic) IBOutlet UITextView *taskDesc;
@property (weak, nonatomic) IBOutlet UITextField *taskDate;
@property (weak, nonatomic) IBOutlet UILabel *prioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *statusPicker;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIButton *nextB;
@property (weak, nonatomic) IBOutlet UIButton *backB;



@end

@implementation NewTask{
    NSDateFormatter *dateFormatter;
    NSArray *statusArr;
    NSArray *arr;
    int i;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    arr = @[@"High",@"Med",@"Low"];
    [_prioLabel setText: arr[i]];
    
    _statusPicker.dataSource=self;
    _statusPicker.delegate=self;
    
    
    if (_key == '1') {          //from edit
        [_statusPicker setHidden:false];
        [_labelStatus setHidden:false];
        [_nextB setHidden:true];
        [_backB setHidden:true];
        
        if ([_editStatus isEqualToString:@"PROGRESS"]) {
            statusArr = @[@"PROGRESS",@"DONE"];
        }else{
            statusArr = @[@"TODO",@"PROGRESS"];
        }
        _taskName.text=_editName;
        _taskDate.text=_editDate;
        _taskDesc.text=_editDesc;
        _prioLabel.text=_editPriority;
        
       // NSLog(@"%@",_taskDate.text);
       
        
    }else{
                        //from add new task
        [_statusPicker setHidden:true];
        [_labelStatus setHidden:true];
        
        dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        [_taskDate setText:[dateFormatter stringFromDate:[NSDate date]]];
    }

    
    

}


- (IBAction)save:(id)sender {
    Task *task;
    task = [Task new];
    task.name =_taskName.text;
    task.desc =_taskDesc.text;
    task.cdate =_taskDate.text;
    task.prio = _prioLabel.text;
    
    
    if (_key=='0') { //gay mn add task
        if (_taskName.text.length >0) {
            task.status = @"TO DO";
            [self.taskProtocol setTask:task withKey:'0'];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else { // gay mn edit 
        if (_taskName.text.length >0) {
            task.status = statusArr[[_statusPicker selectedRowInComponent:0]];
            [self.editTaskProtocol editTask:task index:_index];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
   
    
}





- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return statusArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return statusArr[row];
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
  //  NSDictionary *attributes = [NSDictionary dictionaryWithObject:UIColor.systemYellowColor forKey:NSFontAttributeName];
    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20.0],
        NSForegroundColorAttributeName : [UIColor systemYellowColor]
    };

    NSAttributedString *title = [[NSAttributedString alloc] initWithString:statusArr[row] attributes: attributes];
    return title;
}





- (IBAction)choosePriority:(id)sender {
    if ([sender tag] == 0) {
        if (i < arr.count-1) i++;
        else i=0;
    }
    else
    {
        if (i>0) i--;
        else i=2;
    }
     [_prioLabel setText: arr[i]];
}


- (IBAction)attach:(id)sender { [self showPhotoAlert]; }
-(void) showPhotoAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera,*photos,*cancel;
 
    camera =[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhoto:UIImagePickerControllerSourceTypeCamera];
    }];
    
    photos =[UIAlertAction actionWithTitle:@"Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    cancel =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    
    [alert addAction:camera];
    [alert addAction:photos];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:NULL];
}
-(void)getPhoto:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = type;
    picker.allowsEditing = NO;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    // 1 - Get media type
    UIImage *imgPicked = info[UIImagePickerControllerOriginalImage];
    // 2 - Dismiss image picker
    [self dismissViewControllerAnimated:true completion:nil];
    
    _imagePicker.image = imgPicked;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end

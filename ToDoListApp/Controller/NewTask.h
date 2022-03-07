//
//  NewTask.h
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taskProtocol.h"
#import "Task.h"



NS_ASSUME_NONNULL_BEGIN

@interface NewTask : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource>

@property id <taskProtocol> taskProtocol;
@property char key;   //to check where you are coming from (edite) or (add new task)
@property NSString *editName, *editDesc, *editDate, *editPriority, *editStatus;
@property NSMutableArray *editH, *editM, *editL;

//@property Task *task;
@property NSInteger index;
@property id <taskProtocol> editTaskProtocol;

@end

NS_ASSUME_NONNULL_END

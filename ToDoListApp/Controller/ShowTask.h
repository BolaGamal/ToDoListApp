//
//  ShowTask.h
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taskProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShowTask : UIViewController 

@property NSString *showName, *showDesc, *showDate, *showPriority, *showStatus;
@property NSMutableArray *showH, *showM, *showL;
@property NSInteger index;




@end

NS_ASSUME_NONNULL_END

//
//  taskProtocol.h
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@protocol taskProtocol <NSObject>

-(void) setTask :(Task*)task withKey:(char)key;

@optional
-(void) editTask :(Task*)task index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

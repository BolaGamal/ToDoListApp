//
//  Task.h
//  ToDoListApp
//
//  Created by Pola on 1/28/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding,NSSecureCoding>

@property NSString *name, *desc, *cdate, *prio, *status;


@property (class, readonly) BOOL supportsSecureCoding;

-(void)encodeWithCoder:(NSCoder *)encoder;

-(id)initWithCoder:(NSCoder *)decoder;

@end

NS_ASSUME_NONNULL_END

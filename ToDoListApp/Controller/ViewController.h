//
//  ViewController.h
//  ToDoListApp
//
//  Created by Pola on 1/27/22.
//  Copyright © 2022 Pola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "taskProtocol.h"

@interface ViewController : UIViewController <taskProtocol,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>


@end


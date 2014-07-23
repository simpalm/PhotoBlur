//
//  GPViewController.h
//  DemoBlur
//
//  Created by Deepak on 2/13/14.
//  Copyright (c) 2014 SimPalm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataHolder.h"

@interface GPViewController : UIViewController
{
    NSMutableArray *arrBlurImageArray;
}

@property (strong, nonatomic)  IBOutlet UIImageView *imgviewMain;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;
- (IBAction) sliderChanged:(id)sender;


@end

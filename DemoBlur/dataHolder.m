//
//  dataHolder.m
//  DemoBlur
//
//  Created by Mani Agarwal on 14/02/14.
//  Copyright (c) 2014 SimPalm. All rights reserved.
//

#import "dataHolder.h"

@implementation dataHolder

@synthesize blurImage;
@synthesize frameOfImage;

- (id)init
{
    if(self = [super init])
    {
        self.blurImage = nil;
        self.frameOfImage = CGRectMake(0, 0, 0, 0);
    }
    return self;
}



@end

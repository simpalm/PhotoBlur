//
//  dataHolder.h
//  DemoBlur
//
//  Created by Mani Agarwal on 14/02/14.
//  Copyright (c) 2014 SimPalm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataHolder : NSObject
{
    UIImage *blurImage;
    CGRect frameOfImage;
}

@property (nonatomic, retain)UIImage *blurImage;
@property (nonatomic, assign)CGRect frameOfImage;

@end

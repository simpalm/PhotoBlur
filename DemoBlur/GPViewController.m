//
//  GPViewController.m
//  DemoBlur
//
//  Created by Deepak on 2/13/14.
//  Copyright (c) 2014 SimPalm. All rights reserved.
//

#import "GPViewController.h"
#import "UIImage+StackBlur.h"

@interface GPViewController (){
    
   }

@end

@implementation GPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrBlurImageArray = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonPressed:(id)sender
{
    [self savePictureToLibrary];
}

- (IBAction)resetButtonPressed:(id)sender
{
    self.imgviewMain.image = [UIImage imageNamed:@"img.png"];
    [arrBlurImageArray removeAllObjects];
}

- (IBAction) sliderChanged:(UISlider *)sender
{
    [self increaseBlurIntensity:sender.value];
}

- (void)increaseBlurIntensity:(NSUInteger)inradius
{
    for(int i=0;i<[arrBlurImageArray count]; i++)
    {
        dataHolder *Data = [arrBlurImageArray objectAtIndex:i];
        UIImage *image =[Data.blurImage stackBlur:inradius];
        self.imgviewMain.image = [self addImageToImage:self.imgviewMain.image withImage2:image andRect:Data.frameOfImage];
        
        

    }
}

-(void)savePictureToLibrary
{
    UIImage *img = [self.imgviewMain image];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSString *str = @"Saved!!!";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved." message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
    
}
#pragma mark - Touch Methods

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UIImage *croppedImg = nil;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.imgviewMain];
    
    double ratioW=self.imgviewMain.image.size.width/self.imgviewMain.frame.size.width ;
    
    double ratioH=self.imgviewMain.image.size.height/self.imgviewMain.frame.size.height;
    
    currentPoint.x *= ratioW;
    currentPoint.y *= ratioH;
    
    double circleSizeW = 30 * ratioW;
    double circleSizeH = 30 * ratioH;
    
    
    currentPoint.x = (currentPoint.x - circleSizeW/2<0)? 0 : currentPoint.x - circleSizeW/2;
    currentPoint.y = (currentPoint.y - circleSizeH/2<0)? 0 : currentPoint.y - circleSizeH/2;
    
    
    CGRect cropRect = CGRectMake(currentPoint.x , currentPoint.y,   circleSizeW,  circleSizeH);
    
    NSLog(@"x %0.0f, y %0.0f, width %0.0f, height %0.0f", cropRect.origin.x, cropRect.origin.y,   cropRect.size.width,  cropRect.size.height );
    
    croppedImg = [self croppIngimageByImageName:self.imgviewMain.image toRect:cropRect];
    
    // Blur Effect
    croppedImg = [croppedImg imageWithGaussianBlur9];
    
    // Contrast Effect
    // croppedImg = [croppedImg imageWithContrast:50];
    
    
    
    croppedImg = [self roundedRectImageFromImage:croppedImg withRadious:4];
    dataHolder *data = [[dataHolder alloc] init];
    data.blurImage = croppedImg;
    data.frameOfImage = cropRect;
    
    [arrBlurImageArray addObject:data];
    
    self.imgviewMain.image = [self addImageToImage:self.imgviewMain.image withImage2:croppedImg andRect:cropRect];
}

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
    
    
}

- (UIImage *) addImageToImage:(UIImage *)img withImage2:(UIImage *)img2 andRect:(CGRect)cropRect{
    
    CGSize size = CGSizeMake( self.imgviewMain.image.size.width,  self.imgviewMain.image.size.height);
    UIGraphicsBeginImageContext(size);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [img drawAtPoint:pointImg1];
    
    CGPoint pointImg2 = cropRect.origin;
    [img2 drawAtPoint: pointImg2];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)roundedRectImageFromImage:(UIImage *)image withRadious:(CGFloat)radious {
    
    if(radious == 0.0f)
        return image;
    
    if( image != nil) {
        
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        CGRect rect = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        const CGFloat scale = window.screen.scale;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextBeginPath(context);
        CGContextSaveGState(context);
        CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM (context, radious, radious);
        
        CGFloat rectWidth = CGRectGetWidth (rect)/radious;
        CGFloat rectHeight = CGRectGetHeight (rect)/radious;
        
        CGContextMoveToPoint(context, rectWidth, rectHeight/2.0f);
        CGContextAddArcToPoint(context, rectWidth, rectHeight, rectWidth/2.0f, rectHeight, radious);
        CGContextAddArcToPoint(context, 0.0f, rectHeight, 0.0f, rectHeight/2.0f, radious);
        CGContextAddArcToPoint(context, 0.0f, 0.0f, rectWidth/2.0f, 0.0f, radious);
        CGContextAddArcToPoint(context, rectWidth, 0.0f, rectWidth, rectHeight/2.0f, radious);
        CGContextRestoreGState(context);
        CGContextClosePath(context);
        CGContextClip(context);
        
        [image drawInRect:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    } 
    return nil;
}
@end

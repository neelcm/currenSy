//
//  CustomShapes.m
//  divvy
//
//  Created by Neel Mouleeswaran on 1/18/14.
//
//

#import "CustomShapes.h"

@implementation CustomShapes

+(UIView *)createCircleWithImage:(UIImage *)image {
    
    UIView *rootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    
    UIImage *circle_mask = [UIImage imageNamed:@"Circle-mask.png"];
    UIImage *red_ring = [UIImage imageNamed:@"Circle-ring-red.png"];
    UIImage *green_ring = [UIImage imageNamed:@"Circle-ring-green.png"];
    
    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = circle_mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                                CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 75, 75);
    button.center = CGPointMake(80, 80);
    
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [button setImage:maskedImage forState:UIControlStateNormal];
    
    //[button setBackgroundImage:[self imageByApplyingAlpha:1.0 withImage:green_ring] forState:UIControlStateNormal];
    
    UIView *greenView = [[UIImageView alloc] initWithImage:green_ring];
    greenView.frame = CGRectMake(0, 0, 75, 75);
    greenView.center = CGPointMake(80, 80);
    greenView.alpha = 0;
    
    UIView *redView = [[UIImageView alloc]initWithImage:red_ring];
    redView.frame = CGRectMake(0,0,75,75);
    redView.center = CGPointMake(80, 80);
    redView.alpha = 0;
    
    [rootView addSubview:greenView];
    [rootView addSubview:redView];
    [rootView addSubview:button];

    return rootView;
}

+ (UIImage *)imageByApplyingAlpha: (CGFloat) alpha withImage: (UIImage *)image {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

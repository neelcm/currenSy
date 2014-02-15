//
//  CustomShapes.h
//  divvy
//
//  Created by Neel Mouleeswaran on 1/18/14.
//
//

#import <Foundation/Foundation.h>

@interface CustomShapes : NSObject

// Creates a circle with the image in a circle mask, subview layers include red/green rings with alpha set to 0
+(UIButton *)createCircleWithImage: (UIImage *)image;
+ (UIImage *)imageByApplyingAlpha: (CGFloat) alpha withImage: (UIImage *)image;
+ (UIImage *) imageWithView:(UIView *)view;

@end

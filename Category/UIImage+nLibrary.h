//
//  UIImage+nLibrary.h
//  nLibrary
//
//  Created by nickcheng on 12-11-15.
//  Copyright (c) 2012年 nx. All rights reserved.
//

@interface UIImage (nLibrary)

+ (UIImage *)imageNamedAll:(NSString *)imageName;
+ (NSString *)standardiseFileName:(NSString *)name;

- (UIImage*)resizedImageToSize:(CGSize)dstSize;
- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

- (UIImage *)fixOrientation;

@end

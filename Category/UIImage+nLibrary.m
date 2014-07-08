//
//  UIImage+nLibrary.m
//  nLibrary
//
//  Created by nickcheng on 12-11-15.
//  Copyright (c) 2012年 nx. All rights reserved.
//

#import "UIImage+nLibrary.h"
#import "UIScreen+SAMAdditions.h"

@implementation UIImage (nLibrary)

+ (UIImage *)imageNamedAll:(NSString *)imageName {
  
  NSString *name = imageName;
  
  if ([[UIScreen mainScreen] sam_isGiraffe]) {
    name = [NSString stringWithFormat:@"%@-568h", name];
  }
  
  return [self imageNamed:name];
  
}

+ (NSString *)standardiseFileName:(NSString *)name {
  //
  NSMutableString *result = [name mutableCopy];
  NSString *ext = @"";
  
  // If "@" is contained in name, just return it. 
  NSRange e = [result rangeOfString:@"@" options:NSLiteralSearch];
  if (e.location != NSNotFound) {
    return result;
  }
  
  //
  NSRange dot = [result rangeOfString:@"." options:NSLiteralSearch];
  if (dot.location != NSNotFound) {
    ext = [result substringFromIndex:dot.location];
    [result deleteCharactersInRange:[result rangeOfString:ext]];
  }
    
  //
  if ([[UIScreen mainScreen] sam_isGiraffe]) {
      [result appendString:@"-568h@2x"];
  } else if ([[UIScreen mainScreen] sam_isRetina]) {
    [result appendString:@"@2x"];
  }
  
  //
  [result appendString:ext];
  
  return result;
}

-(UIImage*)resizedImageToSize:(CGSize)dstSize {
  CGImageRef imgRef = self.CGImage;
  // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
  CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
  
  /* Don't resize if we already meet the required destination size. */
  if (CGSizeEqualToSize(srcSize, dstSize)) {
    return self;
  }
  
  CGFloat scaleRatio = dstSize.width / srcSize.width;
  UIImageOrientation orient = self.imageOrientation;
  CGAffineTransform transform = CGAffineTransformIdentity;
  switch(orient) {
      
    case UIImageOrientationUp: //EXIF = 1
      transform = CGAffineTransformIdentity;
      break;
      
    case UIImageOrientationUpMirrored: //EXIF = 2
      transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;
      
    case UIImageOrientationDown: //EXIF = 3
      transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
      
    case UIImageOrientationDownMirrored: //EXIF = 4
      transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;
      
    case UIImageOrientationLeftMirrored: //EXIF = 5
      dstSize = CGSizeMake(dstSize.height, dstSize.width);
      transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
      break;
      
    case UIImageOrientationLeft: //EXIF = 6
      dstSize = CGSizeMake(dstSize.height, dstSize.width);
      transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
      break;
      
    case UIImageOrientationRightMirrored: //EXIF = 7
      dstSize = CGSizeMake(dstSize.height, dstSize.width);
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    case UIImageOrientationRight: //EXIF = 8
      dstSize = CGSizeMake(dstSize.height, dstSize.width);
      transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI_2);
      break;
      
    default:
      [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
      
  }
  
  /////////////////////////////////////////////////////////////////////////////
  // The actual resize: draw the image on a new context, applying a transform matrix
  UIGraphicsBeginImageContextWithOptions(dstSize, NO, self.scale);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -srcSize.height, 0);
  } else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -srcSize.height);
  }
  
  CGContextConcatCTM(context, transform);
  
  // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
  UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resizedImage;
}



/////////////////////////////////////////////////////////////////////////////



-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale {
  // get the image size (independant of imageOrientation)
  CGImageRef imgRef = self.CGImage;
  CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which depends on the imageOrientation)!
  
  // adjust boundingSize to make it independant on imageOrientation too for farther computations
  UIImageOrientation orient = self.imageOrientation;
  switch (orient) {
    case UIImageOrientationLeft:
    case UIImageOrientationRight:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
      boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
      break;
    default:
      // NOP
      break;
  }
  
  // Compute the target CGRect in order to keep aspect-ratio
  CGSize dstSize;
  
  if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
    //NSLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
    dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
  } else {
    CGFloat wRatio = boundingSize.width / srcSize.width;
    CGFloat hRatio = boundingSize.height / srcSize.height;
    
    if (wRatio < hRatio) {
      //NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
      dstSize = CGSizeMake(boundingSize.width, floorf(srcSize.height * wRatio));
    } else {
      //NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
      dstSize = CGSizeMake(floorf(srcSize.width * hRatio), boundingSize.height);
    }
  }
  
  return [self resizedImageToSize:dstSize];
}

@end

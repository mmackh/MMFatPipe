//
//  MMFatPipe.m
//  ListDocs
//
//  Created by Maximilian Mackh on 7/28/12.
//  Copyright (c) 2012 Maximilian Mackh. All rights reserved.
//

#import "MMFatPipe.h"


@implementation MMFatPipe

- (void)sendImagewithToken:(NSString *)token andImageData:(id)imageData andTitle:(NSString *)title andNote:(NSString *)note  withOptimization:(NSString *)wantsOptimized
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        
        // Store in Cache
        [UIImageJPEGRepresentation(imageData, 1.0) writeToFile:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"tmp_up.ipdf"] atomically:NO];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadStarted" object:nil];
        
        UIImage *instapdfdoc = [self imageWithImage:imageData scaledToSizeWithSameAspectRatio:CGSizeMake(1296,968)];

        
        NSString *urlString = [NSString stringWithFormat:@"https://upstream.me/post?token=%@&title=%@&note=%@&pages=1&action=upload&optimized=%@",
                               token,
                               [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [note stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               wantsOptimized];
        
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------46782733362863682664648476844";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imageone\"; filename=\"imageone.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(instapdfdoc, 0.6)]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response,
            NSData *data,
            NSError *error)
         {
             if ([data length] > 0 && error == nil)
             {
                 response = nil;
                 data = nil;
                 error = nil;
                 
                 [[NSUserDefaults standardUserDefaults]
                  setBool:NO forKey:@"lastUploadFailed"];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadFinished" object:nil];
                 [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"tmp_up.ipdf"] error:nil];

             }
             else if ([data length] == 0 && error == nil)
             {
                 NSLog(@"Nothing was uploaded.");
             }
             else if (error != nil){
                 
                 // Connection is Offline - store the image and upload
                 
                 [[NSUserDefaults standardUserDefaults]
                  setBool:YES forKey:@"lastUploadFailed"];
                 [[NSUserDefaults standardUserDefaults]
                  setInteger:1 forKey:@"numberOfPages"];
                 [[NSUserDefaults standardUserDefaults]
                  setObject:title forKey:@"lastTitle"];
                 [[NSUserDefaults standardUserDefaults]
                  setObject:note forKey:@"lastNote"];
                 
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadFailed" object:nil];
             }
             
         }];
        
    });
    
}

- (void)sendImagewithToken:(NSString *)token andImageData:(id)imageData withPageTwo:(id)imageDataTwo andTitle:(NSString *)title andNote:(NSString *)note withOptimization:(NSString *)wantsOptimized
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        
        // Store in Cache
        [UIImageJPEGRepresentation(imageData, 1.0) writeToFile:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"tmp_up.ipdf"] atomically:NO];
        [UIImageJPEGRepresentation(imageDataTwo, 1.0) writeToFile:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"tmp_up_2.ipdf"] atomically:NO];
        // Store everything into the App's .plist
        
        
        
        
        
        
        // Resize the image before dismissing the Camera.
        
        // A4 Aspect Ratio : 210:297 -> 297 x 210
        // iPhone 3GS : 2048 × 1536
        // iPhone 4 : 2592 × 1936
        // iPhone 4s : 3264 x 2448
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadStarted" object:nil];
        
        UIImage *instapdfdoc = [self imageWithImage:imageData scaledToSizeWithSameAspectRatio:CGSizeMake(1296,968)];
        UIImage *instapdfdoctwo = [self imageWithImage:imageDataTwo scaledToSizeWithSameAspectRatio:CGSizeMake(1296,968)];
        
        NSString *urlString = [NSString stringWithFormat:@"https://upstream.me/post?token=%@&title=%@&note=%@&pages=2&action=upload&optimized=%@",
                               token,
                               [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               [note stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                               wantsOptimized];
        
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------46782733362863682664648476844";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        //Page 1
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imageone\"; filename=\"imageone.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(instapdfdoc, 0.6)]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //End Page 1
        
        //Page 2
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imagetwo\"; filename=\"imagetwo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(instapdfdoctwo, 0.6)]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //End Page 2
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [request setHTTPBody:body];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response,
                                                                                                                   NSData *data,
                                                                                                                   NSError *error)
         {
             if ([data length] > 0 && error == nil)
             {
                 //NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                
                 response = nil;
                 data = nil;
                 error = nil;
                 
                 [[NSUserDefaults standardUserDefaults]
                  setBool:YES forKey:@"lastUploadFailed"];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadFinished" object:nil];
                 
                 [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"tmp_up.ipdf"] error:nil];
                 [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"tmp_up_2.ipdf"] error:nil];
                 
             }
             else if ([data length] == 0 && error == nil)
             {
                 NSLog(@"Nothing was uploaded.");
             }
             else if (error != nil){
                 // Connection is Offline - store the image and upload
                 
                 [[NSUserDefaults standardUserDefaults]
                  setBool:YES forKey:@"lastUploadFailed"];
                 [[NSUserDefaults standardUserDefaults]
                  setInteger:2 forKey:@"numberOfPages"];
                 [[NSUserDefaults standardUserDefaults]
                  setObject:title forKey:@"lastTitle"];
                 [[NSUserDefaults standardUserDefaults]
                  setObject:note forKey:@"lastNote"];
                 
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadFailed" object:nil];
             }
             
         }];
        
    });
    
}

- (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (width <= targetWidth || height <= targetHeight) {
        
        return sourceImage;
        
    } else {
	
        if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
            CGFloat widthFactor = targetWidth / height;
            CGFloat heightFactor = targetHeight / width;
            
            if ((sourceImage.imageOrientation == UIImageOrientationUp) || (sourceImage.imageOrientation == UIImageOrientationDown)) {
                widthFactor = targetWidth / width;
                heightFactor = targetHeight / height;
            }
            
            if (widthFactor > heightFactor) {
                scaleFactor = widthFactor; // scale to fit height
            } else {
                scaleFactor = heightFactor; // scale to fit width
            }
            
            scaledWidth  = width * scaleFactor;
            scaledHeight = height * scaleFactor;
            
            // center the image
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = 0;
            }
            else if (widthFactor < heightFactor) {
                thumbnailPoint.x = 0;
            }
        }
        
        CGImageRef imageRef = [sourceImage CGImage];
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
        
        if (bitmapInfo == kCGImageAlphaNone) {
            bitmapInfo = kCGImageAlphaNoneSkipLast;
        }
        
        CGContextRef bitmap;
        
        if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
            bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
            
        } else {
            bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
            
        }
        
        // In the right or left cases, we need to switch scaledWidth and scaledHeight,
        // and also the thumbnail point
        if (sourceImage.imageOrientation == UIImageOrientationLeft) {
            thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
            CGFloat oldScaledWidth = scaledWidth;
            scaledWidth = scaledHeight;
            scaledHeight = oldScaledWidth;
            
            CGContextRotateCTM (bitmap, 90.0/57.2958);
            CGContextTranslateCTM (bitmap, 0, -targetHeight);
            
        } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
            thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
            CGFloat oldScaledWidth = scaledWidth;
            scaledWidth = scaledHeight;
            scaledHeight = oldScaledWidth;
            
            CGContextRotateCTM (bitmap, -90./57.2958);
            CGContextTranslateCTM (bitmap, -targetWidth, 0);
            
        } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
            
        } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
            CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
            CGContextRotateCTM (bitmap, -180./57.2958);
        }
        
        CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
        CGImageRef ref = CGBitmapContextCreateImage(bitmap);
        UIImage* newImage = [UIImage imageWithCGImage:ref];
        
        CGContextRelease(bitmap);
        CGImageRelease(ref);
        
        return newImage;
    }
}

@end

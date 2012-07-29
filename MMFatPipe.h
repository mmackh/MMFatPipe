//
//  MMFatPipe.h
//  ListDocs
//
//  Created by Maximilian Mackh on 7/28/12.
//  Copyright (c) 2012 Maximilian Mackh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMFatPipe : NSObject

- (void)sendImagewithToken:(NSString *)token andImageData:(id)imageData andTitle:(NSString *)title andNote:(NSString *)note;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end

//
//  NSMutableURLRequest+PostFile.h
//  barrister
//
//  Created by 徐书传 on 16/9/1.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (PostFile)
+(instancetype)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andImageData:(NSData *)imageData;
@end

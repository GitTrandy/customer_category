//
//  NSString+Encode.m
//  circle_iphone
//
//  Created by trandy on 15/3/5.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (NSString_Encode)

- (NSString *)encodeString
{
//    NSString *newString = [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))) autorelease];
//    if (newString) {
//        return newString;
//    }
//    return @"";
    
    return self;
}

@end

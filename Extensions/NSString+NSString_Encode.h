//
//  NSString+NSString_Encode.h
//  My12306
//
//  Created by Lion User on 08/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Encode)

- (NSString *)encodeString:(NSStringEncoding)encoding;

+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
@end

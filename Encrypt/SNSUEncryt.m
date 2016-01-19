//
//  Encryt.m
//  beatmasterSNS
//
//  Created by jeff on 13-3-6.
//
//

#import "SNSUEncryt.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "MacroBMSns.h"
#import "GTMBase64.h"

@implementation SNSUEncryt

+ (NSString *)md5HashOnNSString:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    // In case of exception, ptr == nil.
    if (!ptr)
    {
        return @"";
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, strlen(ptr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)md5HashOnNSData:(NSData *)input{
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    // In case of exception, ptr == nil.
    if (input.length == 0)
    {
        return @"";
    }

    BMNSLog(@"md5HashOnNSData << %d", [input length]);
    CC_MD5([input bytes], [input length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// Add salt using (id)contentNeedEncode
// (id)contentNeedEncode: NSString or NSDictionary
+ (NSString *)encrypt:(NSString *)url withParams:(id)paramsInUrl postBody:(id)postData withCaptcha:(NSString *)theCaptcha andSaltKey:(NSString *)theSaltKey
{
    
    NSMutableString *sourceString = [[NSMutableString alloc] init];
    
    // +url
    //    [sourceString appendString:url];
    //    [sourceString appendString:@"?"];
    
    NSMutableDictionary *allInOne = [[NSMutableDictionary alloc] init];
    
    // +paramsInUrl dictionary
    if (paramsInUrl && [paramsInUrl isKindOfClass:[NSDictionary class]])
    {
        [allInOne addEntriesFromDictionary:paramsInUrl];
    }
    
    // +postData dictionary
    if (postData && [postData isKindOfClass:[NSDictionary class]])
    {
        [allInOne addEntriesFromDictionary:postData];
    }
    
    // +captcha
    if (theCaptcha)
    {
        allInOne[@"captcha"] = theCaptcha;
    }
    
    // Sort all keys by key
    NSArray *keyIndexArray = [[allInOne allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSInteger index = 0; index < [keyIndexArray count]; index++)
    {
        NSMutableString *arrayFormatStr = [NSMutableString string];
        
        id value_obj = allInOne[keyIndexArray[index]]; //[[allInOne allValues] objectAtIndex:index];
        
        // In case of array
        if ([(id)value_obj isKindOfClass:[NSArray class]])
        {
            for (NSInteger loop = 0 ; loop < [(NSArray *)value_obj count]; loop++)
            {
                [arrayFormatStr appendString:((NSArray *)value_obj)[loop]];
                
                if (loop < [(NSArray *)value_obj count] - 1)
                {
                    [arrayFormatStr appendString:@","];
                }
            }
            
            [sourceString appendFormat:@"%@=%@", keyIndexArray[index], arrayFormatStr];
        } else {
            
            // Others
            [sourceString appendFormat:@"%@=%@", keyIndexArray[index], value_obj];
        }
        
        if (index < [keyIndexArray count] - 1)
        {
            [sourceString appendString:@"&"];
        }
    }
    
    
    // +salt_key
    [sourceString appendString:theSaltKey];
    
    // Calculate md5.
    NSString *md5ResultOnString = [SNSUEncryt md5HashOnNSString:sourceString];
    
    [sourceString release];
    [allInOne release];
    
    // Finally, calculate sha1
    NSString *salted = [SNSUEncryt hmacsha1:md5ResultOnString key:theSaltKey];
    
    return salted;
}

+ (NSString *)getCurrentTS:(NSDate *)now
{
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    BMNSLog(@"timestamp: %d", (NSInteger)[now timeIntervalSince1970]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:(NSDateFormatterStyle)kCFDateFormatterFullStyle];
    [dateFormatter setDateStyle:(NSDateFormatterStyle)kCFDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    [dateFormatter setLocale:usLocale];
    
    [usLocale release];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStamp = [dateFormatter stringFromDate:now];
    [dateFormatter release];
    
    NSString *retTS = [NSString stringWithFormat:@"%@ GMT", timeStamp];
    
    BMNSLog(@"TS: %@", retTS);
    
    return retTS;
}

+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret
{
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
    NSString* gtm = [GTMBase64 stringByEncodingBytes:result length:CC_SHA1_DIGEST_LENGTH];

    BMNSLog(@"base64(gtm): %@", gtm);
    
    return gtm;
}

+ (NSString *)base64Encode:(NSData *)input
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([input bytes], [input length], result);
    
    NSString* gtm = [GTMBase64 stringByEncodingBytes:result length:CC_MD5_DIGEST_LENGTH];
    BMNSLog(@"base64(B): %@", gtm);

    
    return gtm;
}


+ (NSString *)encryptWithBlendedString:(NSString *)input blendWithSalt:(NSString *)saltKey andSecret:(NSString *)secretKey
{
    NSInteger iLoop = (input.length > saltKey.length) ? saltKey.length : input.length;
    NSMutableString *blended = [[[NSMutableString alloc] init] autorelease];
    
    for (NSInteger index = 0; index < iLoop; index++)
    {
        // + 1 char from salt key
        [blended appendString:[NSString stringWithFormat:@"%c", [saltKey characterAtIndex:index]]];
        
        // + 1 char from input key
        [blended appendString:[NSString stringWithFormat:@"%c", [input characterAtIndex:index]]];
    }
    
    if (iLoop == input.length)
    {
        [blended appendString:[saltKey substringFromIndex:iLoop]];
    } else {
        [blended appendString:[input substringFromIndex:iLoop]];
    }
    
    // Calc md5
    NSString *md5Result = [SNSUEncryt md5HashOnNSString:blended];
    
    // Calc sha1 with specified secret key
    NSString *encryptString = [SNSUEncryt hmacsha1:md5Result key:secretKey];
    
    return encryptString;
}


/*
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSUInteger dataLength = strlen([clearText UTF8String]);
    
    // NSString 对中文计算为1不是2byte 替换为上面CString
//    NSUInteger dataLength = [clearText length];
    
    int bufferLen = (dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    void *buffer = malloc(bufferLen * sizeof(char));
    if (nil == buffer)
    {
        return clearText;
    }
    memset(buffer, 0, bufferLen);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCBlockSizeDES,
                                          nil,
                                          [textData bytes],
                                          dataLength,
                                          buffer,
                                          bufferLen,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        SNSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [GTMBase64 stringByEncodingData:data];
    }
    else
    {
        SNSLog(@"DES加密失败");
    }
    
    free(buffer);
    
    return ciphertext;
}

/**
 DES解密
 */
+(NSString *) decryptUseDESTextForBase64Twice:(NSString *)plainText key:(NSString *)key
{
    NSData* textData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    return [self decryptUseDESData:textData key:key];
}

+(NSString *) decryptUseDESTextForBase64Once:(NSString *)plainText key:(NSString *)key
{
    return [self decryptUseDESData:[plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] key:key];
}

+(NSString *) decryptUseDESData:(NSData *)plainData key:(NSString *)key
{
    if (nil == plainData)
    {
        return nil;
    }
    
    NSString *cleartext = nil;
    NSData *textData = [GTMBase64 decodeData:plainData];
    NSUInteger dataLength = [textData length];
    
    int bufferLen = (dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    void *buffer = malloc(bufferLen * sizeof(char));
    if (nil == buffer)
    {
        return nil;
    }
    memset(buffer, 0, bufferLen);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCBlockSizeDES,
                                          nil,
                                          [textData bytes],
                                          dataLength,
                                          buffer,
                                          bufferLen,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        SNSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        //SNSLog(@"%@", cleartext);
    }
    else
    {
        SNSLog(@"DES解密失败");
    }
    
    free(buffer);
    
    return cleartext;
}

@end

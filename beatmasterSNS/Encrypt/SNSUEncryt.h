//
//  Encryt.h
//  beatmasterSNS
//
//  Created by jeff on 13-3-6.
//
//

#import <Foundation/Foundation.h>

#define kInternalSaltKey4PWD      @""
#define kInternalSecretKey4PWD    @""

#define kInternalSaltKey4Song     @""
#define kInternalSecretKey4Song   @""

#define kInternalSaltKey4EUI      @""
#define kInternalSecretKey4EUI    @""

#define kInternalSaltKey4EMusic   @""
#define kInternalSecretKey4EMusic @""
#define kMusicFileSecretKey       @""

#define kInternalSaltKey4ReceiptInfo    @""
#define kInternalSecretKey4ReceiptInfo  @""

// // 广告墙加钻石
#define kInternalSaltKey4FreeDiamond     @""
#define kInternalSecretKey4FreeDiamond   @""


#define kLuaFileSecretKey @""
#define kMacAddrSecretKey @""

@interface SNSUEncryt : NSObject


+ (NSString *)md5HashOnNSString:(NSString *)input;
+ (NSString *)md5HashOnNSData:(NSData *)input;
+ (NSString *)encrypt:(NSString *)url withParams:(id)paramsInUrl postBody:(id)postData withCaptcha:(NSString *)theCaptcha andSaltKey:(NSString *)theSaltKey;
+ (NSString *)getCurrentTS:(NSDate *)now;
+ (NSString *)hmacsha1:(NSString *)text key:(NSString *)secret;
+ (NSString *)base64Encode:(NSData *)input;

+ (NSString *)encryptWithBlendedString:(NSString *)input blendWithSalt:(NSString *)saltKey andSecret:(NSString *)secretKey;


/**
 DES加密
 */
+(NSString*) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 DES解密
 */
+(NSString *) decryptUseDESTextForBase64Twice:(NSString *)plainText key:(NSString *)key;
+(NSString *) decryptUseDESTextForBase64Once:(NSString *)plainText key:(NSString *)key;
+(NSString *) decryptUseDESData:(NSData *)plainData key:(NSString *)key;

@end

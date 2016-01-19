//
//  Encryt.h
//  beatmasterSNS
//
//  Created by jeff on 13-3-6.
//
//

#import <Foundation/Foundation.h>

#define kInternalSaltKey4PWD      @"EXCWHA3760NG9UK5CXH3WH18G"
#define kInternalSecretKey4PWD    @"NDkxNDY0NmUtZGJiZi00ZGIxLWExOTctMTE3ZjMzMjI5NGVl"

#define kInternalSaltKey4Song     @"5J18RUQ11Y0VHXXZHXNPFGCWH"
#define kInternalSecretKey4Song   @"MjFmOWNhOGYtMGE3NS00MDdhLTgzZDktZmM4MTVjZTdmNmUz"

#define kInternalSaltKey4EUI      @"DNVKGFGL9BPE7XGKAWP7GAHEO"
#define kInternalSecretKey4EUI    @"OTk2ODdlYzctZTQ4MC00N2E2LWIyNDctZTgzOTRjNmUzMzRh"

#define kInternalSaltKey4EMusic   @"B0C7XM1RQ0W7JKEXQYYIJRK8E"
#define kInternalSecretKey4EMusic @"ZGExZTJhOTAtODQ2OC00MWMxLTk3NWItNmUwOWM4M2MyZWFk"
#define kMusicFileSecretKey       @"MzFjYTQ3YmItODZjZS00MTk5LWI2MWQtNjk1YWMwMDhmYjgx"

#define kInternalSaltKey4ReceiptInfo    @"1UK0E3XPFCFX2OKGV6KM7ZFJ1"
#define kInternalSecretKey4ReceiptInfo  @"MzFjYTQ3YmItODZjZS00MTk5LWI2MWQtNjk1YWMwMDhmYjgx"

// // 广告墙加钻石
#define kInternalSaltKey4FreeDiamond     @"5J18RUQ11Y0VHXXZHXNPFGCWH"
#define kInternalSecretKey4FreeDiamond   @"MjFmOWNhOGYtMGE3NS00MDdhLTgzZDktZmM4MTVjZTdmNmUz"


#define kLuaFileSecretKey @"MzFjYTQ3YmItODZjZS00MTk5LWI2MWQtNjk1YWMwMDhmYjgx"
#define kMacAddrSecretKey @"MzFjYTQ3YmItODZjZS00MTk5LWI2MWQtNjk1YWMwMDhmYjgx"

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

//
//  UIImage+Replace_imageNamed.m
//  beatmasterSNS
//
//  Created by 周华 on 12-11-7.
//
//

#import "UIImage+Replace_imageNamed.h"

#define USE_UIIMAGEPOOL 1

@implementation UIImage (Replace_imageNamed)

+ (UIImage *)imageNamed_New:(NSString *)name
{
    if (nil == name || ![name hasSuffix:@".png"])
    {
        return nil;
    }
    
    UIImage *rtnImage = nil;
#if USE_UIIMAGEPOOL
    UIImagePool* uiImagePool = [UIImagePool instance];
    int suffixLen = ([name hasSuffix:@"@2x.png"] ? 7 : 4);
    NSString* imageKey = [name substringToIndex:(name.length - suffixLen)];
    rtnImage = [uiImagePool getImageByKey:imageKey];
    if (nil != rtnImage)
    {
        return rtnImage;
    }
#endif
    
    // 1. 直接查找，不管是否是Retina文件名
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    rtnImage = [UIImage imageWithContentsOfFile:fullPath];
    if (rtnImage)
    {
#if USE_UIIMAGEPOOL
        [uiImagePool addImageToPool:rtnImage byKey:imageKey];
#endif
        return rtnImage;
    }
    
    // 2. Retina文件名，但在非Retina上显示
    NSArray *fileComponents_2x = [name componentsSeparatedByString:@"@2x"];
    if ([fileComponents_2x count] == 2)
    {
        fullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", fileComponents_2x[0], fileComponents_2x[1]] ofType:nil];
        rtnImage = [UIImage imageWithContentsOfFile:fullPath];
#if USE_UIIMAGEPOOL
        [uiImagePool addImageToPool:rtnImage byKey:imageKey];
#endif
        if (rtnImage) {
            return rtnImage;
        }
    }

    
    // 3. 非Retina文件名，在Retina上显示
    NSArray *fileComponents_x  = [name componentsSeparatedByString:@"."];
    if ([fileComponents_x count] == 2)
    {
        fullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x.%@", fileComponents_x[0], fileComponents_x[1]] ofType:nil];
        rtnImage = [UIImage imageWithContentsOfFile:fullPath];
#if USE_UIIMAGEPOOL
        [uiImagePool addImageToPool:rtnImage byKey:imageKey];
#endif
        if (rtnImage) {
            return rtnImage;
        }
        
    }
    
    // 4. 仍然找不到图片 尝试全路径寻找
    if ((rtnImage = [self imageWithContentsOfFile_New:name]) != nil) {
        return rtnImage;
    }

    SNSLog(@"Cannot find file %@", name);
    
    return nil;
}

+ (BOOL)isRunningOnRetinaDisplay
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
        return YES;
    }
    
    return NO;
}

+ (UIImage *)imageWithContentsOfFile_New:(NSString *)path
{
    if (nil == path || (![path hasSuffix:@".png"] && ![path hasSuffix:@".jpeg"] && ![path hasSuffix:@"jpg"]))
    {
        return nil;
    }
    
    UIImage *rtnImage = nil;
    
#if USE_UIIMAGEPOOL
    UIImagePool* uiImagePool = [UIImagePool instance];
    int suffixLen = ([path hasSuffix:@"@2x.png"] ? 7 : 4);
    
    NSString* imageKey = [path substringToIndex:(path.length - suffixLen)];
    rtnImage = [uiImagePool getImageByKey:imageKey];
    if (nil != rtnImage)
    {
        return rtnImage;
    }
#endif
    
    rtnImage = [UIImage imageWithContentsOfFile:path];
    if (nil != rtnImage)
    {
#if USE_UIIMAGEPOOL
        [uiImagePool addImageToPool:rtnImage byKey:imageKey];
#endif
    }else
    {
        NSString *newPath = nil;
        if (![path hasSuffix:@"@2x.png"])
        {
            newPath = [path stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
        }
        else
        {
            newPath = [path stringByReplacingOccurrencesOfString:@"@2x.png" withString:@".png"];
        }
        rtnImage = [UIImage imageWithContentsOfFile:newPath];
#if USE_UIIMAGEPOOL
        [uiImagePool addImageToPool:rtnImage byKey:imageKey];
#endif
        
    }

    return rtnImage;
}

@end


#pragma mark -
#pragma mark UIImagePoolData

@implementation UIImagePoolData

@synthesize imageKey;
@synthesize uiImage;
@synthesize imageSize;
@synthesize usedCount;

- (id)initWithImage:(UIImage*)image andKey:(NSString*)key
{
    if (self = [super init])
    {
        self.imageKey = key;
        self.uiImage = image;
        self.imageSize = 0.f;
        self.usedCount = 0;
    }
    
    return self;
}

- (void)dealloc
{
    self.imageKey = nil;
    self.uiImage = nil;
    
    [super dealloc];
}

@end


#pragma mark -
#pragma mark UIImagePool

@implementation UIImagePool

@synthesize uiImagesDict = _uiImagesDict;
@synthesize uiImagesArray = _uiImagesArray;
@synthesize curMemorySize = _curMemorySize;

static UIImagePool* _uiImagePool = nil;

+ (UIImagePool*)instance
{
    if (nil != _uiImagePool)
    {
        return _uiImagePool;
    }
    
    @synchronized([UIImagePool class])
    {
        if (nil == _uiImagePool)
        {
            _uiImagePool = [[UIImagePool alloc] initUIImagePool];
        }
    }
    
    return _uiImagePool;
}

+ (void)delInstance
{
    if (nil != _uiImagePool)
    {
        [_uiImagePool release];
        _uiImagePool = nil;
    }
}

#pragma mark- 
#pragma mark init method

- (id)initUIImagePool
{
    if (self = [super init])
    {
        self.uiImagesDict = [NSMutableDictionary dictionary];
        self.uiImagesArray = [NSMutableArray array];
        self.curMemorySize = 0.f;
    }
    
    return self;
}

- (void)dealloc
{
    self.uiImagesDict = nil;
    self.uiImagesArray = nil;
    
    [super dealloc];
}

#pragma mark-
#pragma mark tools

- (void)addImageToPool:(UIImage*)image byKey:(NSString*)key
{
    CGFloat imageSize = image.size.width * image.size.height;
    if (imageSize > UIImageReferSize)
    {
        return;
    }
    
    // 先判断是否要清理部分图片
    _curMemorySize += imageSize;
    if (_curMemorySize > UIImageMaxMemSize)
    {
        [_uiImagesArray sortUsingComparator:^NSComparisonResult(UIImagePoolData* obj1, UIImagePoolData* obj2) {
            return (obj1.usedCount >= obj2.usedCount);
        }];
        
        int allImagesCount = [_uiImagesArray count];
        SNSLog(@"addImageToPool release begin: %d", allImagesCount);
        for (int i = 0; i < allImagesCount; i++)
        {
            UIImagePoolData* data = _uiImagesArray[i];
            if (_curMemorySize > UIImageBaseMemSize)
            {
                _curMemorySize -= data.imageSize;
                
                [_uiImagesDict removeObjectForKey:data.imageKey];
                [_uiImagesArray removeObject:data];
                
                i--;
                allImagesCount--;
            }
            else
            {
                // 将剩余所有图片的使用计数清0
                data.usedCount = 0;
            }
        }
        SNSLog(@"addImageToPool release end: %d", allImagesCount);
    }
    
    // 再缓存新图片
    UIImagePoolData* data = [[[UIImagePoolData alloc] initWithImage:image andKey:key] autorelease];
    data.imageSize = imageSize;
    [_uiImagesDict setValue:data forKey:key];
    [_uiImagesArray addObject:data];
}

- (UIImage*)getImageByKey:(NSString*)key
{
    UIImagePoolData* data = _uiImagesDict[key];
    if (nil != data)
    {
        data.usedCount++;
        return data.uiImage;
    }
    
    return nil;
}

@end

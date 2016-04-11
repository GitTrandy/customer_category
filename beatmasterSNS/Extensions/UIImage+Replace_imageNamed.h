//
//  UIImage+Replace_imageNamed.h
//  beatmasterSNS
//
//  Created by 周华 on 12-11-7.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Replace_imageNamed)

+ (UIImage *)imageNamed_New:(NSString *)name;
+ (UIImage *)imageWithContentsOfFile_New:(NSString *)path;
+ (BOOL)isRunningOnRetinaDisplay;

@end


@interface UIImagePoolData : NSObject

@property (nonatomic, copy) NSString* imageKey;
@property (nonatomic, retain) UIImage* uiImage;
@property (nonatomic, assign) CGFloat imageSize;  // 注意：只是图片长宽的乘积
@property (nonatomic, assign) int usedCount;

- (id)initWithImage:(UIImage*)image andKey:(NSString*)key;

@end

/*注意：这里所说的内存值实际上是图片长宽的乘积
 */
// 可占用内存的最小值 = 5 * 512.f * 512.f 实际值5*(512*512*4)
#define UIImageBaseMemSize 1310720.f   

// 可占用的内存的最大值 = 10.f * 512.f * 512.f ，超过这个值时将会释放部分图片，使内存在_baseMemorySize之内
#define UIImageMaxMemSize 2621440.f

// 参考值 = 512.f * 512.f，长宽乘积大于这个值的图片不缓存 
#define UIImageReferSize 524288.f  // 262144.f

@interface UIImagePool : NSObject

@property (nonatomic, retain) NSMutableDictionary* uiImagesDict;
@property (nonatomic, retain) NSMutableArray* uiImagesArray;
@property (nonatomic, assign) CGFloat curMemorySize; // 纪录当前占用的内存值

+ (UIImagePool*)instance;
+ (void)delInstance;

- (id)initUIImagePool;
- (void)addImageToPool:(UIImage*)image byKey:(NSString*)key;
- (UIImage*)getImageByKey:(NSString*)key;

@end
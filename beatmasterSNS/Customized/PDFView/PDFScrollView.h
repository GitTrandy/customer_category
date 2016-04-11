//
//  PDFScrollView.h
//  TestPDFRenderView
//
//  Created by Sunny on 13-9-3.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PDFScrollView : UIScrollView
- (void)setPDFFileName:(NSString *)fileName;
- (void)setPDFDocumentRef:(CGPDFDocumentRef)PDFDocumentRef;

// config
- (void)setPDFBackgroundColor:(UIColor *)color; // Default is white
@end

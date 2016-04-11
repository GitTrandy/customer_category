//
//  PDFRenderView.m
//  TestPDFRenderView
//
//  Created by Sunny on 13-9-3.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "PDFRenderView.h"

@interface PDFRenderView ()
{
    CGPDFPageRef _pdfPageRef;
}
@end

@implementation PDFRenderView


#pragma mark - Setters

- (void)setPdfPageRef:(CGPDFPageRef)pdfPageRef
{
    // 内存管理
    CGPDFPageRelease(_pdfPageRef);
    _pdfPageRef = CGPDFPageRetain(pdfPageRef);
    
    [self setNeedsDisplay];

}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    
    // 得到绘图上下文环境
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);{
        	
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
        
        // 转变坐标系
        CGRect boxRect = CGPDFPageGetBoxRect(_pdfPageRef, kCGPDFArtBox);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, rect.size.width/boxRect.size.width, -(rect.size.height/boxRect.size.height));
        // 画PDF
        CGContextDrawPDFPage(context, _pdfPageRef);
    }CGContextRestoreGState(context);
    
}


- (void)dealloc
{
    CGPDFPageRelease(_pdfPageRef);
    
    [super dealloc];
}
@end

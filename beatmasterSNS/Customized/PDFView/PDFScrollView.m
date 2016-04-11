//
//  PDFScrollView.m
//  TestPDFRenderView
//
//  Created by Sunny on 13-9-3.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "PDFScrollView.h"
#import "PDFRenderView.h"

@interface PDFScrollView ()
{
    CGPDFDocumentRef _pdfRef;
}
@property (nonatomic, retain) UIView* pdfContentView;
@end

@implementation PDFScrollView

#pragma mark - Public

- (void)setPDFFileName:(NSString *)fileName
{
    CFURLRef pathURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (CFStringRef)fileName, NULL, NULL);
    CGPDFDocumentRef pdfDocRef = CGPDFDocumentCreateWithURL(pathURLRef);
    CFRelease(pathURLRef);
    [self setPDFDocumentRef:pdfDocRef];
    CGPDFDocumentRelease(pdfDocRef);
}

- (void)setPDFDocumentRef:(CGPDFDocumentRef)PDFDocumentRef
{
    // 内存管理
    CGPDFDocumentRelease(_pdfRef);
    _pdfRef = CGPDFDocumentRetain(PDFDocumentRef);
    
    // 排列加载pdf的各个page
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(_pdfRef);
    CGSize renderViewSize = CGSizeZero;
    for (size_t i = 0; i < numberOfPages; i++)
    {
        PDFRenderView* renderView = [[[PDFRenderView alloc] init] autorelease];
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(_pdfRef, i + 1);

        CGRect boxRect = CGPDFPageGetBoxRect(pageRef, kCGPDFArtBox);
        renderViewSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(boxRect)*SNS_SCALE*0.75f/*fix value*/);
        renderView.frame = CGRectMake(0, renderViewSize.height*i, renderViewSize.width, renderViewSize.height);
        [renderView setPdfPageRef:pageRef];
        [self.pdfContentView addSubview:renderView];
    }
    
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), renderViewSize.height * numberOfPages);
    self.pdfContentView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:self.pdfContentView];
}

// Config
- (void)setPDFBackgroundColor:(UIColor *)color
{
    for (PDFRenderView* renderView in self.pdfContentView.subviews)
    {
        renderView.backgroundColor = color;
    }
}

#pragma mark - Private

- (UIView *)pdfContentView
{
    if (!_pdfContentView)
    {
        _pdfContentView = [UIView new];
    }
    return _pdfContentView;
    
}

#pragma mark - Dealloc

- (void)dealloc
{
    self.pdfContentView = nil;
    CGPDFDocumentRelease(_pdfRef);

    [super dealloc];
}

@end

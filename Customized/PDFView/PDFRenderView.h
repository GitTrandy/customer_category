//
//  PDFRenderView.h
//  TestPDFRenderView
//
//  Created by Sunny on 13-9-3.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PDFRenderView : UIView

- (void)setPdfPageRef:(CGPDFPageRef)pdfPageRef;

@end

//
//  CustomTextView.m
//  beatmasterSNS
//
//  Created by wanglei on 13-8-12.
//
//

#import "CustomTextView.h"
#import "UITextView+Extension.h"

@interface CustomTextView()

-(void)createAllViewWithType:(EGameBGType)bgType;
-(void)updateTextNum:(int)num;
-(void) btnClear:(id)sender;

@end

@implementation CustomTextView

@synthesize textView = _textView;
@synthesize eventDelegate = _eventDelegate;

-(id)initWithFrame:(CGRect)frame maxCnt:(int)maxCnt bgType:(EGameBGType)bgType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //如40表示最多20个中文，40个英文
        _maxCount = maxCnt;
        
        _eventDelegate = nil;
        
        [self createAllViewWithType:bgType];
    }
    return self;
}

-(void)dealloc
{
    if (_textView)
    {
        [_textView release];
    }
    
    if (_textNum)
    {
        [_textNum release];
    }
    
    [super dealloc];
}

#pragma mark - private
-(void)createAllViewWithType:(EGameBGType)bgType
{
    //设置背景
    self.backgroundColor = [UIColor clearColor];
    
    //创建textView
    _textView = [[UITextView alloc] initWithFrame:SNSRect(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
    _textView.text = @"";
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont systemFontOfSize:14*SNS_SCALE];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.textAlignment = UITextAlignmentLeft;
    _textView.contentInset = UIEdgeInsetsMake(-2.f*SNS_SCALE, -2.f*SNS_SCALE, 0.0f, 0.0f);
    _textView.keyboardType = UIKeyboardTypeDefault;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
    [self addSubview:_textView];
    
    //字数
    
    //背景按钮
    CGRect rt = _textView.frame;
    UIButton* btnClear = [[UIButton alloc] initWithFrame:CGRectMake(rt.size.width - 40.f*SNS_SCALE, rt.size.height - 40.f*SNS_SCALE, 40*SNS_SCALE, 40*SNS_SCALE)];
    btnClear.backgroundColor = [UIColor clearColor];
    [btnClear addTarget:self action:@selector(btnClear:) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:btnClear];
    [btnClear release];
    
    //字数
    _textNum = [[UILabel alloc] initWithFrame:CGRectMake(2.f*SNS_SCALE, 25.f*SNS_SCALE, 20.f*SNS_SCALE, 17.f*SNS_SCALE)];
    _textNum.font = [UIFont boldSystemFontOfSize:14*SNS_SCALE];
    _textNum.backgroundColor = [UIColor clearColor];
    _textNum.textColor = [UIColor whiteColor];
    _textNum.textAlignment = NSTextAlignmentCenter;
    [btnClear addSubview:_textNum];
    
    [self updateTextNum];
    
    //X
    NSString* strImage = nil;
    switch (bgType)
    {
        case EGT_PROFILE:
            strImage = @"Profile_sign_clear@2x.png";
            break;
            
        default:
            strImage = @"Profile_sign_clear@2x.png";
            break;
    }
    
    UIImageView* pX = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:strImage]];
    pX.frame = CGRectMake(20.f*SNS_SCALE, 29.f*SNS_SCALE, 10.f*SNS_SCALE, 10.f*SNS_SCALE);
    [btnClear addSubview:pX];
    [pX release];
}

-(void)updateTextNum:(int)num
{
    if (_textNum)
    {
        NSString* strNum = [NSString stringWithFormat:@"%d", num];
        _textNum.text = strNum;
    }
}

-(void)updateTextNum
{
    int nLen = [_textView limitTextByMaxCharacterCount:_maxCount];
    if (nLen<0)
        nLen = 0;
    else if(nLen>_maxCount)
        nLen = _maxCount;
    
    [self updateTextNum:nLen];
}

#pragma mark - btn callback
-(void) btnClear:(id)sender
{
    if (_textView)
    {
        _textView.text = @"";
        
        [self updateTextNum:_maxCount];
    }
    
    if (_eventDelegate)
    {
        [_eventDelegate onClickClear];
    }
}

#pragma mark - UITextView delegate

-(void) textViewDidChange:(UITextView *)textView{
    
    if (_textView)
    {
        [self updateTextNum];
    }
    
    if (_eventDelegate)
    {
        [_eventDelegate onTextDidChange];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"])
    {
        //确定
        if (_textView && _eventDelegate)
        {
            [_eventDelegate onClickReturnKey];
        }
        
        return NO;
    }
    
    BOOL bRet = YES;
    
    if ([text isEqualToString:@""])
    {
        //点击x可以删除，因为老的数据有可能会多于n个造成删除不掉的情况
        bRet = YES;
    }
    else if (range.location >= _maxCount)
    {
        bRet = NO;
    }
    return bRet;
}

@end

//Sunny
//

#import "InputHelper.h"

@interface InputHelper(Private)

//键盘消息和回调
- (void)addKeyboardNotification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

//键盘附加工具栏按钮回调
- (void)prevItemTouched:(id)sender;
- (void)nextItemTouched:(id)sender;
- (void)doneItemTouched:(id)sender;

//触摸手势回调 触摸外部关闭键盘
- (void)touchedOutside:(id)sender;

//移动动画
- (void)animationMoveBy:(CGFloat)offset;
- (void)animationScaleTo:(UITextField *)textField scale:(CGFloat)scale;

//焦点
- (void)loseFocus:(UITextField *)textField;
- (void)setFocus:(UITextField *)textField;
@end

@implementation InputHelper

#pragma mark - data

static NSString* const KeyboardAccessoryToolbarNibName = @"KeyboardAccessoryToolbar";
static CGFloat const MoveAnimationDuration = 0.4;
static CGFloat const ScaleAnimationDuration = 0.2f;
static CGFloat const ScaleAnimationScaleFactor = 1.2f;

#pragma mark - init

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) 
    {
        NSAssert(view, @"InputHelper: initWithView : view must not be nil");
        _view = [view retain];
        
        [self addKeyboardNotification];
        
        //UIGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedOutside:)] autorelease];
        //[_view addGestureRecognizer:recognizer];
        
        //_viewController.view.autoresizesSubviews = YES;
        
        _activeTextField = nil;
        _textFields = nil;
        _offset = 0;

        
        
        
    }
    return self;
}

#pragma mark - public method

- (void)addTextFields:(NSArray *)textFields
{
    //外部需使用autorelease或手动release
    _textFields = [textFields retain];
    
    
    for (UITextField* textField in textFields) 
    {
        //从xib中导入toolbar view 设置各个item的响应函数
        UIToolbar* toolbar = [[NSBundle mainBundle] loadNibNamed: KeyboardAccessoryToolbarNibName owner:nil options:nil][1];
        
        //上一项item
        UIBarButtonItem* prevItem = (toolbar.items)[0];
        prevItem.target = self;
        prevItem.action = @selector(prevItemTouched:);
        
        //下一项item
        UIBarButtonItem* nextItem = (toolbar.items)[1];
        nextItem.target = self;
        nextItem.action = @selector(nextItemTouched:);
            
        //toolbar中间预设的消息栏item
        UIBarButtonItem* msgItem = (toolbar.items)[2];
        [msgItem setTitle:textField.placeholder];
        
        //完成item
        UIBarButtonItem* doneItem = (toolbar.items)[4];
        doneItem.target = self;
        doneItem.action = @selector(doneItemTouched:);
        
        //设置每个text field的属性
        textField.delegate = self;
        textField.inputAccessoryView = toolbar;
        [_view addSubview:textField];
        
    }
    
}

#pragma mark - keyboard notification

- (void)addKeyboardNotification
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    //从notification中取得键盘frame
    NSDictionary* userInfo = [notification userInfo];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //计算键盘外可视区域rect
    CGRect rectCanBeSeen = CGRectMake(0, 0, keyboardFrame.size.height, 320 - keyboardFrame.size.width);
    
    //判断是否被挡住 不挡住不移动
    BOOL isCovered = !CGRectEqualToRect(CGRectIntersection(_activeTextField.frame, rectCanBeSeen), _activeTextField.frame);
    
    //计算新的偏移值 移动到可视区域中心位置
    CGFloat screenHeight = [[UIApplication sharedApplication].delegate window].frame.size.width;
    CGFloat newOffset = (screenHeight - keyboardFrame.size.width) / 2 - _activeTextField.frame.size.height / 2 - _activeTextField.frame.origin.y;
    
    if (isCovered) 
    {
        //动画移动
        [self animationMoveBy:newOffset];
        _offset += newOffset;
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self animationMoveBy:-_offset];
    _offset = 0;
}

#pragma mark - callbacks

- (void)prevItemTouched:(id)sender
{
    
    int index = [_textFields indexOfObject:_activeTextField];
    index = (index - 1 < 0) ? [_textFields count] - 1 : index - 1;
    [self setFocus:_textFields[index]];
}

- (void)nextItemTouched:(id)sender
{
    int index = [_textFields indexOfObject:_activeTextField];
    index = (index + 1 > [_textFields count] - 1) ? 0 : index + 1;
    [self setFocus:_textFields[index]];
}

- (void)doneItemTouched:(id)sender
{
    [self loseFocus:_activeTextField];
}

- (void)touchedOutside:(id)sender
{
    [self loseFocus:_activeTextField];
}

#pragma mark - move animation

- (void)animationMoveBy:(CGFloat)offset
{
    [UIView beginAnimations:@"moveAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];    
    [UIView setAnimationDuration:MoveAnimationDuration];
    
    for (UIView* subview in _view.subviews) 
    {
        CGRect newRect = subview.frame;
        newRect.origin.y += offset;
        subview.frame = newRect;
        
    }
    
    [UIView commitAnimations];
}

- (void)animationScaleTo:(UITextField *)textField scale:(CGFloat)scale
{
    [UIView beginAnimations:@"scaleAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];    
    [UIView setAnimationDuration:ScaleAnimationDuration];
    
    textField.transform = CGAffineTransformMakeScale(scale, scale);
    
    [UIView commitAnimations];
}

#pragma mark - lose/set focus

- (void)loseFocus:(UITextField *)textField
{
    [textField resignFirstResponder];
    _activeTextField = nil;
    [self animationScaleTo:textField scale:1.0f];
}

- (void)setFocus:(UITextField *)textField
{
    [textField becomeFirstResponder];
    _activeTextField = textField;
    [self animationScaleTo:textField scale:ScaleAnimationScaleFactor];
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //SNSLog(@"textFieldDidBeginEditing");
    [self setFocus:textField];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //SNSLog(@"textFieldDidEndEditing");
    [self loseFocus:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UIToolbar* toolbar = (UIToolbar*)textField.inputAccessoryView;
    UIBarButtonItem* item = (toolbar.items)[2];
    [item setTitle:textField.placeholder];
    
    if (range.location >= 7) 
    {
//        CMPopTipView* popTip = [[CMPopTipView alloc] initWithMessage:@"此处不能超过7个字符"];
//        popTip.animation = CMPopTipAnimationPop;
//        popTip.backgroundColor = [UIColor orangeColor];
//        popTip.textColor = [UIColor whiteColor];
//        popTip.borderWidth = 5.0f;
//        popTip.borderColor = [UIColor whiteColor];
//        [popTip autoDismissAnimated:YES atTimeInterval:2.0f];
//        [popTip presentPointingAtView:textField inView:_view animated:YES];
//        
//        [popTip release];
//        return NO;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField.text length];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loseFocus:textField];
  
    
  
    
    
    
    return YES;
}

#pragma mark - dealloc

- (void)dealloc
{
    [_view release];
    [_textFields release];
    
    _activeTextField = nil;
    
    
    
    [super dealloc];
}
@end

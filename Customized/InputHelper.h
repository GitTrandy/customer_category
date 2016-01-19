//Sunny
//

#import <Foundation/Foundation.h>

@interface InputHelper : NSObject <UITextFieldDelegate>
{
    @private
    UIView*         _view;
    @private
    UITextField*    _activeTextField;
    NSArray*        _textFields;
    CGFloat         _offset;
    
}

- (id)initWithView:(UIView *)view;

- (void)addTextFields:(NSArray *)textFields;

@end

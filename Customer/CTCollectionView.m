//
//  CTCollectionView.m
//  circle_iphone
//
//  Created by trandy on 15/11/26.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "CTCollectionView.h"
#import "FixedHeaderLayout.h"
#import "SubscribeCell.h"
#import "SubscribeReusableView.h"
#import "CTSubject.h"

@interface CTCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)   UICollectionView    *collectionView;
@property (nonatomic,copy)      NSArray             *dataArray;
@property (nonatomic,strong)    NSMutableArray      *selectArray;
@property (nonatomic,copy)      NSString            *collectTitle;
@property (nonatomic,copy)      void (^closeBlock)(NSArray *,BOOL);
@property (nonatomic,copy)      void (^selectBlock)(NSArray *,NSString *);

@property (nonatomic,strong)    UIView              *bgView;

@end

@implementation CTCollectionView

- (instancetype)initWithFrame:(CGRect)frame allArray:(NSArray *)allArray selectArray:(NSArray *)selectArray title:(NSString *)title
{
    self = [super initWithFrame:DEVICE_RECT];
    if (self) {
        self.maxSelectCount = 1;
        self.dataArray = allArray;
        self.selectArray = [[NSMutableArray alloc] initWithArray:selectArray];
        self.noticeWord = @"";
        self.collectTitle = title;
        
        self.bgView = [[UIView alloc] initWithFrame:DEVICE_RECT];
        self.bgView.backgroundColor = CTColorMake(0, 0, 0, 0.7);
        [self addSubview:self.bgView];
        
        FixedHeaderLayout *flowLayout = [[FixedHeaderLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CTSize(DEVICE_WIDTH, 44*CT_SCALE);
        
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = CTColorMake(243, 243, 243, 1);
        self.collectionView.scrollEnabled = YES;
        [self.collectionView registerClass:[SubscribeCell class] forCellWithReuseIdentifier:@"SubscribeCell"];
        [self.collectionView registerClass:[SubscribeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SubscribeReusableView"];
        [self.collectionView reloadData];
        [self addSubview:self.collectionView];

    }
    return self;
}

#pragma mark - UICollection Delegate & Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SubscribeCell";
    SubscribeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.layer.borderColor = [CTColorMake(239, 239, 239, 1) CGColor];
    cell.layer.borderWidth = 1.0f;
    cell.layer.cornerRadius = 2.5;
    cell.layer.masksToBounds = YES;
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.isChoose = NO;
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.textColor = CTColorMake(124, 124, 124, 1);
    
    cell.titleLabel.text = self.dataArray[[indexPath row]];
    for (int i = 0; i<[self.selectArray count]; i++) {
        if ([self.selectArray[i] isEqualToString:cell.titleLabel.text]) {
            cell.backgroundColor = CTBlueColor;
            cell.isChoose = YES;
            cell.titleLabel.textColor = CTColorMake(255, 255, 255, 1);
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CTSize(67*CT_SCALE, 23*CT_SCALE);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7.5*CT_SCALE, 7.5*CT_SCALE, 7.5*CT_SCALE, 7.5*CT_SCALE);
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribeCell * cell = (SubscribeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isChoose) {
        //        cell.backImg.image = [UIImage imageNamed:@"SU_btn_0.png"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.isChoose = NO;
        cell.titleLabel.textColor = CTColorMake(124, 124, 124, 1);
        [self.selectArray removeObject:cell.titleLabel.text];
    }else{
        if ([self.selectArray count] >= self.maxSelectCount) {
            NSString *notice = [NSString stringWithFormat:@"最多选择%ld项",self.maxSelectCount];
            [CTNotice showNotice:[self.noticeWord isEqualToString:@""] ? notice : self.noticeWord];
            return;
        }
        [self.selectArray addObject:cell.titleLabel.text];
        
        cell.backgroundColor = CTBlueColor;
        cell.isChoose = YES;
        cell.titleLabel.textColor = CTColorMake(255, 255, 255, 1);
    }
    if (self.selectBlock) {
        self.selectBlock([self.selectArray copy],cell.titleLabel.text);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        SubscribeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SubscribeReusableView" forIndexPath:indexPath];
        headerView.titleLabel.text = self.collectTitle;
        [headerView.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didSelectItem:(void (^)(NSArray *selectArray,NSString *itemName))block
{
    self.selectBlock = block;
}

- (void)didCloseCollection:(void (^)(NSArray *selectArray,BOOL save))block
{
    self.closeBlock = block;
}

- (void)cancelBtnClick:(id)sender
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.collectionView.frame = CTRect(0,DEVICE_HEIGHT,self.collectionView.frame.size.width,self.collectionView.frame.size.height);
                         self.bgView.alpha = 0;
                     } completion:^(BOOL finished) {
                         if (self.closeBlock) {
                             [self removeFromSuperview];
                             self.closeBlock([self.selectArray copy],NO);
                         }
                     }];
    
}

- (void)sureBtnClick:(id)sender
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.collectionView.frame = CTRect(0,DEVICE_HEIGHT,self.collectionView.frame.size.width,self.collectionView.frame.size.height);
                         self.bgView.alpha = 0;
                     } completion:^(BOOL finished) {
                         if (self.closeBlock) {
                             [self removeFromSuperview];
                             self.closeBlock([self.selectArray copy],YES);
                         }
                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.bgView]) {
        [self.bgView setUserInteractionEnabled:NO];
        [self cancelBtnClick:nil];
    }
}


@end

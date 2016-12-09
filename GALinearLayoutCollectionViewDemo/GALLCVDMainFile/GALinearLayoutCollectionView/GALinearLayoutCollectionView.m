//
//  GALinearLayoutCollectionView.m
//  GALinearLayoutCollectionViewDemo
//
//  Created by GikkiAres on 2016/12/9.
//  Copyright © 2016年 Explorer. All rights reserved.
//

#import "GALinearLayoutCollectionView.h"


@interface GALinearLayoutCollectionView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>


//逻辑上的cell个数
@property(nonatomic,assign) NSInteger logicalCellNum;
//实际的cell个数.
@property(nonatomic,assign) NSInteger factCellNum;
//当前选择的cell index.
@property(nonatomic,assign) NSInteger currentFactIndex;
@property(nonatomic,assign) NSInteger repeatMultiple;

@property (nonatomic,assign)BOOL isInitalScrolled;

@property (nonatomic,strong)NSTimer *autoScrollTimer;


- (void)initalScroll;
- (void)scrollToMainArea;

@end


@implementation GALinearLayoutCollectionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.delegate = self;
    self.dataSource = self;
    self.repeatMultiple = 20;
    self.showsHorizontalScrollIndicator = NO;
    
    __weak typeof(self) weakSelf = self;
    GACollectionViewLinearLayout *layout =  (GACollectionViewLinearLayout *)self.collectionViewLayout;
    [layout setDidScrollAt:^(NSInteger index) {
        weakSelf.currentFactIndex = index;
        if ([weakSelf.gaDelegate respondsToSelector:@selector(gaCollectionView:scrollAtIndexPath:)]) {
            NSInteger logicItem = index%_logicalCellNum;
            NSIndexPath *logicIndexPath = [NSIndexPath indexPathForItem:logicItem inSection:0];
            [weakSelf.gaDelegate gaCollectionView:weakSelf scrollAtIndexPath:logicIndexPath];
        }
    }
     ];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initalScroll];
}

#pragma mark Setter&Getter
- (void)setGaDelegate:(id<GALinearLayoutCollectionViewDelegate,GACollectionViewLinearLayoutDelegate,GALinearLayoutCollectionViewDataSource>)gaDelegate {
    _gaDelegate = gaDelegate;
    GACollectionViewLinearLayout *layout =( GACollectionViewLinearLayout *)self.collectionViewLayout;
    layout.delegate = gaDelegate;
}

- (void)setShouldAutoScroll:(BOOL)shouldAutoScroll {
    _shouldAutoScroll = shouldAutoScroll;
    if (shouldAutoScroll) {
        _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(scrollToNextIndexPath) userInfo:nil repeats:YES];
    }
    else {
        if(_autoScrollTimer) {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

- (CGFloat)autoScrollInterval {
    if (_autoScrollInterval<=0) {
        return 5;
    }
    else {
        return _autoScrollInterval;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_gaDelegate respondsToSelector:@selector(gaCollectionView:cellForItemAtIndexPath:)]) {
        //将indexPath的logicIndexPath返回.
        NSInteger factItem = indexPath.item;
        NSInteger logicItem = factItem%_logicalCellNum;
        NSIndexPath *logicIndexPath = [NSIndexPath indexPathForItem:logicItem inSection:indexPath.section];
        return [_gaDelegate gaCollectionView:self cellForItemAtIndexPath:logicIndexPath];
    }
    else return nil;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_gaDelegate respondsToSelector:@selector(gaCollectionView:numberOfItemsInSection:)]) {
        _logicalCellNum = [_gaDelegate gaCollectionView:self numberOfItemsInSection:section];
        _factCellNum = _logicalCellNum*_repeatMultiple;
        return _factCellNum;
    }
    else return 0;
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger factItem = indexPath.item;
    NSInteger logicItem = factItem%_logicalCellNum;
    NSIndexPath *logicIndexPath = [NSIndexPath indexPathForItem:logicItem inSection:indexPath.section];
//    NSLog(@"factIndex:%zi--logicIndex:%zi",indexPath.row,logicIndexPath.row);
    if ([_gaDelegate respondsToSelector:@selector(gaCollectionView:didSelectItemAtIndexPath:)]) {
        [_gaDelegate gaCollectionView:self didSelectItemAtIndexPath:logicIndexPath];
    }
    else {
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


//滚动到中间第一个.
- (void)initalScroll {
    if(!_isInitalScrolled) {
        _isInitalScrolled = YES;
        _currentFactIndex = 0;
        [self scrollToMainArea];
    }
}

//手动拨动结束动画时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        if(_autoScrollTimer) {
            [_autoScrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoScrollInterval]];
        }
     [self scrollToMainArea];
}

//动画滚动调用结束时调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollToMainArea];
}


 //滑动结束时调用，不使用动画以实现无缝回滚到中间区域对应条目
- (void)scrollToMainArea {
    NSInteger logicalIndex = _currentFactIndex%_logicalCellNum;
    NSInteger factInexMain = logicalIndex+_factCellNum/2;
    NSIndexPath *index = [NSIndexPath indexPathForItem:factInexMain inSection:0];
    [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(void)scrollToNextIndexPath{
    if (_currentFactIndex<_factCellNum-1) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:_currentFactIndex+1 inSection:0];
           [self scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(_autoScrollTimer) {
    [_autoScrollTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if(_autoScrollTimer) {
        [_autoScrollTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoScrollInterval]];
    }
}

@end

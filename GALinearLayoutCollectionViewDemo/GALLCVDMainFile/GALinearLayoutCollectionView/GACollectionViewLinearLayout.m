//
//  GACollectionViewLinearLayout.m
//  GALinearLayoutCollectionViewDemo
//
//  Created by GikkiAres on 2016/12/9.
//  Copyright © 2016年 Explorer. All rights reserved.
//

#import "GACollectionViewLinearLayout.h"

@interface GACollectionViewLinearLayout ()

@property(nonatomic,assign)NSInteger currentItem;

@end


@implementation GACollectionViewLinearLayout

//最小的大小比例
#define MIN_SCALE  0.55


- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _currentItem = 0;
    
    //设置尺寸
    if([_delegate respondsToSelector:@selector(gaCollectionViewLinearLayoutCellSize:)]) {
        self.itemSize = [_delegate gaCollectionViewLinearLayoutCellSize:self];
    }
    else {
        CGFloat cellSize = self.collectionView.frame.size.height;
        self.itemSize = CGSizeMake(cellSize, cellSize);
    }
    //设置上下左右的间距
    if([_delegate respondsToSelector:@selector(gaCollectionViewLinearLayoutSectionInsets:)]) {
        self.sectionInset= [_delegate gaCollectionViewLinearLayoutSectionInsets:self];
    }
    else {
        CGFloat insetV = (self.collectionView.frame.size.height-self.itemSize.height)/2;
        self.sectionInset = UIEdgeInsetsMake(insetV, 0, insetV, 0);
    }
    
    //设置cell之间的间距
    if ([_delegate respondsToSelector:@selector(gaCollectionViewLinearLayoutMinimumLineSpacing:)]) {
     self.minimumLineSpacing =  [_delegate gaCollectionViewLinearLayoutMinimumLineSpacing:self];
    }
    else {
    self.minimumLineSpacing = 0;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    //    This is likely occurring because the flow layout subclass GALinearLayout is modifying attributes returned by UICollectionViewFlowLayout without copying them
    //rect是屏幕矩形
    NSArray *arrayOrigin = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *array = [NSMutableArray array];
    [arrayOrigin enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attr = [obj copy];
        [array addObject:attr];
    }];
    //    array = arrayOrigin;

    //当前显示区域的中线的frame.origin.x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (int i = 0; i< array.count; i++) {
        //遍历每个item的attr
        UICollectionViewLayoutAttributes *attrs = array[i];
        //每个item离中线的距离
        CGFloat delta = ABS(centerX - attrs.center.x);
        
        //实际可能出现的delta可能很大,所以最好用1/delta来操作.
        //根据距离按比例设置缩放. 有可能出现距离大于半屏幕的情况,所以不要用这个.
        CGFloat t = delta/(self.collectionView.frame.size.width/2);
        if(t>1) t=1;
        CGFloat scale =  MIN_SCALE + (1-MIN_SCALE)*(1-t);
        //        NSLog(@"%.2f,%.2f,%.2f,%.2f,%.2f",centerX,attrs.center.x,delta,t,scale);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        //弧形排列
        //                attrs.center = CGPointMake(attrs.center.x,self.collectionView.frame.size.height*0.3+self.collectionView.frame.size.height*0.45*(1-t*t));
        
        //距离为10的设置为item设为当前item,并提供一个时机.
        if (delta<10&&_currentItem!=attrs.indexPath.item) {
            _currentItem = attrs.indexPath.item;
            if (self.didScrollAt) {
                
                self.didScrollAt(attrs.indexPath.item);
            }
        }
    }
    
    for (int i = 0; i< array.count; i++) {
        
        UICollectionViewLayoutAttributes *attrs = array[i];
        //设置层叠状态，中间的zIndex为0，越远的越小，越靠后
        attrs.zIndex =-1*ABS(attrs.indexPath.item - _currentItem);
    }
    
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //保证滑动结束后,让一个item的位置处于正中间.
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(attrs.center.x - centerX)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
    
    //还有一个问题可以考虑在这里解决,就是用户不停地拨,有可能拨到头.
    //解决方案之一是在用户手指离开后,进入main区域.然后让他滚动一样的相对距离.
}

- (void)dealloc {
    
}


@end

//
//  GACollectionViewLinearLayout.h
//  GALinearLayoutCollectionViewDemo
//
//  Created by GikkiAres on 2016/12/9.
//  Copyright © 2016年 Explorer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GACollectionViewLinearLayout;
@protocol GACollectionViewLinearLayoutDelegate <NSObject>
@optional;
//最大时候的尺寸
- (CGSize)gaCollectionViewLinearLayoutCellSize:(GACollectionViewLinearLayout *)layout;
//上下左右的间距
- (UIEdgeInsets)gaCollectionViewLinearLayoutSectionInsets:(GACollectionViewLinearLayout *)layout;
//cell之间的间距
- (CGFloat)gaCollectionViewLinearLayoutMinimumLineSpacing:(GACollectionViewLinearLayout *)layout;


- (void)gaCollectionViewLinearLayoutPrepareLayout:(GACollectionViewLinearLayout *)layout;


@end


@interface GACollectionViewLinearLayout : UICollectionViewFlowLayout

@property(nonatomic,weak) id<GACollectionViewLinearLayoutDelegate> delegate;
@property (nonatomic,copy) void(^didScrollAt)(NSInteger index);
@property (nonatomic,copy) void(^didEndTouch)();

@end

//
//  GALinearLayoutCollectionView.h
//  GALinearLayoutCollectionViewDemo
//
//  Created by GikkiAres on 2016/12/9.
//  Copyright © 2016年 Explorer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GACollectionViewLinearLayout.h"

@class GALinearLayoutCollectionView;
@protocol GALinearLayoutCollectionViewDelegate <NSObject>

- (void)gaCollectionView:(GALinearLayoutCollectionView *)collectionView scrollAtIndexPath:(NSIndexPath *)indexPath;
- (void)gaCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

@protocol GALinearLayoutCollectionViewDataSource <NSObject>
- (NSInteger)gaNumberOfSectionsInCollectionView:(GALinearLayoutCollectionView *)collectionView;
- (NSInteger)gaCollectionView:(GALinearLayoutCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell *)gaCollectionView:(GALinearLayoutCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface GALinearLayoutCollectionView : UICollectionView

@property (nonatomic,weak) id <GALinearLayoutCollectionViewDelegate,GACollectionViewLinearLayoutDelegate,GALinearLayoutCollectionViewDataSource> gaDelegate;

@property (nonatomic,assign)CGFloat autoScrollInterval;
@property (nonatomic,assign)BOOL shouldAutoScroll;

@end

//
//  GALLCVDViewController.m
//  GALinearLayoutCollectionViewDemo
//
//  Created by GikkiAres on 2016/12/9.
//  Copyright © 2016年 Explorer. All rights reserved.
//

#import "GALLCVDViewController.h"
#import "GALinearLayoutCollectionView.h"
#import "GALinearLayoutCollectionViewCell.h"

@interface GALLCVDViewController ()<
GALinearLayoutCollectionViewDelegate,
GACollectionViewLinearLayoutDelegate,
GALinearLayoutCollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet GALinearLayoutCollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *marrImagePath;


@end

@implementation GALLCVDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_collectionView registerNib:[UINib nibWithNibName:@"GALinearLayoutCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    _collectionView.gaDelegate = self;
    _collectionView.shouldAutoScroll = YES;
    _marrImagePath = [@[@"h1.jpg",@"h2.jpg",@"h3.jpg",@"h4.jpg"]mutableCopy];
}

- (NSInteger)gaNumberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)gaCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)gaCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GALinearLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:_marrImagePath[indexPath.row]];
    cell.customImageView.image = image;
    return cell;
}

- (CGSize)gaCollectionViewLinearLayoutCellSize:(GACollectionViewLinearLayout *)layout {
    CGSize cellSize = CGSizeMake(200, 100);
    return cellSize;
}
- (CGFloat)gaCollectionViewLinearLayoutMinimumLineSpacing:(GACollectionViewLinearLayout *)layout {
    return -30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

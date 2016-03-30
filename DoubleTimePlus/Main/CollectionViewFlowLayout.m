//
//  CollectionViewFlowLayout.m
//  eWeather
//
//  Created by Manish Dudharejia on 03/01/15.
//  Copyright (c) 2015 E2M. All rights reserved.
//

#import "CollectionViewFlowLayout.h"
#import "Common.h"

@implementation CollectionViewFlowLayout

- (instancetype)init{
    self = [super init];
    if (self) {
       // NSLog(@"Here");
    }
    return self;
}

- (void)awakeFromNib{
   // NSLog(@"Here");
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat itemWidth = 0;
    if(IPHONE4S||IPHONE5S){
        itemWidth = (size.width-12)/2;
        self.minimumLineSpacing = 4.0;
    }else if(IPHONE6){
        itemWidth = (size.width-12)/2;
        self.minimumLineSpacing = 4.0;
    }else {
        itemWidth = (size.width-12)/2;
        self.minimumLineSpacing = 4.0;
    }
    
    CGFloat itemHeight=(size.height-50)/2;
    self.itemSize = CGSizeMake(itemWidth, itemHeight-self.minimumLineSpacing-2);
}

- (CGSize)collectionViewContentSize
{
    // Only support single section for now.
    // Only support Horizontal scroll
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView
                                               numberOfItemsInSection:0];
    
    CGSize canvasSize = self.collectionView.frame.size;
    CGSize contentSize = canvasSize;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
        NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
        NSUInteger page = ceilf((CGFloat)count / (CGFloat)(rowCount * columnCount));
        contentSize.width = page * canvasSize.width;
    }
    
    return contentSize;
}


- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize canvasSize = self.collectionView.frame.size;
    
    NSUInteger rowCount = (canvasSize.height - self.itemSize.height) / (self.itemSize.height + self.minimumInteritemSpacing) + 1;
    NSUInteger columnCount = (canvasSize.width - self.itemSize.width) / (self.itemSize.width + self.minimumLineSpacing) + 1;
    
    CGFloat pageMarginX = (canvasSize.width - columnCount * self.itemSize.width - (columnCount > 1 ? (columnCount - 1) * self.minimumLineSpacing : 0)) / 2.0f;
    CGFloat pageMarginY = (canvasSize.height - rowCount * self.itemSize.height - (rowCount > 1 ? (rowCount - 1) * self.minimumInteritemSpacing : 0)) / 2.0f;
    
    NSUInteger page = indexPath.row / (rowCount * columnCount);
    NSUInteger remainder = indexPath.row - page * (rowCount * columnCount);
    NSUInteger row = remainder / columnCount;
    NSUInteger column = remainder - row * columnCount;
    
    CGRect cellFrame = CGRectZero;
    cellFrame.origin.x = pageMarginX + column * (self.itemSize.width + self.minimumLineSpacing);
    cellFrame.origin.y = pageMarginY + row * (self.itemSize.height + self.minimumInteritemSpacing);
    cellFrame.size.width = self.itemSize.width;
    cellFrame.size.height = self.itemSize.height;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        cellFrame.origin.x += page * canvasSize.width;
    }
    
    return cellFrame;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    attr.frame = [self frameForItemAtIndexPath:indexPath];
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * originAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * attrs = [NSMutableArray array];
    
    [originAttrs enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * attr, NSUInteger idx, BOOL *stop) {
        NSIndexPath * idxPath = attr.indexPath;
        CGRect itemFrame = [self frameForItemAtIndexPath:idxPath];
        if (CGRectIntersectsRect(itemFrame, rect))
        {
            attr = [self layoutAttributesForItemAtIndexPath:idxPath];
            [attrs addObject:attr];
        }
    }];
    
    return attrs;
}
@end

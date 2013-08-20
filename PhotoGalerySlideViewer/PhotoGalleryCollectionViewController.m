//
//  PhotoGalleryCollectionViewController.m
//  PhotoGalerySlideViewer
//
//  Created by Ren Liu on 8/20/13.
//  Copyright (c) 2013 NexusPad. All rights reserved.
//

#import "PhotoGalleryCollectionViewController.h"
#import "LightboxViewController.h"

@interface PhotoGalleryCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *imageViews;
@end

@implementation PhotoGalleryCollectionViewController

@synthesize photos = _photos, imageViews = _imageViews;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PhotoCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *aImageView = (UIImageView *)[cell viewWithTag:100];
    
    aImageView.contentMode = UIViewContentModeScaleAspectFill;
    aImageView.clipsToBounds = YES;

    [aImageView setImage:[UIImage imageNamed:[_photos objectAtIndex:indexPath.row]]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"OpenLightbox" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath*)sender;
    LightboxViewController *lightboxController = (LightboxViewController*)segue.destinationViewController;
    lightboxController.displayIndex = indexPath.row;
    lightboxController.totalCount = _photos.count;
    lightboxController.lightboxViewHelper = self;
}

- (id)getEntryAtIndex:(int)index {
    return [_imageViews objectAtIndex:index];
}

- (id)getPreviousEntry:(int)index {
    if (index == 0) {
        return [_imageViews lastObject];    // continue with the last one
    } else {
        return [_imageViews objectAtIndex:index-1];
    }
}


- (id)getNextEntry:(int)index {
    NSLog(@"get index %d", index);
    if (index > _imageViews.count - 1) {
        return [_imageViews objectAtIndex:0]; // Go back to the first one
    }
    
    return [_imageViews objectAtIndex:index+1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _photos = [NSMutableArray arrayWithObjects:@"photo1.jpg", @"photo2.jpg", @"photo3.jpg", @"photo4.jpg", @"photo5.jpg", nil];
    
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    
    int i = 0;
    for (NSString *imageName in _photos) {
        [_imageViews addObject:[UIImage imageNamed:[_photos objectAtIndex:i]]];
        i++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

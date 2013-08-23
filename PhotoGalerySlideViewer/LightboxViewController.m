//
//  LightboxViewController.m
//  PhotoGalerySlideViewer
//
//  Created by Ren Liu on 8/20/13.
//  Copyright (c) 2013 NexusPad. All rights reserved.
//

#import "LightboxViewController.h"

@interface LightboxViewController ()

@end

@implementation LightboxViewController

- (id)getLeftPageView:(int)currentIndex {
    NSLog(@"Get photo to the left of index %d", currentIndex);
    if (currentIndex == 0) {        // No more to the left;
        return nil;
    }
    return [self getImageView:[self.lightboxViewHelper getEntryAtIndex:currentIndex-1] itsIndex:currentIndex-1];
}

// The currentIndex is the index we move into
// The nextIndex will be added to the right to maintain 3 page rotation.
- (id)getRightPageView:(int)currentIndex {
    NSLog(@"Get photo to the right of index %d", currentIndex);
    
    if ((currentIndex + 1) > self.totalCount - 1) { // Go back the the first one if it will be out of bounds of array
        return [self getImageView:[self.lightboxViewHelper getEntryAtIndex:0] itsIndex:0];
    }
    return [self getImageView:[self.lightboxViewHelper getEntryAtIndex:currentIndex+1] itsIndex:currentIndex+1];
}

- (UIImageView*)getImageView:(UIImage*)image itsIndex:(int)itsIndex {
    UIImageView *view = [[UIImageView alloc] initWithFrame:self.view.frame];
    [view setImage:image];
    
    // tag is used to save the index that NPScrollView uses to request image (left/right)
    view.tag = itsIndex;
    
    return view;
}

- (void)viewWillAppear:(BOOL)animated {
    NSMutableArray *initialPages = [[NSMutableArray alloc] initWithCapacity:3];
    
    CGRect rect = self.view.frame;
    
    if (self.displayIndex == 0) {
        [initialPages addObject:[self getImageView:[self.lightboxViewHelper getEntryAtIndex:0] itsIndex:0]];
        [initialPages addObject:[self getImageView:[self.lightboxViewHelper getEntryAtIndex:1] itsIndex:1]];
        
        _photoScrollView = [[NPScrollView alloc] initWithTwoPages:rect pageViews:initialPages startingIndex:0];
        _photoScrollView.dataDelegate = self;
        
    } else {
        [initialPages addObject:[self getImageView:[self.lightboxViewHelper getEntryAtIndex:self.displayIndex-1] itsIndex:self.displayIndex-1]];
        [initialPages addObject:[self getImageView:[self.lightboxViewHelper getEntryAtIndex:self.displayIndex] itsIndex:self.displayIndex]];
        [initialPages addObject:[self getImageView:[self.lightboxViewHelper getEntryAtIndex:self.displayIndex+1] itsIndex:self.displayIndex+1]];
        
        _photoScrollView = [[NPScrollView alloc] initWithPageViews:rect pageViews:initialPages startingIndex:self.displayIndex];
        _photoScrollView.dataDelegate = self;
        
    }
    
    [self.view addSubview:_photoScrollView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end

//
//  LightboxViewController.h
//  PhotoGalerySlideViewer
//
//  Created by Ren Liu on 8/20/13.
//  Copyright (c) 2013 NexusPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightboxViewDelegate.h"
#import "NPScrollView.h"

@interface LightboxViewController : UIViewController <NPScrollViewPageDataDelegate>

@property (nonatomic, strong) id<LightboxViewDelegate> lightboxViewHelper;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) NPScrollView *photoScrollView;

@property int displayIndex;
@property int totalCount;

@end

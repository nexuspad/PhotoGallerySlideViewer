//
//  NPScrollView.h
//  nexusapp
//
//  Created by Ren Liu on 8/17/13.
//
//

#import <UIKit/UIKit.h>

@protocol NPScrollViewPageDataDelegate <NSObject>
- (id)getLeftPageView:(int)currentIndex;
- (id)getRightPageView:(int)currentIndex;
@end


@interface NPScrollView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) id<NPScrollViewPageDataDelegate> dataDelegate;

- (id)initWithOnePage:(CGRect)frame pageView:(UIView*)pageView;
- (id)initWithTwoPages:(CGRect)frame pageViews:(NSMutableArray*)pageViews startingIndex:(int)startingIndex;
- (id)initWithPageViews:(CGRect)frame pageViews:(NSMutableArray*)pageViews startingIndex:(int)startingIndex;

- (UIView*)activePage;

- (void)changeOrientation;

@end

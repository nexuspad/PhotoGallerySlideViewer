//
//  NPScrollView.m
//  nexusapp
//
//  Created by Ren Liu on 8/17/13.
//
//

#import "NPScrollView.h"

@interface NPScrollView ()
@property BOOL endOfLeft;       // For detecting if it has reached the left end and there is no more page to see. Stop scrolling to left.
@property BOOL endOfRight;      // For detecting if it has reached the right end and there is no more page to see. Stop scrolling to right.
@end

@implementation NPScrollView

@synthesize pageViews = _pageViews, dataDelegate;


- (id)initWithPageViews:(CGRect)frame pageViews:(NSMutableArray*)pageViews startingIndex:(int)startingIndex {
    self = [super initWithFrame:frame];

    if (self) {
        
        [self initCommon];
        
        _pageViews = [NSMutableArray arrayWithArray:pageViews];

        if (startingIndex == 0) {
            self.endOfLeft = YES;
        }
        
        for (UIView *view in _pageViews) {
            [self addSubview:view];
        }

        // Re-center the subviews
        [self reTileAllSubViews];
        
        // Set the offset to display.
        self.contentOffset = CGPointMake(frame.size.width * ([self numberOfPages] - 2), 0);
        
        [self setNeedsDisplay];
    }

    return self;
}

- (id)initWithOnePage:(CGRect)frame pageView:(UIView*)pageView {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initCommon];
        
        _pageViews = [NSMutableArray arrayWithObject:pageView];
        
        self.endOfLeft = YES;
        self.endOfRight = YES;
    
        [self addSubview:pageView];
        
        // Re-center the subviews
        [self reTileAllSubViews];
        
        // Set the offset to display.
        self.contentOffset = CGPointMake(0, 0);        
        [self setNeedsDisplay];
    }
    
    return self;
}

- (id)initWithTwoPages:(CGRect)frame pageViews:(NSMutableArray*)pageViews startingIndex:(int)activeIndex {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initCommon];
        
        _pageViews = [NSMutableArray arrayWithArray:pageViews];
        
        if (activeIndex == 0) {
            self.endOfLeft = YES;
        } else {
            self.endOfRight = YES;
        }
        
        for (UIView *view in _pageViews) {
            [self addSubview:view];
        }
        
        // Re-center the subviews
        [self reTileAllSubViews];
        
        // Set the offset to display.
        if (activeIndex == 0) {
            self.contentOffset = CGPointMake(0, 0);
        } else {
            self.contentOffset = CGPointMake(frame.size.width, 0);
        }
        
        [self setNeedsDisplay];
    }
    
    return self;
}

// Init some common properties.
- (void)initCommon {
    self.delegate = self;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.multipleTouchEnabled = YES;
    self.scrollEnabled = YES;
    self.directionalLockEnabled = YES;
    self.canCancelContentTouches = YES;
    self.delaysContentTouches = YES;
    self.clipsToBounds = YES;
    self.alwaysBounceHorizontal = YES;
    self.bounces = YES;
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = YES;
    
    self.backgroundColor = [UIColor blackColor];
    
    self.endOfLeft = NO;
    self.endOfRight = NO;
}

// The current page that is being shown.
- (UIView*)activePage {
    if (_pageViews.count == 3) {
        return [_pageViews objectAtIndex:1];

    } else if (_pageViews.count == 2) {
        if (self.endOfLeft) {
            return [_pageViews objectAtIndex:0];
        } else if (self.endOfRight) {
            return [_pageViews objectAtIndex:1];
        }

    } else {    // Should cover only one page
        return [_pageViews lastObject];
    }
    return nil;
}


- (void)getPreviousPage {
    if (self.endOfLeft) {
        return;
    }

    NSLog(@"Get previous page...");

    // One view falls off right, but ONLY if there are 3 pages
    if ([self numberOfPages] > 2) {
        [[_pageViews objectAtIndex:2] removeFromSuperview];
        [_pageViews removeLastObject];
    }
    
    // Add a new element to _pageViews
    UIView *firstView = [_pageViews objectAtIndex:0];               // firstView will be the one active
    UIView *newView = [dataDelegate getLeftPageView:firstView.tag]; // Fill the left spot using the view created from delegate
    
    if (newView != nil) {
        [_pageViews insertObject:newView atIndex:0];
        [self insertSubview:newView atIndex:0];
        self.endOfLeft = NO;
        self.endOfRight = NO;
     
        // Re-center the scrollview
        [self reTileAllSubViews];

    } else {
        // No more page on the left, no more scrolling.
        self.endOfLeft = YES;
        self.endOfRight = NO;
    }
}

- (void)getNextPage {
    NSLog(@"Get next page...");

    // One view falls off left, but ONLY when there are 3 pages.
    if ([self numberOfPages] > 2) {
        [[_pageViews objectAtIndex:0] removeFromSuperview];
        [_pageViews removeObjectAtIndex:0];        
    }
    
    // Add a new element to _pageViews
    UIView *lastView = [_pageViews lastObject];                     // lastView will be the one active
    UIView *newView = [dataDelegate getRightPageView:lastView.tag]; // Fill the right spot using the view created from delegate
    
    if (newView != nil) {
        [_pageViews addObject:newView];
        [self addSubview:newView];
        self.endOfLeft = NO;
        self.endOfRight = NO;
    } else {
        self.endOfLeft = NO;
        self.endOfRight = YES;
    }
    
    // Re-center the scrollview
    [self reTileAllSubViews];
}

- (int)numberOfPages {
    return _pageViews.count;
}

- (void)setScrollViewContentSize {
    CGSize contentSize = self.frame.size;
    CGFloat pageWidth = contentSize.width;
    contentSize.width = pageWidth * [self numberOfPages];
    self.contentSize = contentSize;
}

- (void)reTileAllSubViews {
    [self setScrollViewContentSize];

    CGSize pageSize = self.frame.size;

    int i = 0;
    for (UIView *pView in _pageViews) {
        pView.center = CGPointMake((.5+i)*pageSize.width, pageSize.height/2);
        
        CGRect rect = pView.frame;
        rect.origin.y = 0;
        pView.frame = rect;
        
        i++;
    }    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    //Determine if we are on Previous, Current or Next UIView
	CGFloat scrollCommitted = aScrollView.contentOffset.x/self.frame.size.width;

    if ([self numberOfPages] == 3) {
        if (scrollCommitted < 0.5) {
            [self getPreviousPage];
            
        } else if(scrollCommitted > 1.5) {
            [self getNextPage];
        }

        if (self.endOfLeft == NO) {
            CGSize pageSize = self.bounds.size;
            self.contentOffset = CGPointMake(pageSize.width, 0);
            
            [self setNeedsDisplay];
        }

    } else if ([self numberOfPages] == 2) {
        if (scrollCommitted < 0.5) {
            [self getPreviousPage];
            
        } else if(scrollCommitted > 0.5) {
            [self getNextPage];
        }
    }
}

# pragma mark - handle orientation

- (void)changeOrientation {
    [self reTileAllSubViews];
}

@end

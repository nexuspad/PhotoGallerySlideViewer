//
//  LightboxViewDelegate.h
//  PhotoGalerySlideViewer
//
//  Created by Ren Liu on 8/20/13.
//  Copyright (c) 2013 NexusPad. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LightboxViewDelegate <NSObject>

- (id)getPreviousEntry:(int)index;
- (id)getNextEntry:(int)index;

- (id)getEntryAtIndex:(int)index;

@end

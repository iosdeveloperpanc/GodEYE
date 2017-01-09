//
//  PCPersonView.m
//  test
//
//  Created by panchao on 16/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCPersonView.h"
#import "PCPerson.h"

CGFloat personViewDefaultStateSizeWidth = 50;
CGFloat personViewMovingStateSizeWidth = 60;
CGFloat personExtraRadius = 22.0f;

@implementation PCPersonView

- (instancetype)initWithItem:(PCItem *)item {
    if (self = [super initWithItem:item]) {
        self.extraRadius = personExtraRadius;
    }
    return self;
}

- (void)setPanState:(PanGestureState)panState {
    [super setPanState:panState];

    switch (panState) {
        case PanGestureStateEnded:
            self.sizeWidth = personViewDefaultStateSizeWidth;
            break;
        case PanGestureStateMoving:
            self.sizeWidth = personViewMovingStateSizeWidth;
            break;
        default:
            self.sizeWidth = personViewDefaultStateSizeWidth;
            break;
    }
}

@end

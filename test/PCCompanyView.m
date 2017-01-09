//
//  PCCompanyView.m
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCCompanyView.h"

CGFloat companyViewDefaultStateSizeWidth = 80;
CGFloat companyViewMovingStateSizeWidth = 100;
CGFloat companyExtraRadius = 22.0;

@implementation PCCompanyView

- (instancetype)initWithItem:(PCItem *)item {
    if (self = [super initWithItem:item]) {
        self.extraRadius = companyExtraRadius;
    }
    return self;
}

- (void)setPanState:(PanGestureState)panState {
    [super setPanState:panState];

    switch (panState) {
        case PanGestureStateEnded:
            self.sizeWidth = companyViewDefaultStateSizeWidth;
            break;
        case PanGestureStateMoving:
            self.sizeWidth = companyViewMovingStateSizeWidth;
            break;
        default:
            self.sizeWidth = companyViewDefaultStateSizeWidth;
            break;
    }
}

@end

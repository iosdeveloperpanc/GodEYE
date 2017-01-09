//
//  PCRelationShip.m
//  test
//
//  Created by panchao on 17/1/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "PCRelationShip.h"
#import "PCItem.h"

@implementation PCRelationShip

- (instancetype)initWithStartItem:(PCItem *)startItem endItem:(PCItem *)endItem shipName:(NSString *)shipName {
    if (self = [super init]) {
        _startItem = startItem;
        _endItem = endItem;
        _shipName = shipName;

        if (![endItem.superiors containsObject:startItem]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:endItem.superiors];
            [tempArray addObject:startItem];
            endItem.superiors = tempArray;
        }

        if (![startItem.relationSHips containsObject:self]) {
            [startItem.relationSHips addObject:self];
        }
    }
    return self;
}

+ (instancetype)relationShipWithStartItem:(PCItem *)startItem endItem:(PCItem *)endItem shipName:(NSString *)shipName {
    return [[self alloc] initWithStartItem:startItem endItem:endItem shipName:shipName];
}

@end

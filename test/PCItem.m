//
//  PCItem.m
//  test
//
//  Created by panchao on 16/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCItem.h"
#import "PCRelationShip.h"

@implementation PCItem

@synthesize superiors = _superiors;
@synthesize subordinates = _subordinates;
@synthesize relativeItems = _relativeItems;

- (instancetype)initWithUUID:(NSString *)uuid name:(NSString *)name systemAdded:(BOOL)systemAdded{
    if (self = [super init]) {
        _uuid = [uuid copy];
        self.name = [name copy];
        self.systemAdded = systemAdded;
    }
    return self;
}

+ (instancetype)itemWithUUID:(NSString *)uuid name:(NSString *)name systemAdded:(BOOL)systemAdded{
    return [[self alloc] initWithUUID:uuid name:name systemAdded:systemAdded];
}

- (NSMutableArray<PCItem *> *)superiors {
    if (!_superiors) {
        _superiors = [@[self] mutableCopy];
    }
    return _superiors;
}

- (NSMutableArray<PCItem *> *)subordinates {
    if (!_subordinates) {
        _subordinates = [@[self] mutableCopy];
    }
    return _subordinates;
}

- (NSArray<PCItem *> *)relativeItems {
    if (!_relativeItems) {
        NSMutableArray *items = [NSMutableArray array];
        [items addObjectsFromArray:self.superiors];
        [items addObjectsFromArray:self.subordinates];
        _relativeItems = [items copy];
    }
    return _relativeItems;
}

- (NSMutableArray<PCRelationShip *> *)relationSHips {
    if (!_relationSHips) {
        _relationSHips = [NSMutableArray array];
    }
    return _relationSHips;
}

- (void)setSuperiors:(NSMutableArray<PCItem *> *)superiors {

    _superiors = [superiors mutableCopy];

    if (!_superiors) {
        return;
    }

    // 定义上级的时候，那么上级的下级就指定了
    for (PCItem *superior in _superiors) {
        if (![superior.subordinates containsObject:self] && superior != self) {
            [superior.subordinates addObject:self];
        }
    }
}

- (PCItem *)topSuperior {
    // 递归找上级，直到找到boss
    if ([self.superiors isEqual:[@[self] mutableCopy]]) {
        return self;
    } else {
        PCItem *item = self.superiors[0];
        return [item topSuperior];
    }
}

- (BOOL)hasSubordinate {
    return self.subordinates.count;
}

- (BOOL)relativeWithOther:(PCItem *)item {
    return [self.relativeItems containsObject:item];
}

@end

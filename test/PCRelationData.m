//
//  PCRelationData.m
//  test
//
//  Created by panchao on 16/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PCRelationData.h"
#import "PCPerson.h"
#import "PCCompany.h"
#import "PCRelationShip.h"

@implementation PCRelationData

- (NSMutableArray<PCItem *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

+ (instancetype)data {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {

        PCPerson *person1 = [PCPerson itemWithUUID:@"01" name:@"马化腾" systemAdded:YES];
        PCPerson *person2 = [PCPerson itemWithUUID:@"02" name:@"马云" systemAdded:NO];
        PCPerson *person3 = [PCPerson itemWithUUID:@"03" name:@"王健林" systemAdded:NO];
        PCPerson *person4 = [PCPerson itemWithUUID:@"04" name:@"王思聪" systemAdded:NO];
        PCCompany *company1 = [PCCompany itemWithUUID:@"11" name:@"腾讯" systemAdded:NO];
        PCCompany *company2 = [PCCompany itemWithUUID:@"12" name:@"阿里巴巴股份有限公司" systemAdded:NO];
        PCCompany *company3 = [PCCompany itemWithUUID:@"13" name:@"万达" systemAdded:YES];
        PCCompany *company4 = [PCCompany itemWithUUID:@"14" name:@"熊猫TV" systemAdded:NO];

        [PCRelationShip relationShipWithStartItem:person1 endItem:company1 shipName:@"董事"];
        [PCRelationShip relationShipWithStartItem:person2 endItem:person2 shipName:@"董事长"];
        [PCRelationShip relationShipWithStartItem:person3 endItem:person4 shipName:@"父子"];
        [PCRelationShip relationShipWithStartItem:person3 endItem:company3 shipName:@"董事长"];
        [PCRelationShip relationShipWithStartItem:person4 endItem:company3 shipName:@"股东"];
        [PCRelationShip relationShipWithStartItem:person2 endItem:company3 shipName:@"注资"];
        [PCRelationShip relationShipWithStartItem:person4 endItem:company4 shipName:@"总裁"];
        [PCRelationShip relationShipWithStartItem:person2 endItem:company2 shipName:@"超级大BOSS"];

        self.items = [@[person1, person2, person3, person4, company1, company2, company3, company4] mutableCopy];
    }
    return self;
}

- (PCItem *)boss {
    if (!_boss) {
        if (self.items.count) {
            _boss = [self.items[0] topSuperior];
        } else {
            _boss = [PCPerson new];
        }
    }
    return _boss;
}

@end

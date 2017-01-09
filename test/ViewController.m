//
//  ViewController.m
//  test
//
//  Created by panchao on 16/12/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"

#import "PCRelationView.h"
#import "PCRelationData.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PCRelationView *customView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.customView.data = [PCRelationData data];
}

- (IBAction)hiddenRelationShip:(UIBarButtonItem *)sender {
    BOOL hidden = [sender.title isEqualToString:@"隐藏关系"];
    self.customView.hiddenRelationShip = hidden;
    sender.title = hidden ? @"显示关系" : @"隐藏关系";
}

@end

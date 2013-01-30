//
//  ViewController.m
//  HMSegmentedControlExample
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "ViewController.h"
#import "HMSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Library", @"Trending", @"News"]];
    [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorResizesToStringWidth];
    [segmentedControl setFrame:CGRectMake(10, 10, 300, 60)];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTag:1];
	segmentedControl.segmentAtTop = NO;
	segmentedControl.proportionalSegments = YES;
    [segmentedControl setSelectedSegmentIndex:HMSegmentedControlNoSegment];
    [self.view addSubview:segmentedControl];

    HMSegmentedControl *segmentedControl2 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three", @"4", @"Five"]];
	segmentedControl2.segmentAtTop = NO;
    [segmentedControl2 setIndexChangeBlock:^(NSUInteger index) {
        NSLog(@"Selected index %i (via block)", index);
    }];
    
    [segmentedControl2 setSelectionIndicatorHeight:4.0f];
    [segmentedControl2 setBackgroundColor:[UIColor blackColor]];
    [segmentedControl2 setTextColor:[UIColor whiteColor]];
    [segmentedControl2 setSelectionIndicatorColor:[UIColor redColor]];
    [segmentedControl2 setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [segmentedControl2 setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [segmentedControl2 setCenter:CGPointMake(160, 120)];
    [segmentedControl2 setTag:2];
    [self.view addSubview:segmentedControl2];
    
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(10, 200, 300, 50)];
	segmentedControl3.segmentAtTop = NO;
    [segmentedControl3 setSectionTitles:@[@"Worldwide", @"Local", @"Headlines"]];
    [segmentedControl3 setSelectedSegmentIndex:1];
    [segmentedControl3 setBackgroundColor:[UIColor lightGrayColor]];
    [segmentedControl3 setTextColor:[UIColor whiteColor]];
    [segmentedControl3 setSelectionIndicatorColor:[UIColor blackColor]];
    [segmentedControl3 setTag:3];
    [self.view addSubview:segmentedControl3];    

    HMSegmentedControl *segmentedControl4 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Short", @"LongWordyStuffHere", @"Small"]];
    [segmentedControl4 setBackgroundColor:[UIColor lightGrayColor]];
    [segmentedControl4 setSelectionIndicatorMode:HMSelectionIndicatorResizesToStringWidth];
    [segmentedControl4 setFrame:CGRectMake(10, 300, 300, 60)];
    [segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl4 setTag:1];
	segmentedControl4.segmentAtTop = NO;
	segmentedControl4.proportionalSegments = YES;
    [segmentedControl4 setSelectedSegmentIndex:HMSegmentedControlNoSegment];
    [self.view addSubview:segmentedControl4];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	NSLog(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl {
	NSLog(@"Selected index %i", segmentedControl.selectedSegmentIndex);
}

@end

//
//  HMSegmentedControl.m
//  HMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "HMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@interface HMSegmentedControl ()

@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;
@property (nonatomic, strong) NSArray* segmentWidths;
@property (nonatomic, strong) NSArray* segmentOffsets;

@end

@implementation HMSegmentedControl

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setDefaults];
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.sectionTitles = sectiontitles;
        [self setDefaults];
    }
    
    return self;
}

- (void)setDefaults {
    self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = NO;
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    self.selectedSegmentIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.height = 32.0f;
    self.selectionIndicatorHeight = 5.0f;
    self.selectionIndicatorMode = HMSelectionIndicatorResizesToStringWidth;
    
	self.segmentAtTop = YES;
	self.proportionalSegments = NO;
	
    self.selectedSegmentLayer = [CALayer layer];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
// Below is a work in progress for a new style for the selected segment
//    CALayer *selectedSegmentFillerLayer = [[CALayer alloc] init];
//    selectedSegmentFillerLayer.frame = CGRectMake(self.segmentWidth * self.selectedIndex, 0.0, self.segmentWidth, self.frame.size.height);
//    selectedSegmentFillerLayer.opacity = 0.2;
//    selectedSegmentFillerLayer.borderWidth = 1.0f;
//    selectedSegmentFillerLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
//    selectedSegmentFillerLayer.borderColor = self.selectionIndicatorColor.CGColor;
//    [self.layer addSublayer:selectedSegmentFillerLayer];
    
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    [self.textColor set];
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringHeight = [titleString sizeWithFont:self.font].height;
        CGFloat y = ((self.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2);
		CGRect rect;
		if (self.proportionalSegments) {
			NSNumber *segmentWidthNum = [self.segmentWidths objectAtIndex:idx];
			NSNumber *segmentOffsetNum = [self.segmentOffsets objectAtIndex:idx];
			rect = CGRectMake([segmentOffsetNum floatValue], y, [segmentWidthNum floatValue], stringHeight);
		} else {
			rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
		}
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        [titleString drawInRect:rect
                       withFont:self.font
                  lineBreakMode:UILineBreakModeClip
                      alignment:UITextAlignmentCenter];
#else
        [titleString drawInRect:rect
                       withFont:self.font
                  lineBreakMode:NSLineBreakByClipping
                      alignment:NSTextAlignmentCenter];
#endif
        
        self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
        
        if (self.selectedSegmentIndex != HMSegmentedControlNoSegment) {
            self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
            [self.layer addSublayer:self.selectedSegmentLayer];
        }
    }];
}

- (CGRect)frameForSelectionIndicator {
    CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedSegmentIndex] sizeWithFont:self.font].width;
    CGFloat segmentWidth;
    CGFloat segmentOffset;
	if (self.proportionalSegments) {
		NSNumber *segmentWidthNum = [self.segmentWidths objectAtIndex:self.selectedSegmentIndex];
		NSNumber *segmentOffsetNum = [self.segmentOffsets objectAtIndex:self.selectedSegmentIndex];
		segmentWidth = [segmentWidthNum floatValue];
		segmentOffset = [segmentOffsetNum floatValue];
	} else {
		segmentWidth = self.segmentWidth;
		segmentOffset = segmentWidth * self.selectedSegmentIndex;
	}
	
    if (self.selectionIndicatorMode == HMSelectionIndicatorResizesToStringWidth && stringWidth <= segmentWidth) {
        CGFloat widthToEndOfSelectedSegment = segmentOffset + segmentWidth;
        CGFloat widthToStartOfSelectedIndex = segmentOffset;
        
        CGFloat x = ((widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2) + (widthToStartOfSelectedIndex - stringWidth / 2);
        return CGRectMake(x, self.segmentAtTop ? 0.0 : self.bounds.size.height - self.selectionIndicatorHeight,
						  stringWidth, self.selectionIndicatorHeight);
    } else {
        return CGRectMake(segmentOffset,
						  self.segmentAtTop ? 0.0 : self.bounds.size.height - self.selectionIndicatorHeight,
						  segmentWidth, self.selectionIndicatorHeight);
    }
}

- (void)updateSegmentsRects {
	if (self.proportionalSegments) {
		// If there's no frame set, calculate the width of the control based on the number of segments and their size
		NSMutableArray* stringWidths = [NSMutableArray array];
		CGFloat totalStringWidth = 0.0f;
		for (NSString *titleString in self.sectionTitles) {
			CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
			[stringWidths addObject:[NSNumber numberWithFloat:stringWidth]];
			totalStringWidth += stringWidth;
		}
		if (CGRectIsEmpty(self.frame)) {
			NSMutableArray* segmentOffsets = [NSMutableArray array];
			CGFloat offset = 0.0f;
			for (NSNumber* stringWidthNum in stringWidths) {
				[segmentOffsets addObject:[NSNumber numberWithFloat:offset]];
				offset += [stringWidthNum floatValue];
			}
			self.segmentWidths = [NSArray arrayWithArray:stringWidths];
			self.segmentOffsets = [NSArray arrayWithArray:segmentOffsets];
			self.bounds = CGRectMake(0, 0, totalStringWidth, self.height);
		} else {
			NSMutableArray* segmentWidths = [NSMutableArray array];
			NSMutableArray* segmentOffsets = [NSMutableArray array];
			CGFloat wd = self.frame.size.width;
			CGFloat padAvail = wd - totalStringWidth;
			CGFloat factor;
			CGFloat offset;
			if (padAvail >= 0.0f) {
				factor = padAvail / ((2.0f * stringWidths.count) + 2.0f);
				offset = factor;
			} else {
				offset = 2.0f;
				padAvail -= 4.0f;
				factor = padAvail / (2.0f * stringWidths.count);
			}
			for (NSNumber* stringWidthNum in stringWidths) {
				CGFloat segmentWidth = [stringWidthNum floatValue] + (factor * 2.0f);
				[segmentWidths addObject:[NSNumber numberWithFloat:segmentWidth]];
				[segmentOffsets addObject:[NSNumber numberWithFloat:offset]];
				offset += segmentWidth;
			}
			self.segmentWidths = [NSArray arrayWithArray:segmentWidths];
			self.segmentOffsets = [NSArray arrayWithArray:segmentOffsets];
			self.height = self.frame.size.height;
		}
	} else {
		// If there's no frame set, calculate the width of the control based on the number of segments and their size
		if (CGRectIsEmpty(self.frame)) {
			self.segmentWidth = 0;
			
			for (NSString *titleString in self.sectionTitles) {
				CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
				self.segmentWidth = MAX(stringWidth, self.segmentWidth);
			}
			
			self.bounds = CGRectMake(0, 0, self.segmentWidth * self.sectionTitles.count, self.height);
		} else {
			self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
			self.height = self.frame.size.height;
		}
	}
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    [self updateSegmentsRects];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment;
		if (self.proportionalSegments) {
			NSEnumerator* segmentWidthEnum = [self.segmentWidths objectEnumerator];
			NSEnumerator* segmentOffsetEnum = [self.segmentOffsets objectEnumerator];
			NSNumber* segmentWidthNum;
			NSNumber* segmentOffsetNum;
			segment = 0;
			while ((segmentWidthNum = [segmentWidthEnum nextObject]) && (segmentOffsetNum = [segmentOffsetEnum nextObject])) {
				CGFloat segmentWidth = [segmentWidthNum floatValue];
				CGFloat segmentOffset = [segmentOffsetNum floatValue];
				if ((touchLocation.x >= segmentOffset) && (touchLocation.x <= (segmentOffset + segmentWidth))) {
					break;
				}
				segment++;
			}
		} else {
			segment = touchLocation.x / self.segmentWidth;
		}
        
        if (segment != self.selectedSegmentIndex) {
            [self setSelectedSegmentIndex:segment animated:YES];
        }
    }
}

#pragma mark -

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [self setSelectedSegmentIndex:index animated:NO];
}

- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated {
    _selectedSegmentIndex = index;

    if (index == HMSegmentedControlNoSegment) {
        [self.selectedSegmentLayer removeFromSuperlayer];
    } else {
        if (animated) {

            // If the selected segment layer is not added to the super layer, that means no
            // index is currently selected, so add the layer then move it to the new selected
            // segment index without animating.
            if ([self.selectedSegmentLayer superlayer] == nil) {
                [self.layer addSublayer:self.selectedSegmentLayer];
                [self setSelectedSegmentIndex:index animated:NO];
                return;
            }

            // Restore CALayer animations
            self.selectedSegmentLayer.actions = nil;
            
            // Animate to new position
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.15f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [CATransaction setCompletionBlock:^{
                [self notifyForSegmentChangeToIndex:index];
            }];
            self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
            [CATransaction commit];
        } else {
            // Disable CALayer animations
            NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
            self.selectedSegmentLayer.actions = newActions;
            self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
            [self notifyForSegmentChangeToIndex:index];
        }
    }
}

- (void)notifyForSegmentChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

@end

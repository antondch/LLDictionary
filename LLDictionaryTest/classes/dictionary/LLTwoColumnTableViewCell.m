//
//  TwoColumnTableViewCell.m
//  LLDictionaryTest
//
//  Created by jessie on 21.08.15.
//  Copyright (c) 2015 DCH. All rights reserved.
//

#import "LLTwoColumnTableViewCell.h"
@interface LLTwoColumnTableViewCell()
@property (strong, nonatomic) UIView *divider;
@end

@implementation LLTwoColumnTableViewCell
- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)divider {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0/[[UIScreen mainScreen] scale]]];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:view];
    return view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    
    self.divider = [self divider];
    
    self.label1 = [self label];
    self.label2 = [self label];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_label1, _label2, _divider);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label1]-2-[_divider]-2-[_label2(==_label1)]-5-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints];
    return self;
}
@end

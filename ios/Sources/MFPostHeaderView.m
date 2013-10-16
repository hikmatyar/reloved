/* Copyright (c) 2013 Meep Factory OU */

#import "MFPostHeaderView.h"
#import "MFPostHeaderViewDelegate.h"

@implementation MFPostHeaderView

+ (CGFloat)preferredHeight
{
    return 24.0F;
}

@synthesize delegate = m_delegate;

@end

/* Copyright (c) 2013 Meep Factory OU */

#import "MFForm.h"

@interface MFFormFooter : UILabel <MFFormElement>
{
    @private
    UIEdgeInsets m_edgeInsets;
}

+ (CGFloat)preferredHeight;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

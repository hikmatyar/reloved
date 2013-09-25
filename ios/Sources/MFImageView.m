/* Copyright (c) 2013 Meep Factory OU */

#import "MFImageView.h"

@implementation MFImageView

@synthesize URL;

- (NSURL *)URL
{
    return m_url;
}

- (void)setURL:(NSURL *)URL
{
    
}

- (void)loadURL:(NSURL *)URL completed:(MFImageViewCompletedBlock)block
{
}

@end

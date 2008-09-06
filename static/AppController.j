
import <Foundation/CPObject.j>


@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
    
    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    
    [label setStringValue:@"Hello World!"];
    [label setFont:[CPFont boldSystemFontOfSize:24.0]];
    
    [label sizeToFit];
    
    [label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
    [label setFrameOrigin:CGPointMake((CGRectGetWidth([contentView bounds]) - CGRectGetWidth([label frame])) / 2.0, (CGRectGetHeight([contentView bounds]) - CGRectGetHeight([label frame])) / 2.0)];
    
    [contentView addSubview:label];

    var buttonFrame = CGRectMake(CGRectGetWidth([contentView bounds])/2.0 - 40,
				 CGRectGetMaxY([label frame]) + 10,
				 80,18);
    var button = [[CPButton alloc] initWithFrame:buttonFrame];
    [button setAutoresizingMask:CPViewMinXMargin|CPViewMaxXMargin|CPViewMinYMargin|CPViewMaxYMargin];
    [button setTitle:"search"];
    [button setTarget:self];
    [button setAction:@selector(swap:)];
    [contentView addSubview:button];
				     
    
    [theWindow orderFront:self];
    
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end

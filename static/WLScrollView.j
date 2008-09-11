
import <Foundation/CPObject.j>

@implementation WLScrollView : CPScrollView {}

-(void)scrollWheel:(CPEvent)anEvent {
  var scroller = [self verticalScroller];
  var position = [scroller floatValue];
  [self scrollerMovedToPosition:position];
  [super scrollWheel:anEvent];
}

-(void)scrollerMovedToPosition: (float)scrollerPos {
  // Should be overridden by subclasses.
}

@end

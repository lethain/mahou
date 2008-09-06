import <Foundation/CPObject.j>
import <AppKit/CPTextField.j>

@implementation WLURLLabel : CPTextField
{
  CPString url;
}

-(void)mouseDown:(CPEvent)anEvent {
  window.open([self url]);
}

-(void)setUrl: (CPString)aString {
  url = aString;
}

-(CPString)url {
  return url;
}

@end

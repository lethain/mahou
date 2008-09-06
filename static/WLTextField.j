import <Foundation/CPObject.j>
import <AppKit/CPTextField.j>

@implementation WLTextField : CPTextField
{
  CPString placeholderString;
}

-(BOOL)becomeFirstResponder {
  if ([[self stringValue] caseInsensitiveCompare:[self placeholderString]]==0) {
    [self setStringValue:@""];
  }
  return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder {
  if ([[self stringValue] caseInsensitiveCompare:@""]==0) {
    [self setStringValue:[self placeholderString]];
  }
  return [super resignFirstResponder];
}

-(void)setPlaceholderString: (CPString)aString {
  placeholderString = aString;
}

-(CPString)placeholderString {
  return placeholderString;
}


@end

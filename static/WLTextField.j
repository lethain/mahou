import <Foundation/CPObject.j>
import <AppKit/CPTextField.j>

@implementation WLTextField : CPTextField
{
  CPString placeholderString;
}

-(CPString) stringValue {
  var s = [super stringValue];
  if ([s caseInsensitiveCompare:placeholderString]==0) {
    return @"";
  }
  return s;
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

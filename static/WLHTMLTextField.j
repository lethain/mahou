import <Foundation/CPObject.j>
import <AppKit/CPTextField.j>

WLStripHTML = 0,
WLIgnoreHTML = 1,
WLRepresentHTML = 2;
  

@implementation WLHTMLTextField : CPTextField
{
  int _htmlMode;
}

-(void)setHTMLMode: (int)anInt {
  _htmlMode = anInt;
}

-(int)htmlMode {
  if (!_htmlMode) {
    _htmlMode = WLStripHTML;
  }
  return _htmlMode;
}

-(void)setStringValue: (CPString)aString {
  var mode = [self htmlMode];
  if (mode == WLStripHTML) {
    aString = aString.replace(/<\S[^>]*>/g,'');
  }
  [super setStringValue:aString];
}

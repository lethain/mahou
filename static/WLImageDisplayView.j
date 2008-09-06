import <Foundation/CPObject.j>
import "WLURLLabel.j"

@implementation WLImageDisplayView : CPView {
  CPDictionary data;
}

-(id)initWithFrame:aFrame data: (CPDictionary)aDict image: (CPImage)anImage {
  self = [super initWithFrame:aFrame];
  data = aDict;
  
  var imageView  = [[CPImageView alloc] initWithFrame:CGRectMake(0,0,150,150)];
  [imageView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
  [imageView setImageScaling: CPScaleProportionally];
  [imageView setHasShadow:YES];
  [imageView setImage:anImage];


  // height, width, format
  // title, clickurl
  // abstract



  [self addSubview:imageView];
  [self addSubview:[self makeTitleLabel]];
  return self;
}

-(WLURLLabel)makeTitleLabel {
  var fieldFrame = CGRectMake(20,180,200,30);
  var field = [[WLURLLabel alloc] initWithFrame:fieldFrame];

  alert(data.title);
  [field setStringValue:data.title];
  [field setUrl:data.clickurl];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin];
  [field setTextColor:[CPColor whiteColor]];
  //[field sizeToFit];
  return field;
}

@end

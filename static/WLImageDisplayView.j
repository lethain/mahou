import <Foundation/CPObject.j>
import "WLURLLabel.j"

@implementation WLImageDisplayView : CPView {
  CPDictionary data;
  CPImageView imageView;
}

-(id)initWithFrame:aFrame data: (CPDictionary)aDict image: (CPImage)anImage {
  self = [super initWithFrame:aFrame];
  data = aDict;
  var bounds = [self bounds];
  imageView  = [[CPImageView alloc] initWithFrame:CGRectMake(25,0,150,150)];
  [imageView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
  [imageView setImageScaling: CPScaleProportionally];
  [imageView setHasShadow:YES];
  [imageView setImage:anImage];


  // height, width, format
  // abstract
  [self addSubview:[self makeTitleLabel]];
  [self addSubview:imageView];
  [self addSubview:[self makeDimensionsLabel]];
  return self;
}

-(CPTextField)makeAbstractLabel {
  var fieldFrame = CGRectMake(0,190,300,100);
  var field = [[CPTextField alloc] initWithFrame:fieldFrame];
  alert(dict.abstract);
  [field setStringValue:dict.abstract];
  [field setTextColor:[CPColor grayColor]];
  return field;
}

-(WLURLLabel)makeTitleLabel {
  var bounds = [self bounds];
  var fieldFrame = CGRectMake(0,150,300,30);
  var field = [[WLURLLabel alloc] initWithFrame:fieldFrame];

  if (data.title)
    [field setStringValue:data.title];
  else
    [field setStringValue:"untitled image"];

  [field setUrl:data.clickurl];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setTextColor:[CPColor whiteColor]];
  return field;
}

-(CPTextField)makeDimensionsLabel {
  var fieldFrame = CGRectMake(0,170,300,30);
  var string = "dimensions:"+data.width+" by "+data.height+"; format: " + data.format;
  var field = [[CPTextField alloc] initWithFrame:fieldFrame];
  [field setStringValue:string];
  [field setTextColor:[CPColor grayColor]];
  return field;
}

@end

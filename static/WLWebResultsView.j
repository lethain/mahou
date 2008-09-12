import <Foundation/CPObject.j>
import "WLResultsView.j"
import "WLURLLabel.j"
import "WLHTMLTextField.j"

@implementation WLWebResultsView : WLResultsView {  
}

-(CPSize)_minItemSize {
  //return CGSizeMake(CGRectGetWidth([self bounds])-50,100);
  return CGSizeMake(325,100);
}

-(CPSize)_maxItemSize {
  //return CGSizeMake(CGRectGetWidth([self bounds])-50,100);
  return CGSizeMake(1500,100);
}

-(CPCollectionViewItem)_itemPrototype {
  return [[WebCell alloc] init];
}

-(void)_search {
  var query = "/search/web?query="+encodeURIComponent(_searchString)+"&offset="+_offset;
  var request = [CPURLRequest requestWithURL:query];
  var connection = [CPURLConnection connectionWithRequest:request delegate:self];
  [connection start];
}
@end

@implementation WebCell : CPCollectionViewItem {
  CPDictionary dict;
  CPView webView;
}

-(void)setRepresentedObject: (CPDictionary)aDict {
  dict = aDict;

  if (!webView) {
    webView = [[CPView alloc] initWithFrame:CGRectMake(0,0,300,150)];
    [webView setBackgroundColor:[CPColor whiteColor]];
    [webView setAutoresizingMask: CPViewWidthSizable];
    
    var bounds = [webView bounds];
    var frame = CGRectMake(5,0,CPRectGetMaxX(bounds)-5,25);
    var titleLabel = [self makeLabelWith:dict.title at:frame];
    [titleLabel setFont:[CPFont boldSystemFontOfSize:20.0]];
    [titleLabel setAlignment:CPLeftTextAlignment];
    [webView addSubview:titleLabel];
    
    frame = CGRectMake(CPRectGetMaxX(bounds)-50,25,50,25);
    var date = [self makeLabelWith:dict.date at:frame];
    [date setAlignment:CPRightTextAlignment];
    [webView addSubview:date];

    frame = CGRectMake(5,25,CPRectGetWidth(bounds)-75,25);
    var link = [self makeURLLabelWith:dict.url andUrl:dict.clickurl at:frame];
    [link setTextColor:[CPColor blueColor]];
    [webView addSubview:link];

    frame = CGRectMake(0,50,CPRectGetWidth(bounds)-10,75);
    var abstract = [self makeLabelWith:dict.abstract at:frame];
    [abstract setLineBreakMode:CPLineBreakByWordWrapping];
    [webView addSubview:abstract];

    //[webView addSubiew:[self makeURLLabel]];
    //[webView addSubview:[self makeAbstractLabel]];

    [self setView:webView];
  }

}

-(CPTextField)makeLabelWith: (CPString)aString at: (CPRect)aFrame {
  var field = [[WLHTMLTextField alloc] initWithFrame:aFrame];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setStringValue:aString];
  [field setSelectable:YES];
  [field setAutoresizingMask: CPViewWidthSizable];
  return field;
}

-(CPTextField)makeURLLabelWith: (CPString)aString andUrl: (CPString)aURL at: (CPRect)aFrame {
  var field = [[WLURLLabel alloc] initWithFrame:aFrame];
  [field setUrl:aURL];
  [field setSelectable:YES];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setStringValue:aString];
  [field setAutoresizingMask: CPViewWidthSizable];
  return field;
}

@end

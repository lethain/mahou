
import <Foundation/CPObject.j>
import "WLTextField.j"
import "WLURLLabel.j"
import "WLImageResultsView.j"

@implementation AppController : CPObject
{
  WLTextField searchField;
  CPButton button;
  WLImageResultsView imageResultsView;
  CPArray results;
  int offset;
  CPString search;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{

    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
      contentView = [theWindow contentView];
    [contentView setBackgroundColor: [CPColor grayColor]];
    
    var searchFieldFrame = CGRectMake(CGRectGetWidth([contentView bounds])/2.0+20,10,400,34);
    searchField = [[WLTextField alloc] initWithFrame:searchFieldFrame];
    [searchField setPlaceholderString:@"type your search here"];
    [searchField setStringValue:[searchField placeholderString]];
    [searchField setFont:[CPFont boldSystemFontOfSize:24.0]];
    [searchField setEditable:YES];
    [searchField setSelectable:YES];
    [searchField setBordered:YES];
    [searchField setBezeled:YES];
    [searchField setBezelStyle:CPTextFieldRoundedBezel];
    [searchField setBackgroundColor: [CPColor whiteColor]];
    [searchField setAutoresizingMask:CPViewMinXMargin|CPViewMaxXMargin];
    [searchField setFrameOrigin:CGPointMake((CGRectGetWidth([contentView bounds]) - CGRectGetWidth([searchField frame])) / 2.5, (CGRectGetMinY([contentView bounds]) + CGRectGetHeight([searchField frame])))];


    [contentView addSubview:searchField];

    var image = [[CPImage alloc] initWithContentsOfFile:"Resources/searchIcon.png" size:CPSizeMake(64,64)], altImage = [[CPImage alloc] initWithContentsOfFile:"Resources/altSearchIcon.png" size:CPSizeMake(64,64)];

    var buttonFrame = CGRectMake(CGRectGetMaxX([searchField frame])+8,
				 CGRectGetMinY([searchField frame])-16,
				 64,64);
    button = [[CPButton alloc] initWithFrame:buttonFrame];
    [button setImage:image];
    [button setAlternateImage:altImage];
    [button setImagePosition:CPImageOnly];
    [button setAutoresizingMask:CPViewMinXMargin|CPViewMaxXMargin];
    [button setBordered:NO];
    [button setTitle:"search"];
    [button setTarget:self];
    [button setAction:@selector(search:)]; 
    [contentView addSubview:button];

    [self setupPhotosCollectionView:contentView];
    [self setupAttributionLabel:contentView];
    
    
    [theWindow orderFront:self];
    
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void)search:(id)sender {
  offset = 0;
  search = [searchField stringValue];
  [imageResultsView clearResults];
  [self searchYahooImagesFor:search withOffset:offset];
}

-(void)retrieveAdditional {
  offset += 20;
  [self searchYahooImagesFor:search withOffset:offset];
}

-(void)searchYahooImagesFor: (CPString)aString withOffset: (int)aNumber {
  var query = "/search/images?query="+encodeURIComponent(aString)+"&offset="+encodeURIComponent(aNumber);
  var request = [CPURLRequest requestWithURL:query];
  var connection = [CPURLConnection connectionWithRequest:request delegate:self];
  [connection start];
}



-(void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data {
  [imageResultsView setImages:data];
}

- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    alert("error: " + error);
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection {}

/*
-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response {
  alert("response: " + response);
}
*/

-(void)setupAttributionLabel: (CPView)contentView {
  var bounds = [contentView bounds];
  var fieldFrame = CGRectMake(CGRectGetWidth(bounds)/2.0-60,CGRectGetMaxY(bounds)-100,200,30);
  var field = [[WLURLLabel alloc] initWithFrame:fieldFrame];

  [field setStringValue:@"Mahou by Will Larson (http://lethain.com/)"];
  [field setUrl:@"http://lethain.com/"];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin];
  [field setTextColor:[CPColor whiteColor]];
  [field sizeToFit];
  [contentView addSubview:field];
}

-(void)setupPhotosCollectionView: (CPView)contentView {
  var bounds = [contentView bounds];
  var scrollViewFrame = CGRectMake(CGRectGetMinX(bounds)+75,
				   CGRectGetMinY(bounds)+100,
				   CGRectGetWidth(bounds)-150,
				   CGRectGetHeight(bounds)-200);
  imageResultsView = [[WLImageResultsView alloc] initWithFrame:scrollViewFrame];    
  [imageResultsView setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];
  [imageResultsView setAppController:self];
  [contentView addSubview:imageResultsView];
}

@end

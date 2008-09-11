
import <Foundation/CPObject.j>
import "WLTextField.j"

@implementation AppController : CPObject
{
  WLTextField searchField;
  CPButton searchButton;
  CPTabView tabView;
  CPTabViewItem webSearchTabItem;
  CPTabViewItem imageSearchTabItem;
  CPTabViewItem newsSearchTabItem;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
  var contentView = [theWindow contentView];

  [self setupSearchFieldAndButton:contentView];
  [self setupTabView:contentView];
  [theWindow orderFront:self];
  [CPMenu setMenuBarVisible:YES];
}

-(void)setupSearchFieldAndButton: (CPView)contentView {
  

  var bounds = [contentView bounds];
  var searchFrame = CGRectMake(CGRectGetWidth(bounds)/6,
			 CGRectGetMinY(bounds)+15,
			 CGRectGetWidth(bounds)/1.5,
			 70);
  var view = [[CPView alloc] initWithFrame:searchFrame];
  //[view setBackgroundColor:[CPColor shadowColor]]; //lightGray
  [view setAutoresizingMask:CPViewMinXMargin|CPViewMaxXMargin];


  bounds = [view bounds];
  // Create the search field.
  var frame = CGRectMake(CGRectGetMinX(bounds)+10,
			 CGRectGetMinY(bounds)+10,
			 CGRectGetWidth(bounds)-100,
			 CGRectGetMaxY(bounds)-20);
  searchField = [[WLTextField alloc] initWithFrame:frame];
  [searchField setPlaceholderString:@"type your search here"];
  [searchField setStringValue:[searchField placeholderString]];
  [searchField setFont:[CPFont boldSystemFontOfSize:24.0]];
  [searchField setEditable:YES];
  [searchField setSelectable:YES];
  [searchField setBordered:YES];
  [searchField setBackgroundColor: [CPColor whiteColor]];
  [view addSubview:searchField];


  var borderFrame = CGRectMake(CGRectGetMinX(bounds)+9,
			 CGRectGetMinY(bounds)+9,
			 CGRectGetWidth(bounds)-98,
			 CGRectGetMaxY(bounds)-18);
  var borderView = [[CPView alloc] initWithFrame:borderFrame];
  [borderView setBackgroundColor:[CPColor lightGrayColor]];
  [view addSubview:borderView positioned:CPWindowBelow relativeTo:searchField];

  
  var image = [[CPImage alloc] initWithContentsOfFile:"Resources/searchIcon.png" size:CPSizeMake(64,64)], altImage = [[CPImage alloc] initWithContentsOfFile:"Resources/altSearchIcon.png" size:CPSizeMake(64,64)];
  
  var buttonFrame = CGRectMake(CGRectGetMaxX(bounds)-72,
			       CGRectGetMinY(bounds)+3,
			       64,64);
  searchButton = [[CPButton alloc] initWithFrame:buttonFrame];
  [searchButton setImage:image];
  [searchButton setAlternateImage:altImage];
  [searchButton setImagePosition:CPImageOnly];
  [searchButton setAutoresizingMask:CPViewMinXMargin|CPViewMaxXMargin];
  [searchButton setBordered:NO];
  [searchButton setTitle:"search"];
  [searchButton setTarget:self];
  [searchButton setAction:@selector(search:)]; 
  [view addSubview:searchButton];
  
  // Add everything to main content view  
  [contentView addSubview:view];
}

-(void)setupTabView: (CPView)contentView {
  var bounds = [contentView bounds];
  var frame = CGRectMake(CGRectGetMinX(bounds)+75,
			 CGRectGetMinY(bounds)+100,
			 CGRectGetWidth(bounds)-150,
			 CGRectGetHeight(bounds)-200);
  tabView = [[CPTabView alloc] initWithFrame:frame];
  [tabView setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];
  [contentView addSubview:tabView];
}

@end


import <Foundation/CPObject.j>
import "WLTextField.j"
import "WLResultsView.j"
import "WLImageResultsView.j"
import "WLWebResultsView.j"
import "WLNewsResultsView.j"
import "WLURLLabel.j"

@implementation AppController : CPObject
{
  WLTextField searchField;
  CPButton searchButton;
  CPTabView tabView;
  CPTabViewItem webSearchTabItem;
  CPTabViewItem imageSearchTabItem;
  CPTabViewItem newsSearchTabItem;
  CPView webView;
  CPView imageView;
  CPView newsView;
  CPWindow aboutWindow;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  CPLogRegister(CPLogConsole);

  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
  var contentView = [theWindow contentView];

  [self setupSearchFieldAndButton:contentView];
  [self setupTabView:contentView];
  [self setupAboutWindow];
  [theWindow orderFront:self];
  [self setupMainMenu];
  [CPMenu setMenuBarVisible:YES];

}

-(void)search: (id)sender {
  var selectedItem = [tabView selectedTabViewItem];
  var selectedView = [selectedItem view];
  [selectedView searchFor:[searchField stringValue]]; 
}

-(void)tabView:(CPTabView)aTabView didSelectTabViewItem: (CPTabViewItem)anItem {
  if ([[searchField stringValue] length] > 0) {
    [self search:self];
  }
}

-(void)setupMainMenu {
  var m = [[CPMenu alloc] initWithTitle:@"MainMenu"];
  [[CPApplication sharedApplication] setMainMenu:m];
  

  // Web Menu
  var webMenuItem = [[CPMenuItem alloc] initWithTitle:@"Web" action:@selector(doNothing:) keyEquivalent:@"W"];
  [m addItem:webMenuItem];


  var imageMenuItem = [[CPMenuItem alloc] initWithTitle:@"Image" action:@selector(doNothing:) keyEquivalent:@"I"];
  [m addItem:imageMenuItem];


  var newsMenuItem = [[CPMenuItem alloc] initWithTitle:@"News" action:@selector(doNothing:) keyEquivalent:@"N"];
  [m addItem:newsMenuItem];


  [m addItem:[CPMenuItem separatorItem]];
  var aboutMenuItem = [[CPMenuItem alloc] initWithTitle:@"About" action:@selector(toggleAboutWindow:) keyEquivalent:@"A"];
        
  [m addItem:aboutMenuItem];

  
}

-(void)doNothing:(id)sender {
  alert("blah");
}

-(void)toggleAboutWindow:(id)sender {
  if ([aboutWindow isVisible]==YES) {
    [aboutWindow orderOut:self];
  }
  else {
    [aboutWindow orderFront:self];
  }
}

-(void)setupAboutWindow {
  

  //var mainWindow = [[CPApplication sharedApplication] mainWindow];
  //var bounds = [mainWindow bounds];

  var frame = CGRectMake(150,150,300,200);
  var aboutWindow = [[CPWindow alloc] initWithContentRect:frame styleMask:CPClosableWindowMask|CPTitledWindowMask|CPHUDBackgroundWindowMask];
  [aboutWindow setTitle:@"About Mahou"];
  

  var contentView = [aboutWindow contentView];
  
  
  var titleLabel = [self makeURLLabelWith:@"Will Larson (http://lethain.com/)" andUrl:@"http://lethain.com/" at:CPRectMake(0,0,300,30)];
  [titleLabel setTextColor:[CPColor lightGrayColor]];
  [titleLabel setFont:[CPFont boldSystemFontOfSize:16.0]];
  [titleLabel setAlignment:CPCenterTextAlignment];
  [contentView addSubview:titleLabel];

  var uLabel = [self makeLabelWith:@"Made using"  at:CPRectMake(0,30,300,30)];
  [uLabel setTextColor:[CPColor whiteColor]];
  [uLabel setFont:[CPFont boldSystemFontOfSize:16.0]];
  [uLabel setAlignment:CPCenterTextAlignment];
  [contentView addSubview:uLabel];


  var cLabel = [self makeURLLabelWith:@"Cappuccino" andUrl:@"http://cappuccino.org/" at:CPRectMake(0,60,300,30)];
  [cLabel setTextColor:[CPColor blueColor]];
  [cLabel setFont:[CPFont boldSystemFontOfSize:16.0]];
  [cLabel setAlignment:CPCenterTextAlignment];
  [contentView addSubview:cLabel];

  var yLabel = [self makeURLLabelWith:@"Yahoo! BOSS" andUrl:@"http://developer.yahoo.com/search/boss/" at:CPRectMake(0,90,300,30)];
  [yLabel setTextColor:[CPColor blueColor]];
  [yLabel setFont:[CPFont boldSystemFontOfSize:16.0]];
  [yLabel setAlignment:CPCenterTextAlignment];
  [contentView addSubview:yLabel];

  var gLabel = [self makeURLLabelWith:@"Google App Engine" andUrl:@"http://code.google.com/appengine/" at:CPRectMake(0,120,300,30)];
  [gLabel setTextColor:[CPColor blueColor]];
  [gLabel setFont:[CPFont boldSystemFontOfSize:16.0]];
  [gLabel setAlignment:CPCenterTextAlignment];
  [contentView addSubview:gLabel];
}

-(CPTextField)makeLabelWith: (CPString)aString at: (CPRect)aFrame {
  var field = [[WLHTMLTextField alloc] initWithFrame:aFrame];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setStringValue:aString];
  [field setAutoresizingMask: CPViewWidthSizable];
  return field;
}

-(CPTextField)makeURLLabelWith: (CPString)aString andUrl: (CPString)aURL at: (CPRect)aFrame {
  var field = [[WLURLLabel alloc] initWithFrame:aFrame];
  [field setUrl:aURL];
  [field setFont:[CPFont boldSystemFontOfSize:12.0]];
  [field setStringValue:aString];
  [field setAutoresizingMask: CPViewWidthSizable];
  return field;
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
  [tabView setTabViewType:CPTopTabsBezelBorder];

  [contentView addSubview:tabView];
  //[tabView layoutSubviews];
  [tabView setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];

  webSearchTabItem = [[CPTabViewItem alloc] initWithIdentifier:@"web"];
  imageSearchTabItem = [[CPTabViewItem alloc] initWithIdentifier:@"image"];
  newsSearchTabItem = [[CPTabViewItem alloc] initWithIdentifier:@"news"];

  webView = [[WLWebResultsView alloc] initWithFrame:frame];
  imageView = [[WLImageResultsView alloc] initWithFrame:frame];
  newsView = [[WLNewsResultsView alloc] initWithFrame:frame];

  [webSearchTabItem setLabel:@"Web"];
  [imageSearchTabItem setLabel:@"Image"];
  [newsSearchTabItem setLabel:@"News"];

  [webSearchTabItem setView:webView];
  [imageSearchTabItem setView:imageView];
  [newsSearchTabItem setView:newsView];

  [tabView addTabViewItem:webSearchTabItem];
  [tabView addTabViewItem:imageSearchTabItem];
  [tabView addTabViewItem:newsSearchTabItem];

  //[tabView selectTabViewItem:imageSearchTabItem];
  [tabView setDelegate:self];
}

@end

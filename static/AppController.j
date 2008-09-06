
import <Foundation/CPObject.j>
import "WLTextField.j"


@implementation AppController : CPObject
{
  WLTextField searchField;
  CPButton button;
  CPCollectionView photosCollectionView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
      contentView = [theWindow contentView];
    [contentView setBackgroundColor: [CPColor grayColor]];
    
    var searchFieldFrame = CGRectMake(CGRectGetWidth([contentView bounds])/2.0+40,10,400,34);
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
    [button setAction:@selector(swap:)]; 
    [contentView addSubview:button];

    [self setupPhotosCollectionView:contentView];
    
    [theWindow orderFront:self];
    
    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

-(void)setupPhotosCollectionView: (CPView)contentView {
  var bounds = [contentView bounds];

  var photoItem = [[CPCollectionViewItem alloc] init];
  [photoItem setView:[[CPImageView alloc] initWithFrame:CGRectMake(0,0,150,150)]];
  

  //[searchField setFrameOrigin:CGPointMake((CGRectGetWidth([contentView bounds]) - CGRectGetWidth([searchField frame])) / 2.5, (CGRectGetMinY([contentView bounds]) + CGRectGetHeight([searchField frame])))];

  //var searchFieldFrame = CGRectMake(CGRectGetWidth([contentView bounds])/2.0+40,10,400,34);


  var scrollViewFrame = CGRectMake(CGRectGetMinX(bounds)+75,
				   CGRectGetMinY(bounds)+100,
				   CGRectGetWidth(bounds)-150,
				   350);

  var scrollView = [[CPScrollView alloc] initWithFrame:scrollViewFrame];  
  photosCollectionView = [[CPCollectionView alloc] initWithFrame:CGRectMakeZero()];
  [photosCollectionView setDelegate:self];
  [photosCollectionView setItemPrototype:photoItem];

  [photosCollectionView setMinItemSize:CGSizeMake(150, 150)];
  [photosCollectionView setMaxItemSize:CGSizeMake(150, 150)];
  [photosCollectionView setAutoresizingMask: CPViewWidthSizable];
    
  [scrollView setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];
  //[searchField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
  [scrollView setDocumentView: photosCollectionView];
  [scrollView setAutohidesScrollers: YES];

  [[scrollView contentView] setBackgroundColor:[CPColor blackColor]];

  [contentView addSubview:scrollView];
}



- (void)swap:(id)sender
{

}

@end

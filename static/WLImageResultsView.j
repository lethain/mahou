import <Foundation/CPObject.j>
import "WLResultsView.j"
import "WLImageDisplayView.j"

@implementation WLImageResultsView : WLResultsView {
  
}

-(CPSize)_minItemSize {
  return CGSizeMake(150,150);
}

-(CPSize)_maxItemSize {
  return CGSizeMake(150,150);
}

-(CPCollectionViewItem)_itemPrototype {
  return [[PhotoCell alloc] init];
}

-(void)_search {
  var query = "/search/images?query="+encodeURIComponent(_searchString)+"&offset="+_offset+"&count="+[self count];
  var request = [CPURLRequest requestWithURL:query];
  var connection = [CPURLConnection connectionWithRequest:request delegate:self];
  [connection start];
}

@end



@implementation PhotoCell : CPCollectionViewItem {
  CPImage image;
  CPImageView imageView;
  CPDictionary dict;
}

-(void)setRepresentedObject: (CPDictionary)aDict {
  dict = aDict;
  if (!imageView) {
    imageView = [[CPImageView alloc] initWithFrame:CGRectMake(0,0,150,150)];
    [imageView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
    [imageView setImageScaling: CPScaleProportionally];
    [imageView setHasShadow:YES];
    [self setView:imageView];
  }

  if (image)
    [image setDelegate:nil];

  image = [[CPImage alloc] initWithContentsOfFile:dict.thumbnail_url];
  [image setDelegate:self];
  if([image loadStatus] == CPImageLoadStatusCompleted)
    [imageView setImage: image];
  else
    [imageView setImage: nil];
}

- (void)imageDidLoad:(CPImage)anImage {
  [imageView setImage: anImage];
}

-(void)setSelected:(BOOL)flag {
  if (!flag) return;
  
  //var view = [[imageView superview] superview];
  //var bounds = [view bounds];
  var mainWindow = [[CPApplication sharedApplication] mainWindow];
  var point = [imageView convertRect:[imageView bounds] toView:[mainWindow contentView]];


  var window = [[CPPanel alloc] initWithContentRect:CGRectMake(CGRectGetMinX(point),CGRectGetMinY(point),300,300) styleMask:CPHUDBackgroundWindowMask|CPClosableWindowMask];
  var contentView = [window contentView];

  var aView = [[WLImageDisplayView alloc] initWithFrame:CGRectMake(0,0,300,300) data:dict image:image];
  [[window contentView] addSubview:aView];
  [window orderFront:self];
}

@end



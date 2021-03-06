import <Foundation/CPObject.j>
import "AppController.j"
import "WLImageDisplayView.j"

@implementation WLImageResultsView : CPScrollView {
  CPCollectionView collectionView;
  CPArray images;
  AppController appController;
  BOOL recievedAdditional;
}

-(id)initWithFrame:aFrame {
  self = [super initWithFrame:aFrame];
  var photoItem = [[PhotoCell alloc] init];
  collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
  [collectionView setDelegate:self];
  [collectionView setItemPrototype:photoItem];
  [collectionView setMinItemSize:CGSizeMake(150, 150)];
  [collectionView setMaxItemSize:CGSizeMake(150, 150)];
  [collectionView setAutoresizingMask: CPViewWidthSizable];
  [self setDocumentView:collectionView];
  [self setAutohidesScrollers:YES];
  [self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.4 alpha:1.0]];
  return self;
}

-(void)setAppController: (AppController)appCont {
  appController = appCont;
}
-(AppController)appController {
  return appController;
}

-(void)scrollWheel:(CPEvent)anEvent {
  [self considerNotifying];
  [super scrollWheel:anEvent];
}

-(void)considerNotifying {
  var scroller = [self verticalScroller];
  var position = [scroller floatValue];
  if (position > .8 && recievedAdditional) {
    [[self appController] retrieveAdditional];
    recievedAdditional = NO;
    
  }
}

-(void)clearResults {
  images = [[CPArray alloc] init];
}

-(void)setImages: (CPArray)anArray {
  var recievedAdditional = YES;
  var newResults = eval(anArray);
  [images addObjectsFromArray:newResults];
  [collectionView setContent:[]];
  [collectionView setContent:images];
}
-(CPArray)images {
  return images;
}

-(void)mouseDown(CPEvent)anEvent {
  alert("mouse down!");
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

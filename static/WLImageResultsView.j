import <Foundation/CPObject.j>

@implementation WLImageResultsView : CPScrollView {
  CPCollectionView collectionView;
  CPArray images;
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

-(void)setImages: (CPArray)anArray {
  images = eval(anArray);
  [collectionView setContent:images];
}
-(CPArray)images {
  return images;
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
  alert("selected!");
}

@end
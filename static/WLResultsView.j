import <Foundation/CPObject.j>
import "WLScrollView.j"

@implementation WLResultsView : WLScrollView {
  CPArray _results;
  CPString _searchString;
  CPCollectionView _collectionView;
  int _offset;
  int _count;
  BOOL _countChanged;
  BOOL _recieved;
}

-(id)initWithFrame:aFrame {
  self = [super initWithFrame:aFrame];
  [self createCollectionView];
  [self setAutohidesScrollers:YES];
  _count = 20;
  _countChanged = NO;
  return self;
}

-(void)createCollectionView {
  var bounds = [self bounds];
  var aFrame = CPRectMake(0,0,
		      CGRectGetWidth(bounds)-20,CGRectGetHeight(bounds));
  
  _collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
  [_collectionView setDelegate:self];
  [_collectionView setItemPrototype:[self _itemPrototype]];
  [_collectionView setMinItemSize:[self _minItemSize]];
  [_collectionView setMaxItemSize:[self _maxItemSize]];
  [_collectionView setAutoresizingMask: CPViewWidthSizable];
  [self setDocumentView:_collectionView];
}

-(CPSize)_minItemSize {
  return CGSizeMake(150,150);
}

-(CPSize)_maxItemSize {
  return CGSizeMake(150,150);
}

-(CPCollectionViewItem)_itemPrototype {
  // implement in subclass
}

-(void)searchFor: (CPString)searchString {
  if (!_countChanged && [_searchString caseInsensitiveCompare:searchString]==0) {
    // Don't re-search already search results.
    return;
  }
  else _countChanged = NO;

  [self _clearResults];
  _searchString = searchString;
  _offset = 0;
  [self _search];
}

-(int)_offsetIncrement {
  return 20;
}

-(void)_clearResults {
  //[self createCollectionView];
  _results = [[CPArray alloc] init];
}

-(void)_setResults: (CPArray)anArray {
  [_results addObjectsFromArray:anArray];
  [self _resultsUpdated];
  _recieved = YES;
}

-(void)scrollerMovedToPosition: (float)scrollerPos {
  if (scrollerPos > 0.8 && _recieved != NO) {
    _recieved = NO;
    [self _search];
  }
}

-(void)_resultsUpdated {
  [_collectionView setContent:[]];
  //[self createCollectionView];
  [_collectionView setContent:_results];
}

-(void)_search {
  _offset = _offset + [self _offsetIncrement];
}

-(void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data {
  [self _setResults:eval(data)];
}
- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
    //alert("error: " + error);
}

-(void)connectionDidFinishLoading:(CPURLConnection)connection {
  // finished
}

-(void)setCount: (int)anInt {
  _countChanged = YES;
  _count = anInt;
}

-(void)count {
  return _count;
}

@end

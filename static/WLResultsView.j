import <Foundation/CPObject.j>
import "WLScrollView.j"

@implementation WLResultsView : WLScrollView {
  CPArray _results;
  CPString _searchString;
  CPCollectionView _collectionView;
  int _offset;
  BOOL _recieved;
}

-(id)initWithFrame:aFrame {
  self = [super initWithFrame:aFrame];
  _collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
  [_collectionView setDelegate:self];
  [_collectionView setItemPrototype:[self _itemPrototype]];
  [_collectionView setMinItemSize:[self _minItemSize]];
  [_collectionView setMaxItemSize:[self _maxItemSize]];
  [_collectionView setAutoresizingMask: CPViewWidthSizable];
  [self setDocumentView:_collectionView];
  [self setAutohidesScrollers:YES];
  return self;
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
  [self _clearResults];
  _searchString = searchString;
  _offset = 0;
  [self _search];
  _offset = _offset + [self _offsetIncrement];
}

-(int)_offsetIncrement {
  return 20;
}

-(void)_clearResults {
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
  // override.
}

-(void)_search {
  // perform search, update with _setResults method.
}

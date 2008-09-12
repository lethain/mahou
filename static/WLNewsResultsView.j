import <Foundation/CPObject.j>
import "WLResultsView.j"
import "WLURLLabel.j"
import "WLHTMLTextField.j"
import "WLWebResultsView.j"

@implementation WLNewsResultsView : WLResultsView {  
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
  var query = "/search/news?query="+encodeURIComponent(_searchString)+"&offset="+_offset+"&count="+_count;
  var request = [CPURLRequest requestWithURL:query];
  var connection = [CPURLConnection connectionWithRequest:request delegate:self];
  [connection start];
}
@end

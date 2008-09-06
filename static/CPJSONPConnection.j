
import <Foundation/CPObject.j>

CPJSONPConnectionCallbacks = {};

@implementation CPJSONPConnection : CPObject
{
    CPURLRequest    _request;
    id              _delegate;
    
    CPString        _callbackParameter;
    DOMElement      _scriptTag;
}

+ (CPData)sendRequest:(CPURLRequest)aRequest callback:(CPString)callbackParameter delegate:(id)aDelegate 
{
    return [[[self class] alloc] initWithRequest:aRequest callback:callbackParameter delegate:aDelegate startImmediately:YES];;
}

- (id)initWithRequest:(CPURLRequest)aRequest callback:(CPString)aString delegate:(id)aDelegate 
{
    return [self initWithRequest:aRequest callback:aString delegate:aDelegate startImmediately: NO];
}

- (id)initWithRequest:(CPURLRequest)aRequest callback:(CPString)aString delegate:(id)aDelegate startImmediately:(BOOL)shouldStartImmediately
{
    self = [super init];
    
    _request = aRequest;
    _delegate = aDelegate;
    
    _callbackParameter = aString;
    
    CPJSONPConnectionCallbacks["callback"+[self hash]] = function(data)
    {
        [_delegate connection:self didReceiveData:data];
        [self removeScriptTag];
    };

    if(shouldStartImmediately)
        [self start];
        
    return self;
}

- (void)start
{
    try
    {
        var head = document.getElementsByTagName("head").item(0);
        
        var source = [_request URL];    
        source += (source.indexOf('?') < 0) ? "?" : "&";
        source += _callbackParameter+"=CPJSONPConnectionCallbacks.callback"+[self hash];

        _scriptTag = document.createElement("script");
        _scriptTag.setAttribute("type", "text/javascript");
        _scriptTag.setAttribute("charset", "utf-8");
        _scriptTag.setAttribute("src", source);
        
        head.appendChild(_scriptTag);
    }
    catch (exception)
    {
        [_delegate connection: self didFailWithError: exception];
        [self removeScriptTag];
    }
}

- (void)removeScriptTag
{
    var head = document.getElementsByTagName("head").item(0);
    
    if(_scriptTag.parentNode == head)
        head.removeChild(_scriptTag);

    CPJSONPConnectionCallbacks["callback"+[self hash]] = nil;
    delete CPJSONPConnectionCallbacks["callback"+[self hash]];
}

- (void)cancel
{
    [self removeScriptTag];
}

@end
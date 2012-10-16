//
//  Created by happy_ryo on 2012/10/15.
//  Copyright 2012 happy_ryo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import "UIAsyncImageView.h"


@implementation UIAsyncImageView

-(void)loadImage:(NSString *)url{
    [self abort];
    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    data = [[NSMutableData alloc] initWithCapacity:0];

    NSURLRequest *req = [NSURLRequest
            requestWithURL:[NSURL URLWithString:url]
               cachePolicy:NSURLRequestUseProtocolCachePolicy
           timeoutInterval:30.0];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)nsdata{
    [data appendData:nsdata];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self abort];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.image = [UIImage imageWithData:data];
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight;
    [self abort];
}

-(void)abort{
    if(conn != nil){
        [conn cancel];
        conn = nil;
    }
    if(data != nil){
        data = nil;
    }
}

- (void)dealloc {
    [conn cancel];
}
@end
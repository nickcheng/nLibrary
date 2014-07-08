//
//  NSArray+nLibrary.m
//  nLibrary
//
//  Created by nickcheng on 13-8-21.
//  Copyright (c) 2013年 nx. All rights reserved.
//

#import "NSArray+nLibrary.h"

@implementation NSArray (nLibrary)

- (NSString *)jsonString {
  NSError *error = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
  if (error != nil) {
    DDLogError(@"Convert array to JSONString failed! Array:%@ Error:%@", self, error);
    return nil;
  }
  
  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  return jsonString;
}

@end

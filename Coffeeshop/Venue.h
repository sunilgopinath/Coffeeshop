//
//  Venue.h
//  Coffeeshop
//
//  Created by Sunil Gopinath on 11/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;


@end

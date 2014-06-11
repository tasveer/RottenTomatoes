//
//  Movie.m
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/6/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.posterImages = dictionary[@"posters"];
        self.synopsis = dictionary[@"synopsis"];
        self.rating = dictionary[@"mpaa_rating"];
        
        // Get the cast list
        self.castList = @"";
        NSArray  *cast = dictionary[@"abridged_cast"];
        
        for (NSDictionary *castInfo in cast) {
            self.castList = [ self.castList stringByAppendingFormat:@", %@", castInfo[@"name"]];
        }

    }
    
    return self;
}

+ (NSArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    
    return movies;
}

@end

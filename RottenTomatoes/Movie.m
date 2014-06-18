//
//  Movie.m
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/6/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import "Movie.h"

@implementation Movie


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"title",
             @"synopsis": @"synopsis",
             @"rating": @"mpaa_rating",
             @"posterImages": @"posters",
             @"castList": @"abridged_cast",
             };
}

// Modified touse Mantle to convert json data into Movie objects

+ (NSValueTransformer *)castListJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *castings) {
        NSMutableString* combinedCast;
        NSLog(@"castings: %@", castings);
        for (NSDictionary *castInfo in castings) {
            NSLog(@"castInfo: %@", castInfo[@"name"]);
            if ([ combinedCast length])
            {
                combinedCast = [ combinedCast stringByAppendingFormat:@", %@", castInfo[@"name"]];
            }
            else {
                combinedCast = castInfo[@"name"];
            }
        }

        NSLog(@"combined cast: %@", combinedCast);
        return combinedCast;
    }];
}


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
    NSError *error = nil;
    for (NSDictionary *dictionary in array) {
        Movie *movie = [MTLJSONAdapter modelOfClass: Movie.class fromJSONDictionary: dictionary error: &error];
        //Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        NSLog(@"Created movie: %@ :  cast: %@ rating %@ poster images %@ synopsis %@ ", [movie title], [movie castList], [movie rating], [movie posterImages], [movie synopsis]);
        [movies addObject:movie];
    }
    
    return movies;
}

@end

//
//  Movie.h
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/6/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>


@interface Movie : MTLModel <MTLJSONSerializing>

@property (nonatomic, weak) NSString *title;
@property (nonatomic, weak) NSString *synopsis;
@property (nonatomic, weak) NSDictionary *posterImages;
@property (nonatomic, weak) NSString *castList;
@property (nonatomic, weak) NSString *rating;


- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithArray:(NSArray *)array;


@end

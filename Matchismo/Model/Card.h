//
//  Card.h
//  Matchismo
//
//  Created by Yan Zverev on 12/14/14.
//  Copyright (c) 2014 Yan Zverev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic,strong) NSString *contents;
@property (nonatomic,getter=isChosen) BOOL chosen;
@property (nonatomic,getter=isMatched) BOOL matched;
@property (nonatomic,strong) NSString *matchResult;

-(int)match:(NSArray *)otherCards;

@end

//
//  Card.m
//  Matchismo
//
//  Created by Yan Zverev on 12/14/14.
//  Copyright (c) 2014 Yan Zverev. All rights reserved.
//

#import "Card.h"

@implementation Card

-(NSString *)matchHistory
{
    if (!_matchResult) {
        _matchResult = [[NSString alloc] init];
    }
    return _matchResult;
}


-(int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards){
        if([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    return score;
}




@end

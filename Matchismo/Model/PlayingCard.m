//
//  PlayingCard.m
//  Matchismo
//
//  Created by Yan Zverev on 12/14/14.
//  Copyright (c) 2014 Yan Zverev. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard


@synthesize suit = _suit;






+(NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

-(void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

-(NSString *)suit
{
    return _suit ? _suit :@"?";
}

-(void)setRank:(NSUInteger)rank
{
    if(rank <=[PlayingCard maxRank]){
        _rank = rank;
    }
}

-(NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}


-(int)match:(NSArray *)otherCards
{
    int score = 0;
    for (PlayingCard *otherCard in otherCards){
        if ([self.suit isEqualToString:otherCard.suit]) {
            score += 1;
            self.matchResult = [NSString stringWithFormat:@"%@ matched %@ for 1 point",self.contents, otherCard.contents];
        } else if(self.rank == otherCard.rank) {
            score += 4;
            self.matchResult = [NSString stringWithFormat:@"%@ matched %@ for 4 point",self.contents, otherCard.contents];
        }
    }
    
    return score;
}

+(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}


+(NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}



@end

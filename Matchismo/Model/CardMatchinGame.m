//
//  CardMatchinGame.m
//  Matchismo
//
//  Created by Yan Zverev on 12/14/14.
//  Copyright (c) 2014 Yan Zverev. All rights reserved.
//

#import "CardMatchinGame.h"

@interface CardMatchinGame()

@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic) NSUInteger gameType;
@property (nonatomic, strong) NSMutableArray *gameHistory;
@property (nonatomic,readwrite) NSUInteger gameHistoryIndex;

@end

@implementation CardMatchinGame


#pragma mark lazy instantiation

-(NSUInteger)gameHistoryIndex
{
    return [self.gameHistory count];
}
-(NSMutableArray *)gameHistory
{
    if (!_gameHistory) {
        _gameHistory = [[NSMutableArray alloc]init];
    }
    return _gameHistory;
}
-(NSUInteger)gameType
{
    if (!_gameType) {
        _gameType = 2;
    }
    return _gameType;
}

-(NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}


#pragma mark init

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck gameType:(NSUInteger)gameType
{
    self = [self initWithCardCount:count usingDeck:deck];
    
    if (self) {
        _gameType = gameType;
    }
    
    return self;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        _gameHistoryIndex = 0;
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }else{
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(void)matchCards:(NSMutableArray *)cards
{
    
    NSUInteger matchScore = 0;
    BOOL matched = NO;
    NSMutableArray *matchHistory = [[NSMutableArray alloc]init];
    NSMutableArray *cardsToMatch = [cards mutableCopy];
    
    for (int i = 0; i < self.gameType-1; i++) {
        Card *card = [cardsToMatch firstObject];
        [cardsToMatch removeObjectAtIndex:0];
        matchScore += [card match:cardsToMatch];
        if (matchScore) {
            matched = YES;
            if (card.matchResult) {
                [matchHistory addObject:card.matchResult]; // collecting all the match results into an array
            }
        }
    }
    if (matched) {
        self.score +=matchScore * MATCH_BONUS;
        for (Card *card in cards){
            card.matched = YES;
            card.chosen = YES;
            [self.gameHistory addObject:matchHistory]; // adding array of match results into game history
        }
    }else{
        NSMutableString *mismatchHistory = [[NSMutableString alloc]init];
        for (Card *card in cards){
            card.chosen = NO;
            [mismatchHistory appendString:card.contents];
        }
        self.score -= MISMATCH_PENALTY;
        [mismatchHistory appendString:[NSString stringWithFormat:@" don't match! %d point penalty!",MISMATCH_PENALTY]];
        [self.gameHistory addObject:@[mismatchHistory]];
    }
    
   
}


-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *chosenCards = [[NSMutableArray alloc]init];
    
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }else{
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
        
        for (Card *otherCard in self.cards){
            if(otherCard.isChosen && !otherCard.isMatched){
                [chosenCards addObject:otherCard];
            }
        }
        if ([chosenCards count] == self.gameType) {
            //if we have enough cards to match for the gametype when perform match
            [self matchCards:chosenCards];
        }else if (![chosenCards count]){
            [self.gameHistory addObject:@[@"No Cards Chosen"]];
        }else {
            __block NSMutableString *chosenCardsHistory = [[NSMutableString alloc]init];
            [chosenCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Card *card = (Card *)obj;
                [chosenCardsHistory appendString:card.contents];
            }];
            [self.gameHistory addObject:@[chosenCardsHistory]];
        }
        card.chosen = YES; //to leave the last chosen card upside.  
    }
    
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(NSArray *)gameHistoryAtIndex:(NSUInteger)index
{
    
    return  index <= self.gameHistoryIndex ? [self.gameHistory objectAtIndex:index] : nil;
}

-(NSArray *)lastMatchGameHistory
{
    return [self.gameHistory lastObject];
}

@end

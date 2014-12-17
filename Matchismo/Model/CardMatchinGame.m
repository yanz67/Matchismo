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

@end

@implementation CardMatchinGame

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
    NSMutableArray *cardsToMatch = [cards mutableCopy];
    if ([cards count] == self.gameType) {
        for (int i = 0; i < self.gameType-1; i++) {
            Card *card = [cardsToMatch firstObject];
            [cardsToMatch removeObjectAtIndex:0];
            matchScore += [card match:cardsToMatch];
            if (matchScore) {
                matched = YES;
            }
        }
        if (matched) {
            self.score +=matchScore * MATCH_BONUS;
            for (Card *card in cards){
                card.matched = YES;
                card.chosen = YES;
            }
        }else{
            for (Card *card in cards){
                    card.chosen = NO;
                    self.score -= MISMATCH_PENALTY;

            }
        }
        
    }

    
}


-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *chosenCards = [[NSMutableArray alloc]init];
    [chosenCards addObject:card];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }else{
            for (Card *otherCard in self.cards){
                if(otherCard.isChosen && !otherCard.isMatched){
                    [chosenCards addObject:otherCard];
                    [self matchCards:chosenCards];
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end

//
//  CardMatchinGame.h
//  Matchismo
//
//  Created by Yan Zverev on 12/14/14.
//  Copyright (c) 2014 Yan Zverev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchinGame : NSObject


//designated initilalizer
-(instancetype) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck gameType:(NSUInteger)gameType;



-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index;


@property (nonatomic, readonly) NSInteger score;


@end

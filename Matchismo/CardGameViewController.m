//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Yan Zverev on 12/14/14.
//  Copyright (c) 2014 Yan Zverev. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchinGame.h"
#import "PlayingCard.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) CardMatchinGame *game;

@end

@implementation CardGameViewController



-(CardMatchinGame *)game
{
    if(!_game){
        _game = [[CardMatchinGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] gameType:3];
    }
    return _game;
}



-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc]init];
}


-(void)updateUI
{
    for (UIButton *cardButton in self.cardButtons){
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];
}


-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
    
}

-(UIImage *)backgroundImageForCard:(Card *)card 
{
    return [UIImage imageNamed:card.isChosen ? @"" : @"stanford"];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (IBAction)redealGame:(UIButton *)sender
{
    self.game = nil;
    [self updateUI];
}

@end

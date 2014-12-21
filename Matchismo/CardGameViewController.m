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

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *gameHistoryLabel;

@property (weak, nonatomic) IBOutlet UISlider *gameHistorySlider;

@end

@implementation CardGameViewController


- (IBAction)chooseGameType:(UISegmentedControl *)sender
{
    self.game = nil;
}

-(CardMatchinGame *)game
{
    if(!_game){
        _game = [[CardMatchinGame alloc]initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] gameType:self.gameTypeSegmentedControl.selectedSegmentIndex+2];
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
    NSArray *lastMatchHistory = [self.game lastMatchGameHistory];
    if ([lastMatchHistory count] > 1) {
        self.gameHistoryLabel.text = [lastMatchHistory componentsJoinedByString:@" \n "];
    }else if ([lastMatchHistory count] == 1){
        NSLog(@"not joined %@",[lastMatchHistory firstObject]);
        if ([[lastMatchHistory lastObject] isKindOfClass:[NSString class]]) {
            self.gameHistoryLabel.text = [lastMatchHistory lastObject];
        }
    }
    if (self.game.gameHistoryIndex >= 1) {
        self.gameHistorySlider.enabled = YES;
        self.gameHistorySlider.minimumValue = 1;
        self.gameHistorySlider.maximumValue = self.game.gameHistoryIndex;
        self.gameHistorySlider.value = self.game.gameHistoryIndex;
    }else{
        self.gameHistorySlider.minimumValue = 0;
        self.gameHistorySlider.maximumValue = 0;
        self.gameHistorySlider.enabled = NO;
    }
    self.gameHistoryLabel.alpha = 1.0;
    
}

- (IBAction)gameHistoryChanged:(UISlider *)sender
{
    if (sender.value != 0) {
        NSArray *gameHistoryAtIndex = [self.game gameHistoryAtIndex:sender.value-1];
        if ([gameHistoryAtIndex count] == 1) {
            self.gameHistoryLabel.text = [gameHistoryAtIndex firstObject];    }
        else{
            self.gameHistoryLabel.text = [gameHistoryAtIndex componentsJoinedByString:@" \n "];
        }
        self.gameHistoryLabel.alpha = 0.7;
    }
    
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
    self.gameTypeSegmentedControl.enabled = NO;
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (IBAction)redealGame:(UIButton *)sender
{
    self.game = nil;
    self.gameTypeSegmentedControl.enabled = YES;
    self.gameHistoryLabel.text = @"";
    [self updateUI];
    
}

@end

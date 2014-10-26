//
//  MineSweeperCell.m
//  MineSweeper
//
//  Created by Yang Su on 10/25/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "MineSweeperCell.h"

#import "MineSweeperGameManager.h"

@interface MineSweeperCell()

@property (nonatomic, readwrite, assign) int row;
@property (nonatomic, readwrite, assign) int column;
@property (nonatomic, readwrite, strong) id<MineSweeperCellDelegate> delegate;
@property (nonatomic, readwrite, strong) SKLabelNode *label;

@end

@implementation MineSweeperCell

- (id)initWithRow:(int)row column:(int)column delegate:(id<MineSweeperCellDelegate>)delegate {
    if (self = [super initWithColor:MINESWEEPER_CELL_COLOR_HIDDEN size:CGSizeMake(MINESWEEPER_CELL_SIZE, MINESWEEPER_CELL_SIZE)]){
        _delegate = delegate;
        MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
        _row = row;
        _column = column;
        self.userInteractionEnabled = YES;
        int numMines = [manager numMinesAroundCellAtRow:row column:column];
        BOOL hasMine = [manager doesMineExistAtRow:row column:column];
        NSString *text = hasMine ? @"M" :[NSString stringWithFormat:@"%i", numMines];
        _label = [SKLabelNode labelNodeWithText:text];
        _label.hidden = YES;
        _label.position = CGPointMake(self.position.x, self.position.y - _label.frame.size.height/2.0);
        [self addChild:_label];
        
    }
    return self;
}

- (BOOL)hasMine {
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    return [manager doesMineExistAtRow:self.row column:self.column];
}

- (void)refresh {
    if (!self.tapped){
        if (self.cheating && [self hasMine]){
            self.label.hidden = NO;
            self.color = MINESWEEPER_CELL_COLOR_BOMB;
        }
        else {
            self.color = MINESWEEPER_CELL_COLOR_HIDDEN;
            self.label.hidden = YES;
        }
    }
    else {
        self.label.hidden = NO;
        if ([self hasMine]){
            self.color = MINESWEEPER_CELL_COLOR_BOMB;
        }
        else {
            self.color = MINESWEEPER_CELL_COLOR_REVEALED;
        }
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate didTapCellAtRow:self.row column:self.column];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end

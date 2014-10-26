//
//  MineSweeperCell.h
//  MineSweeper
//
//  Created by Yang Su on 10/25/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define MINESWEEPER_CELL_SIZE 40
#define MINESWEEPER_CELL_PADDING 10
#define MINESWEEPER_CELL_COLOR_HIDDEN [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]
#define MINESWEEPER_CELL_COLOR_REVEALED [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]
#define MINESWEEPER_CELL_COLOR_BOMB [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0]

@protocol MineSweeperCellDelegate

- (void)didTapCellAtRow:(int)row column:(int)column;

@end

@interface MineSweeperCell : SKSpriteNode

@property (nonatomic, readonly, assign) int row;
@property (nonatomic, readonly, assign) int column;
@property (nonatomic, readwrite, assign) BOOL tapped;
@property (nonatomic, readwrite, assign) BOOL cheating;

- (id)initWithRow:(int)row column:(int)column delegate:(id<MineSweeperCellDelegate>)delegate;

- (void)refresh;

@end
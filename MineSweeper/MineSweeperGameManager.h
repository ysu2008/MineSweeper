//
//  MineSweeperGameManager.h
//  MineSweeper
//
//  Created by Yang Su on 10/25/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineSweeperGameManager : NSObject

@property (nonatomic, readonly, assign) int numRows;
@property (nonatomic, readonly, assign) int numColumns;
@property (nonatomic, readonly, assign) int numMines;

+ (MineSweeperGameManager *)sharedManager;

- (void)newGameWithNumRows:(int)numRows
                numColumns:(int)numColumns
                  numMines:(int)numMines;

- (BOOL)doesMineExistAtRow:(int)row column:(int)column;

- (int)numMinesAroundCellAtRow:(int)row column:(int)column;

@end

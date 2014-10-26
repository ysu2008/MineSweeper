//
//  MineSweeperGameManager.m
//  MineSweeper
//
//  Created by Yang Su on 10/25/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "MineSweeperGameManager.h"

static MineSweeperGameManager *staticGameManager = nil;

@interface MineSweeperGameManager()

@property (nonatomic, readwrite, assign) int numRows;
@property (nonatomic, readwrite, assign) int numColumns;
@property (nonatomic, readwrite, assign) int numMines;
@property (nonatomic, readwrite, strong) NSMutableArray *gameBoard;

@end

@implementation MineSweeperGameManager

+ (MineSweeperGameManager *)sharedManager {
    if (!staticGameManager){
        staticGameManager = [[MineSweeperGameManager alloc] init];
    }
    return staticGameManager;
}

- (void)newGameWithNumRows:(int)numRows
                numColumns:(int)numColumns
                  numMines:(int)numMines {
    _numColumns = numColumns;
    _numRows = numRows;
    _numMines = numMines;
    
    //set up game board
    _gameBoard = [NSMutableArray array];
    
    for (int i = 0; i < numRows; i++){
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < numColumns; j++){
            [row addObject:[NSNumber numberWithBool:NO]];
        }
        [_gameBoard addObject:row];
    }
    
    //randomly assign mines with fisher yates shuffle
    int selectionArray[numRows * numColumns];
    for (int i = 0; i < numRows * numColumns; i++){
        selectionArray[i] = i;
    }
    
    for (int i = numRows *numColumns - 1; i >= 0; --i) {
        int r = arc4random_uniform(numRows * numColumns);
        int temp = selectionArray[i];
        selectionArray[i] = selectionArray[r];
        selectionArray[r] = temp;
    }
    
    //now first numMines values will have mines
    for (int i = 0; i < numMines; i++){
        int cellWithMine = selectionArray[i];
        int row = (int)floor((double)cellWithMine / (double)numRows);
        int column = cellWithMine % numRows;
        _gameBoard[row][column] = [NSNumber numberWithBool:YES];
    }
}

- (BOOL)doesMineExistAtRow:(int)row column:(int)column {
    return [(self.gameBoard[row][column]) boolValue];
}

- (int)numMinesAroundCellAtRow:(int)row column:(int)column {
    int numMines = [self.gameBoard[row][column] boolValue];
    
    if (row < self.numRows - 1){
        numMines += ([(self.gameBoard[row+1][column]) boolValue] ? 1 : 0);
    }
    if (row > 0){
        numMines += ([(self.gameBoard[row-1][column]) boolValue] ? 1 : 0);
    }
    if (column < self.numColumns - 1){
        numMines += ([(self.gameBoard[row][column+1]) boolValue] ? 1 : 0);
    }
    if (column > 0){
        numMines += ([(self.gameBoard[row][column-1]) boolValue] ? 1 : 0);
    }
    if (row < self.numRows - 1 && column < self.numColumns - 1){
        numMines += ([(self.gameBoard[row+1][column+1]) boolValue] ? 1 : 0);
    }
    if (row > 0 && column > 0){
        numMines += ([(self.gameBoard[row-1][column-1]) boolValue] ? 1 : 0);
    }
    if (row < self.numRows - 1 && column > 0){
        numMines += ([(self.gameBoard[row+1][column-1]) boolValue] ? 1 : 0);
    }
    if (row > 0 && column < self.numColumns - 1){
        numMines += ([(self.gameBoard[row-1][column+1]) boolValue] ? 1 : 0);
    }
    
    return numMines;
}

@end

//
//  MineSweeperScene.m
//  MineSweeper
//
//  Created by Yang Su on 10/25/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "MineSweeperScene.h"

#import "Config.h"
#import "MineSweeperGameManager.h"

#define MINESWEEPER_RESTART_BUTTON_COLOR [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]
#define MINESWEEPER_RESTART_BUTTON_SIZE CGSizeMake(150,50)
#define MINESWEEPER_RESTART_BUTTON_NAME @"restart_button"

#define MINESWEEPER_CHEAT_BUTTON_NAME @"cheat_button"

#define MINESWEEPER_VALIDATE_BUTTON_NAME @"validate_button"

#define MINESWEEPER_ENDGAME_ANIMATION_FORCE 1000
#define MINESWEEPER_ENDGAME_LABEL_FONT_SIZE 60

#define MINESWEEPER_RESTART_BUTTON_OFFSET_X 260
#define MINESWEEPER_RESTART_BUTTON_OFFSET_Y 80

@interface MineSweeperScene()

@property (nonatomic, readwrite, strong) NSMutableArray *cells;
@property (nonatomic, readwrite, assign) BOOL cheating;
@property (nonatomic, readwrite, strong) SKLabelNode *cheatLabel;

@end

@implementation MineSweeperScene

- (void)createMineSweeperSceneWithRows:(int)rows columns:(int)cols {
    _cells = [NSMutableArray array];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    //add button that restarts the game.
    SKSpriteNode *restartButton = [[SKSpriteNode alloc] initWithColor:MINESWEEPER_RESTART_BUTTON_COLOR
                                                                 size:MINESWEEPER_RESTART_BUTTON_SIZE];
    restartButton.name = MINESWEEPER_RESTART_BUTTON_NAME;
    restartButton.position = CGPointMake(center.x - MINESWEEPER_RESTART_BUTTON_OFFSET_X,
                                         center.y + (MINESWEEPER_CELL_SIZE + MINESWEEPER_CELL_PADDING) * (float)(cols)/2.0 + MINESWEEPER_RESTART_BUTTON_OFFSET_Y);
    [self addChild:restartButton];
    SKLabelNode *restartButtonLabel = [SKLabelNode labelNodeWithText:@"Play Again"];
    restartButtonLabel.position = CGPointMake(restartButton.position.x, restartButton.position.y - 10);
    [self addChild:restartButtonLabel];
    
    //add cheat button
    SKSpriteNode *cheatButton = [[SKSpriteNode alloc] initWithColor:MINESWEEPER_RESTART_BUTTON_COLOR
                                                               size:MINESWEEPER_RESTART_BUTTON_SIZE];
    cheatButton.name = MINESWEEPER_CHEAT_BUTTON_NAME;
    cheatButton.position = CGPointMake(center.x + MINESWEEPER_RESTART_BUTTON_OFFSET_X,
                                       center.y + (MINESWEEPER_CELL_SIZE + MINESWEEPER_CELL_PADDING) * (float)(cols)/2.0 + MINESWEEPER_RESTART_BUTTON_OFFSET_Y);
    [self addChild:cheatButton];
    _cheating = NO;
    _cheatLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Cheat:%@", self.cheating ? @"On" : @"Off"]];
    _cheatLabel.position = CGPointMake(cheatButton.position.x, cheatButton.position.y - 10);
    [self addChild:_cheatLabel];
    
    //add validate button
    SKSpriteNode *validateButton = [[SKSpriteNode alloc] initWithColor:MINESWEEPER_RESTART_BUTTON_COLOR
                                                                 size:MINESWEEPER_RESTART_BUTTON_SIZE];
    validateButton.name = MINESWEEPER_VALIDATE_BUTTON_NAME;
    validateButton.position = CGPointMake(center.x,
                                          center.y + (MINESWEEPER_CELL_SIZE + MINESWEEPER_CELL_PADDING) * (float)(cols)/2.0 + MINESWEEPER_RESTART_BUTTON_OFFSET_Y);
    [self addChild:validateButton];
    SKLabelNode *validateButtonLabel = [SKLabelNode labelNodeWithText:@"Validate"];
    validateButtonLabel.position = CGPointMake(validateButton.position.x, validateButton.position.y - 10);
    [self addChild:validateButtonLabel];
    
    //add all minesweeper cells
    for (int i = 0; i < rows; i++){
        NSMutableArray *row = [NSMutableArray array];
        for (int j = 0; j < cols; j++){
            
            MineSweeperCell *cell = [[MineSweeperCell alloc] initWithRow:i column:j delegate:self];
            cell.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cell.size];
            cell.physicsBody.dynamic = YES;
            cell.physicsBody.affectedByGravity = NO;
            cell.anchorPoint = CGPointMake(0.5, 0.5);
            cell.position = CGPointMake(center.x + (i - (float)(rows - 1)/2.0) * (MINESWEEPER_CELL_SIZE + MINESWEEPER_CELL_PADDING),
                                        center.y + (j - (float)(cols - 1)/2.0) * (MINESWEEPER_CELL_SIZE + MINESWEEPER_CELL_PADDING));
            [self addChild:cell];
            [row addObject:cell];
        }
        [_cells addObject:row];
    }
}

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [UIColor blackColor];
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    [self createMineSweeperSceneWithRows:manager.numRows columns:manager.numColumns];
}

- (BOOL)hasWon {
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    for (int i = 0; i < manager.numRows; i++){
        for (int j = 0; j < manager.numColumns; j++){
            MineSweeperCell *cell = self.cells[i][j];
            if (!cell.tapped && ![manager doesMineExistAtRow:i column:j]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)startNewGame {
    [self removeAllChildren];
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    [manager newGameWithNumRows:MINESWEEPER_CONFIG_ROWS
                     numColumns:MINESWEEPER_CONFIG_COLUMNS
                       numMines:MINESWEEPER_CONFIG_NUM_MINES];
    [self createMineSweeperSceneWithRows:manager.numRows columns:manager.numColumns];
}

- (void)toggleCheat {
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    self.cheating = !self.cheating;
    _cheatLabel.text = [NSString stringWithFormat:@"Cheat:%@", self.cheating ? @"On" : @"Off"];
    for (int i = 0; i < manager.numRows; i++){
        for (int j = 0; j < manager.numColumns; j++){
            MineSweeperCell *cell = self.cells[i][j];
            cell.cheating = self.cheating;
            [cell refresh];
        }
    }
}

- (void)playEndAnimationWithResult:(BOOL)hasWon {
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    for (int i = 0; i < manager.numRows; i++){
        for (int j = 0; j < manager.numColumns; j++){
            MineSweeperCell *cell = self.cells[i][j];
            cell.physicsBody.affectedByGravity = YES;
            [cell.physicsBody applyForce:CGVectorMake(((float)i - (float)(manager.numRows - 1)/2.0)*MINESWEEPER_ENDGAME_ANIMATION_FORCE,
                                                      ((float)j - (float)(manager.numColumns - 1)/2.0)*MINESWEEPER_ENDGAME_ANIMATION_FORCE)];
        }
    }
    SKLabelNode *label = hasWon ? [SKLabelNode labelNodeWithText:@"You Win!"] : [SKLabelNode labelNodeWithText:@"You Lose"];
    label.fontSize = MINESWEEPER_ENDGAME_LABEL_FONT_SIZE;
    CGPoint center = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
    label.position = center;
    [self addChild:label];
}

#pragma mark - Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:location];
    
    for (SKNode *node in nodes){
        if ([node.name isEqualToString:MINESWEEPER_RESTART_BUTTON_NAME]) {
            [self startNewGame];
            return;
        }
        else if ([node.name isEqualToString:MINESWEEPER_CHEAT_BUTTON_NAME]) {
            [self toggleCheat];
            return;
        }
        else if ([node.name isEqualToString:MINESWEEPER_VALIDATE_BUTTON_NAME]) {
            [self playEndAnimationWithResult:[self hasWon]];
            return;
        }
    }
}

#pragma mark - MineSweeperCellDelegate methods

- (void)didTapCellAtRow:(int)row column:(int)column {
    MineSweeperGameManager *manager = [MineSweeperGameManager sharedManager];
    
    if ([manager doesMineExistAtRow:row column:column]){
        //hit a mine
        [self playEndAnimationWithResult:NO];
    }
    
    //floodfill from tapped cell
    NSMutableArray *stack = [NSMutableArray array];
    [stack addObject:(self.cells[row][column])];
    
    while ([stack count]){
        MineSweeperCell *currentCell = [stack lastObject];
        [stack removeLastObject];
        if (!currentCell.tapped){
            currentCell.tapped = YES;
            [currentCell refresh];
            
            int currentRow = currentCell.row;
            int currentColumn = currentCell.column;
            
            if ([manager numMinesAroundCellAtRow:currentRow column:currentColumn] == 0) {
                //add neighbors and repeat process
                
                if (currentRow > 0) [stack addObject:self.cells[currentRow-1][currentColumn]];
                if (currentRow + 1 < manager.numRows) [stack addObject:self.cells[currentRow+1][currentColumn]];
                if (currentColumn > 0) [stack addObject:self.cells[currentRow][currentColumn-1]];
                if (currentColumn + 1 < manager.numColumns) [stack addObject:self.cells[currentRow][currentColumn+1]];
                if (currentRow > 0 && currentColumn > 0) [stack addObject:self.cells[currentRow-1][currentColumn-1]];
                if (currentRow + 1 < manager.numRows && currentColumn + 1 < manager.numColumns) [stack addObject:self.cells[currentRow+1][currentColumn+1]];
                if (currentRow + 1 < manager.numRows && currentColumn > 0) [stack addObject:self.cells[currentRow+1][currentColumn-1]];
                if (currentRow > 0 && currentColumn + 1 < manager.numColumns) [stack addObject:self.cells[currentRow-1][currentColumn+1]];
            }
        }
    }
}

@end

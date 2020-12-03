#include <bits/stdc++.h>
 
using namespace std;

int main(){
   
    int boardSize, players, snakes, ladders, dice; 
    cin >> boardSize >> players >> snakes;

    int board [boardSize*boardSize+2];
    int winners[players];
    int positions[players];
    int snakeHead[snakes];
    int snakeTail[snakes];

    while (snakes > 0){
        int x,y,xf,yf;
        
        cin >> x >> y >> xf >> yf;

        snakeHead[snakes] = x + y - 1;
        snakeTail[snakes] = xf + yf - 1;
        
        snakes--;
    }

    cin >> ladders;
    int ladderHead[ladders];
    int ladderTail[ladders];

    while (ladders > 0){
        int x,y,xf,yf; 
        cin >> x >> y >> xf >> yf;

        ladderHead[snakes] = x + y - 1;
        ladderTail[snakes] = xf + yf - 1;

        ladders--;
    }

    cin >> dice;
    int player = 0;

    while (dice > 0){
        if (player >= players)
            player = 0;
        else
            player += 1;

        int move, d2;
        bool moved = false;
        cin >> move >> d2;
        move += d2;

        for (int i = 0 ; i < sizeof(winners)/sizeof(*winners) ; i++){
            if (winners[i] == 1){
                if (player == i){
                    if (player >= players)
                        player = 0;
                    else
                        player += 1;
                }
            }
            else if (positions[i] >= boardSize*boardSize+2)
                winners[i] = 1;
        }

        for (int i = 0 ; i < sizeof(snakeHead)/sizeof(*snakeHead) ; i++){
            if (snakeHead[i] == positions[player] + move){
                positions[player] = snakeTail[i];
                move = true;
                break;
            }
        } 
        
        for (int i = 0 ; i < sizeof(ladderTail)/sizeof(*ladderTail) ; i++){
            if (ladderTail[i] == positions[player] + move){
                positions[player] = ladderHead[i];
                move = true;
                break;
            }
        }

        if (!moved)
            positions[player] += move;            

        dice--;
    }

    for (int i = 0 ; i < sizeof(winners)/sizeof(*winners) ; i++){
        if (winners[i] == 1)
            cout << i+1 << " winner" << endl;
    }   
}
public class PegSolitaireBoard {
    private Peg[][] board;
    public Turn turn;
    private int selectedX, selectedY;

    public enum Turn {
        MOVEMENT,
        SELECTION
    }

    public PegSolitaireBoard(String type) {
        board = new Peg[7][7];
        for(int i = 0; i<7;i++){
            for(int j = 0; j<7; j++){
                board[i][j] = new Peg(i, j);
            }
        }
        board[3][3].setIsGone(true);

        if(type.equals("ENGLISH")){
            for(int i = 0; i<2; i++){
                for(int j = 0; j<2; j++){
                    board[i][j].setIsPiece(false);
                    board[i][6-j].setIsPiece(false);
                    board[6-i][j].setIsPiece(false);
                    board[6-i][6-j].setIsPiece(false);
                }
            }
        }
        else if(type.equals("EUROPEAN")){
            for(int i = 0; i<2; i++){
                board[i][0].setIsPiece(false);
                board[i][6].setIsPiece(false);
                board[6-i][0].setIsPiece(false);
                board[6-i][6].setIsPiece(false);
            }
            board[0][1].setIsPiece(false);
            board[0][5].setIsPiece(false);
            board[6][1].setIsPiece(false);
            board[6][5].setIsPiece(false);
        }

        turn = Turn.MOVEMENT;
    }

    @Override
    public String toString() {
        String res="";
        for(int i = 0; i<7;i++){
            for(int j = 0; j<7; j++){
                res+=board[j][i].toString();
            }
            res+="\n";
        }
        return res;
    }

    public void MovePiece(int xCord, int yCord, int xDest, int yDest) {
        if(IsMoveViable(xCord, yCord, xDest, yDest)) {
            board[(xCord+xDest)/2][(yCord+yDest)/2].setIsGone(true);
            board[xCord][yCord].setIsGone(true);
            board[xDest][yDest].setIsGone(false);
            IsGameOver();
        }
        turn = Turn.MOVEMENT;
    }

    public boolean IsMoveViable(int xCord, int yCord, int xDest, int yDest){
        if(xDest < 0 || xDest > 6 || yDest < 0 || yDest > 6) return false;
        if(!board[xDest][yDest].getIsPiece()) return false;
        else if(!board[xDest][yDest].getIsGone()) return false;
        else if(!(Math.abs(xDest-xCord) == 2 && Math.abs(yDest-yCord) == 0) && !(Math.abs(xDest-xCord) == 0 && Math.abs(yDest-yCord) == 2)) return false;
        else if(board[(xCord+xDest)/2][(yCord+yDest)/2].getIsGone()) return false;
        else return true;
    }



    public boolean IsGameOver() {
        for(int i = 0; i < 7; i++) {
            for(int j = 0; j < 7; j++) {
                if(IsMoveViable(board[i][j].xCord, board[i][j].yCord, board[i][j].xCord+2, board[i][j].yCord)) return false;
                if(IsMoveViable(board[i][j].xCord, board[i][j].yCord, board[i][j].xCord-2, board[i][j].yCord)) return false;
                if(IsMoveViable(board[i][j].xCord, board[i][j].yCord, board[i][j].xCord, board[i][j].yCord+2)) return false;
                if(IsMoveViable(board[i][j].xCord, board[i][j].yCord, board[i][j].xCord, board[i][j].yCord-2)) return false;
            }
        }
        return true;
    }

    public boolean isFilled(int i, int j) {
        return !board[i][j].getIsGone();
    }

    public void Select(int i, int j){
        selectedX = i;
        selectedY = j;
        turn = Turn.SELECTION;
    }

    public boolean IsSelected(int i, int j){
        return (i==selectedX)&&(j==selectedY);
    }

    public int getSelectedX(){return selectedX;}

    public int getSelectedY(){return selectedY;}

    public boolean IsPiece(int i, int j){
        return board[i][j].getIsPiece();
    }

    public int HowManyPieces(){
        int x = 0;
        for(int i = 0; i<7;i++){
            for(int j = 0; j<7; j++){
                if(board[i][j].getIsPiece() && !board[i][j].getIsGone()) x++;
            }
        }
        return x;
    }


}
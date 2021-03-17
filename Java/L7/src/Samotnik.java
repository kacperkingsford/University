public class Samotnik {

    private static Samotnik INSTANCE;
    public PegSolitaireBoard board;
    private String gameVersion;
    private int xSelected, ySelected;

    private Samotnik(){
        gameVersion = "ENGLISH";
    }

    public static Samotnik getInstance(){
        if(INSTANCE == null){
            INSTANCE = new Samotnik();
        }
        return INSTANCE;
    }

    public void newGame(){
        board = new PegSolitaireBoard(gameVersion);
    }

    public String getVersion(){
        return gameVersion;
    }

    public void setVersion(String version){
        gameVersion = version;
    }

    public boolean isGameOver(){
        return board.IsGameOver();
    }

    public int getHowManyPieces(){
        return board.HowManyPieces();
    }

    public void MovePiece(int xCord, int yCord, int xDest, int yDest){
        board.MovePiece(xCord, yCord, xDest, yDest);
    }

    public void setxSelected(int x){
        xSelected = x;
    }

    public void setySelected(int y){
        ySelected = y;
    }

    public int getxSelected(){return xSelected;}
    public int getySelected(){return ySelected;}

}
public class Peg {
    private boolean isGone;
    public int xCord, yCord;
    private boolean isPiece;

    public Peg(int x, int y){
        isGone = false;
        isPiece = true;
        xCord = x;
        yCord = y;
    }

    public void setIsGone(boolean b){
        isGone = b;
    }

    public boolean getIsGone(){
        return isGone;
    }

    public void setIsPiece(boolean b){
        isPiece = b;
    }

    public boolean getIsPiece(){
        return isPiece;
    }

    @Override
    public String toString() {
        if(!isPiece) return "-";
        else if(isGone) return "0";
        else return "1";
    }
}
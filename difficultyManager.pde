static class DifficultyManager{
    
    private Difficulty diff;
    private static DifficultyManager self = null; 

    private DifficultyManager(Difficulty diff){
        this.diff = diff;
    }

    public static DifficultyManager getInstance(Difficulty diff){
        if(DifficultyManager.self == null){
            DifficultyManager.self = new DifficultyManager(diff);
        }
        return DifficultyManager.self;
    }

    public int getTilesCount(){
        return (this.diff.ordinal() + 1) * 5;
    }
}
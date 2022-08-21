import Time "mo:base/Time";

module {
    public type Card = {
        data : Text; 
    };

    public type Game = {
        list_choice : [Choice]; //[id choice]
        score : Nat; //luot chon
        time_play : Time.Time;
    };

    public type Choice = {
        id_card_1 : Text;
        id_card_2 : Text;
    };

    public type Error = {
        #NotFound;
    }
}
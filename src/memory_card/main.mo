import Result "mo:base/Result";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import TrieMap "mo:base/TrieMap";

import State "../memory_card_models/State";
import Types "../memory_card_models/Types";

//UUID
import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";

actor {

  var state : State.State = State.empty();

  //create id
  public func createId(): async Text {
    let g = Source.Source();
    UUID.toText(await g.new());
  };

  //CARD
  //create Card
  public func createCard(data: Text) : async Result.Result<(),()>{
    var id : Text = await createId();

    while (state.cards.get(id) != null){ //check id
      var id = await createId();
    };

    let new_card : Types.Card = {
      data = data;
    };

    let create_card = state.cards.put(id, new_card);
    #ok();
  };

  //init data
  public func initDataCard() : async Result.Result<(),()>{
    ignore await clearData();
    ignore await createCard("1");
    ignore await createCard("1");
    ignore await createCard("2");
    ignore await createCard("2");
    ignore await createCard("3");
    ignore await createCard("3");
    ignore await createCard("4");
    ignore await createCard("4");
    ignore await createCard("5");
    ignore await createCard("5");
    ignore await createCard("6");
    ignore await createCard("6");
    #ok();
  };

  //clear data
  public func clearData() : async Result.Result<(),()>{
    state := State.empty();
    #ok();
  };

  //list card
  public func listCard() : async [(Text, Types.Card)] {
    var list_cards : [(Text, Types.Card)] = [];
    for ((k, v) in state.cards.entries()){
      list_cards := Array.append<(Text, Types.Card)>(list_cards, [(k,v)])
    };
    return list_cards;
  };

  //read data card
  public func readCard(id_card: Text) : async ?Types.Card {
    return state.cards.get(id_card);
  };

  //GAME
  public func createGame(time_start : Time.Time, time_complete: Time.Time) : async Result.Result<(), ()> { //after check goal true
    var id : Text = await createId();
    while (state.games.get(id) != null) {
      var id : Text = await createId();
    };
    let list_choice : [Types.Choice] = await listChoice();
    let score : Nat = await countChoice();
    let new_game : Types.Game = {
      list_choice = list_choice;
      score = score;
      time_play = (time_complete-time_start)/1_000_000_000; //time is seconds 
    };
    let create_game = state.games.put(id, new_game);
    let clear_choice = await clearChoice();
    #ok();
  };

  //read game
  public func readGame(id_game: Text) : async Result.Result<Types.Game, Types.Error>{
    let game : ?Types.Game = state.games.get(id_game);
    switch (game) {
      case null #err(#NotFound);
      case (?value){
        #ok(value);
      };
    };
  };
  

  //list game
  public func listGame(): async [(Text, Types.Game)] { 
    var list_game : [(Text, Types.Game)] = [];
    for ((k, val) in state.games.entries()){
      list_game := Array.append<(Text, Types.Game)>(list_game, [(k, val)]);
    };
    return list_game;
  };

  //CHOICE
  //create choice 
  public func createChoice(id_card_1: Text, id_card_2: Text) : async Result.Result<(),()>{
    var id : Text = await createId();
    while (state.choices.get(id) != null) {
      var id : Text = await createId();
    };
    let new_choice : Types.Choice = {
      id_card_1 = id_card_1;
      id_card_2 = id_card_2;
    };
    let create_choice = state.choices.put(id, new_choice);
    #ok();
  };

  //list choice
  public func listChoice() : async [Types.Choice] {
    var list_choice : [Types.Choice] = [];
    for (val in state.choices.vals()) {
      list_choice := Array.append<Types.Choice>(list_choice, [val]);
    };
    return list_choice;
  };

  //list choice of GAME
  public func listChoiceOfGame(id_game: Text): async [Text] {
    var list_choice_types : [Types.Choice] = [];
    var list_choice : [Text] = [];
    let game : Result.Result<Types.Game, Types.Error> = await readGame(id_game);
    switch (game) {
      case (#ok(game)){
        list_choice_types := game.list_choice;
      };
      case (_) {
        return list_choice;
      };
    };
    var i : Nat = 0;
    while (i < list_choice_types.size()){
      list_choice := Array.append<Text>(list_choice, [list_choice_types[i].id_card_1]);
      list_choice := Array.append<Text>(list_choice, [list_choice_types[i].id_card_2]);
      i += 1;
    };
    return list_choice;
  };

  //clear choice
  public func clearChoice() : async Result.Result<(),()>{
    for (k in state.choices.keys()){
      state.choices.delete(k);
    };
    #ok();
  };


  //check goal
  public func checkGoal(time_start: Time.Time, id_card_1:Text, id_card_2: Text) : async Bool { 
    var couple_card : Int = 0;
    let add_choice = await createChoice(id_card_1, id_card_2);
    for (val in state.choices.vals()){
      let check_same_card : Bool = await checkSameCard(val.id_card_1, val.id_card_2);
      Debug.print(debug_show(check_same_card));
      if (check_same_card == true){
        couple_card += 1;
      };
    };
    Debug.print(debug_show(couple_card));
    if (Int.equal(couple_card, 6) == true){
      let create_game = await createGame(time_start, Time.now()); //if success create new game
      return true;
    }
    else return false;
  };

  //count choice 
  public func countChoice() : async Nat {
    return state.choices.size();
  };

  // convert choice to array 
  public func arrayChoice() : async [Text] {
    var list_choice : [Text] = [];
    for (val in state.choices.vals()){
      list_choice := Array.append<Text>(list_choice, [val.id_card_1]); 
      list_choice := Array.append<Text>(list_choice, [val.id_card_2]); 
    };
    return list_choice;
  };

  // check hacking ; true is hack, false is not hack
  public func checkHacking(list_choice_client : [Text], id_game: Text) : async Bool{ //check again choice
    if (list_choice_client == []){
      return true;
    };
    let list_choice_game : [Text] = await listChoiceOfGame(id_game); //list choie backend
    if (Array.equal(list_choice_client, list_choice_game, Text.equal) == true){  
      return false;
    }
    else {
      return true;
    };
  };


  //check 2 same cards
  public func checkSameCard(id_card_1: Text, id_card_2: Text) : async Bool {
    let data_card_1 = await readCard(id_card_1);
    let data_card_2 = await readCard(id_card_2);
    if (data_card_1==null or data_card_2==null){
      return false;
    }
    else {
      return data_card_1 == data_card_2;
    };
  };

  //return time this moment
  public func thisTime() : async Time.Time {
    return Time.now();
  };

  //demo 
  public func demo(time_start: Time.Time, list_data : [(Text, Text)]) : async Bool { //list data
    var i : Nat = 0;
    let size_list : Nat = Iter.size(Iter.fromArray<(Text, Text)>(list_data));
    while (i < size_list) {
      let find_id_card_1 : Result.Result<Text, Types.Error>  = await findIdCard(list_data[i].0);
      let find_id_card_2 : Result.Result<Text, Types.Error>  = await findIdCard(list_data[i].1);
      var id_card_1 : Text = "";
      var id_card_2 : Text = "";
      switch(find_id_card_1){
        case (#ok(id)) {
          id_card_1 := id;
        };
        case (_) return false;
      };
      switch(find_id_card_2){
        case (#ok(id)) {
          id_card_2 := id;
        };
        case (_) return false;
      };
      var check_goal : Bool = await checkGoal(time_start, id_card_1, id_card_2);
      if (check_goal == true){
        return true;
      };
      i += 1;
    };
    return false;
  };

  // find id card
  public func findIdCard(data: Text) : async Result.Result<Text, Types.Error> {
    for ((k, v) in state.cards.entries()){
      if (v.data == data){
        return #ok(k);
      };
    };
    return #err(#NotFound);
  };
};
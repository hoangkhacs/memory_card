import Text "mo:base/Text";
import TrieMap "mo:base/TrieMap";
import Types "Types";

module {
    public type State = {
        cards : TrieMap.TrieMap<Text, Types.Card>;
        choices : TrieMap.TrieMap<Text, Types.Choice>;
        games : TrieMap.TrieMap<Text, Types.Game>;
    };

    public func empty() : State {
        {
            cards = TrieMap.TrieMap<Text, Types.Card>(Text.equal, Text.hash);
            choices  = TrieMap.TrieMap<Text, Types.Choice>(Text.equal, Text.hash);
            games = TrieMap.TrieMap<Text, Types.Game>(Text.equal, Text.hash);

        }
    }
}
export const idlFactory = ({ IDL }) => {
  const Time = IDL.Int;
  const Result_1 = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Null });
  const Error = IDL.Variant({
    'Complete' : IDL.Null,
    'NotFound' : IDL.Null,
    'InComplete' : IDL.Null,
  });
  const Result_2 = IDL.Variant({ 'ok' : IDL.Text, 'err' : Error });
  const Card = IDL.Record({ 'data' : IDL.Text });
  const Choice = IDL.Record({ 'id_card_1' : IDL.Text, 'id_card_2' : IDL.Text });
  const Game = IDL.Record({
    'list_choice' : IDL.Vec(Choice),
    'time_play' : Time,
    'score' : IDL.Nat,
  });
  const Result = IDL.Variant({ 'ok' : Game, 'err' : Error });
  return IDL.Service({
    'arrayChoice' : IDL.Func([], [IDL.Vec(IDL.Text)], []),
    'checkGoal' : IDL.Func([Time, IDL.Text, IDL.Text], [IDL.Bool], []),
    'checkHacking' : IDL.Func([IDL.Vec(IDL.Text), IDL.Text], [IDL.Bool], []),
    'checkSameCard' : IDL.Func([IDL.Text, IDL.Text], [IDL.Bool], []),
    'clearChoice' : IDL.Func([], [Result_1], []),
    'clearData' : IDL.Func([], [Result_1], []),
    'countChoice' : IDL.Func([], [IDL.Nat], []),
    'createCard' : IDL.Func([IDL.Text], [Result_1], []),
    'createChoice' : IDL.Func([IDL.Text, IDL.Text], [Result_1], []),
    'createGame' : IDL.Func([Time, Time], [Result_1], []),
    'createId' : IDL.Func([], [IDL.Text], []),
    'demo' : IDL.Func(
        [Time, IDL.Vec(IDL.Tuple(IDL.Text, IDL.Text))],
        [IDL.Bool],
        [],
      ),
    'findIdCard' : IDL.Func([IDL.Text], [Result_2], []),
    'initDataCard' : IDL.Func([], [Result_1], []),
    'listCard' : IDL.Func([], [IDL.Vec(IDL.Tuple(IDL.Text, Card))], []),
    'listChoice' : IDL.Func([], [IDL.Vec(Choice)], []),
    'listChoiceOfGame' : IDL.Func([IDL.Text], [IDL.Vec(IDL.Text)], []),
    'listGame' : IDL.Func([], [IDL.Vec(IDL.Tuple(IDL.Text, Game))], []),
    'readCard' : IDL.Func([IDL.Text], [IDL.Opt(Card)], []),
    'readGame' : IDL.Func([IDL.Text], [Result], []),
    'thisTime' : IDL.Func([], [Time], []),
  });
};
export const init = ({ IDL }) => { return []; };

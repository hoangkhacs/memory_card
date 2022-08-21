import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Card { 'data' : string }
export interface Choice { 'id_card_1' : string, 'id_card_2' : string }
export type Error = { 'Complete' : null } |
  { 'NotFound' : null } |
  { 'InComplete' : null };
export interface Game {
  'list_choice' : Array<Choice>,
  'time_play' : Time,
  'score' : bigint,
}
export type Result = { 'ok' : Game } |
  { 'err' : Error };
export type Result_1 = { 'ok' : null } |
  { 'err' : null };
export type Result_2 = { 'ok' : string } |
  { 'err' : Error };
export type Time = bigint;
export interface _SERVICE {
  'arrayChoice' : ActorMethod<[], Array<string>>,
  'checkGoal' : ActorMethod<[Time, string, string], boolean>,
  'checkHacking' : ActorMethod<[Array<string>, string], boolean>,
  'checkSameCard' : ActorMethod<[string, string], boolean>,
  'clearChoice' : ActorMethod<[], Result_1>,
  'clearData' : ActorMethod<[], Result_1>,
  'countChoice' : ActorMethod<[], bigint>,
  'createCard' : ActorMethod<[string], Result_1>,
  'createChoice' : ActorMethod<[string, string], Result_1>,
  'createGame' : ActorMethod<[Time, Time], Result_1>,
  'createId' : ActorMethod<[], string>,
  'demo' : ActorMethod<[Time, Array<[string, string]>], boolean>,
  'findIdCard' : ActorMethod<[string], Result_2>,
  'initDataCard' : ActorMethod<[], Result_1>,
  'listCard' : ActorMethod<[], Array<[string, Card]>>,
  'listChoice' : ActorMethod<[], Array<Choice>>,
  'listChoiceOfGame' : ActorMethod<[string], Array<string>>,
  'listGame' : ActorMethod<[], Array<[string, Game]>>,
  'readCard' : ActorMethod<[string], [] | [Card]>,
  'readGame' : ActorMethod<[string], Result>,
  'thisTime' : ActorMethod<[], Time>,
}

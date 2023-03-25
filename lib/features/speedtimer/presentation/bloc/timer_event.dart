part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerOnTapDownEvent extends TimerEvent {}

class TimerOnTapUpEvent extends TimerEvent {}

class TimerPressedEvent extends TimerEvent {}

class TimerReadyEvent extends TimerEvent {}

class TimerStartEvent extends TimerEvent {}

class TimerStopEvent extends TimerEvent {}

class TimerSaveResultEvent extends TimerEvent {
  final ResultEntity? resultEntity;

  const TimerSaveResultEvent(this.resultEntity);
}

class TimerGetScrambleEvent extends TimerEvent {}

class TimerAppStartedEvent extends TimerEvent {}

class TimerGetAllResultsAndRecalculateEvent extends TimerEvent {}

class TimerPlus2Event extends TimerEvent {
  final ResultEntity? resultEntity;

  const TimerPlus2Event([this.resultEntity]);
}

class TimerDNFEvent extends TimerEvent {
  final ResultEntity? resultEntity;

  const TimerDNFEvent([this.resultEntity]);
}

class TimerDeleteResultEvent extends TimerEvent{
  final ResultEntity? resultEntity;

  const TimerDeleteResultEvent([this.resultEntity]);
}

class TimerAddResultBottomSheet extends TimerEvent {
  final ResultEntity resultEntity;

  const TimerAddResultBottomSheet(this.resultEntity);
}
class TimerUpdateDescriptionEvent extends TimerEvent {
  final String text;
  final int index;

  const TimerUpdateDescriptionEvent(this.text, this.index);
}

class TimerRecountAvgEvent extends TimerEvent {}

class TimerGetBestAvgEvent extends TimerEvent {
  final bool forceRecount;

  const TimerGetBestAvgEvent(this.forceRecount);
}

class TimerCompareBestAvgEvent extends TimerEvent {}

class TimerDeleteAllResultsEvent extends TimerEvent {}

class TimerChangeEvent extends TimerEvent {
  final Event event;

  const TimerChangeEvent(this.event);
}

class TimerSetDelayEvent extends TimerEvent {
  final double delay;

  const TimerSetDelayEvent(this.delay);
}

class TimerGetDelayEvent extends TimerEvent {}

class TimerGetBestSolveEvent extends TimerEvent {}
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/avg_entity.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/events.dart';
import 'package:speedtimer_flutter/features/speedtimer/domain/entities/result_entity.dart';

class ParamsResult {
  final ResultEntity resultEntity;

  ParamsResult(this.resultEntity);
}

class ParamsEvent {
  final Event event;

  ParamsEvent(this.event);
}

class ParamsIndexedEvent extends ParamsEvent {
  final int index;

  ParamsIndexedEvent(super.event, this.index);
}

class ParamsIndexedResult extends ParamsResult {
  final int index;

  ParamsIndexedResult(super.resultEntity, this.index);
}

class ParamsListResult {
  final List<ResultEntity> results;

  ParamsListResult(this.results);
}

class ParamsEventList extends ParamsEvent {
  final List<ResultEntity> results;
  final bool forceRecount;

  ParamsEventList(super.event, this.results, this.forceRecount);
}

class ParamsBestAvgs{
  final AvgEntity a;
  final AvgEntity b;
  final Event event;

  ParamsBestAvgs(this.a, this.b, this.event);
}

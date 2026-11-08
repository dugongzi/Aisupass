import 'package:Aisupass/features/escalation/data/datasources/escalation_action_datasource.dart';
import 'package:Aisupass/features/escalation/domain/enums/root_manager.dart';
import 'package:Aisupass/features/escalation/domain/models/handoff_outcome.dart';
import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:Aisupass/features/escalation/domain/repositories/escalation_action_repository.dart';

class EscalationActionRepositoryImpl implements EscalationActionRepository {
  const EscalationActionRepositoryImpl({required this._datasource});

  final EscalationActionDatasource _datasource;

  @override
  Future<String> runPayload(Payload payload) =>
      _datasource.runPayload(payload);

  @override
  void observeOutput(String text) => _datasource.observeOutput(text);

  @override
  Future<HandoffOutcome> handoffRoot({required RootManager manager}) =>
      _datasource.handoffRoot(manager: manager);
}

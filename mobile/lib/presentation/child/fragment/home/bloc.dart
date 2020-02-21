import 'package:simpati/core/bloc/scroll_fragment_bloc.dart';
import 'package:simpati/data/firebase/child_repository.dart';
import 'package:simpati/domain/entity/child.dart';
import 'package:simpati/domain/repository/child_repository.dart';
import 'package:simpati/domain/repository/posyandu_repository.dart';
import 'package:simpati/domain/usecase/load_child_usecase.dart';

class ChildBloc extends ScrollFragmentBloc<Child> {
  final LoadChildUsecase _loadChildUsecase;
  final ChildFilter childFilter;

  ChildBloc(
    this.childFilter, {
    IPosyanduRepository posyanduRepositoryPref,
    IChildRepository childRepository,
  }) : this._loadChildUsecase = LoadChildUsecase(
          childRepository ?? ChildRepository(),
        );

  @override
  ScrollFragmentState<Child> get initialState => ScrollFragmentState(items);

  @override
  Stream<ScrollFragmentState<Child>> mapEventToState(
      ScrollFragmentEvent event) async* {
    if (event is Init && childFilter.equalToValue != null) {
      final result = await _loadChildUsecase.start(childFilter);
      if (result.isSuccess()) {
        items.addAll(result.data.childs);
      }
      yield ScrollFragmentState(items);
    } else if (event is Add<Child>) {
      items.add(event.item);
      items.sort((a, b) => a.fullName.compareTo(b.fullName));
      yield ScrollFragmentState(items);
    }
  }
}

import 'package:untitled3/cell.dart';

class MyStack {
  final List<Cell> _list = List.empty(growable: true);
  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  void push(Cell c) {
    _list.add(c);
  }

  Cell pop() {
    Cell res = _list.last;
    _list.removeLast();
    return res;
  }

  Cell top() {
    return _list.last;
  }
  void sort(){
    _list.sort((a,b)=>(b.cost>a.cost)? 1:0);
  }
}

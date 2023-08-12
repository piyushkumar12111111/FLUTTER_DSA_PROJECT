import 'dart:collection';
import 'dart:math';
import 'package:get/get.dart';
import 'cell_type.dart';
import 'cell.dart';
import 'my_stack.dart';
import 'dart:core';
class Maze{
  int size=0;
  List<List<Cell>>? maze;
  int visitedNodes=0;
  Cell start=Cell();
  Cell goal=Cell();
  int time=0;
  bool isGoalExist= false;
  bool isStartExist= false;
  Maze(this.size){
    maze = List.generate(size, (i) => List.filled(size, Cell(), growable: false), growable: false);
  }
  static int getRandom(size, random){
    var rand = 0;
    while(rand == 0) {
      rand = random.nextInt(size - 1);
    }
    return rand;

  }
  void generate(){

    visitedNodes = 0;
    time = 0;
    var random = Random();
    for(int i = 0;i<size;i++){
      for(int j = 0;j<size;j++){
        maze![i][j] = Cell();
        if((i == 0) || (i == size-1) || (j == 0) || (j == size-1)){
          maze![i][j].type = cell_type.block;
        }
        else{
          double randNum = random.nextDouble()%2;
          maze![i][j].type = (randNum < 0.71) ? cell_type.empty : cell_type.block;
        }
        maze![i][j].i = i;
        maze![i][j].j = j;
      }
    }
    int rand1 = getRandom(size,random);
    int rand2 = getRandom(size,random);
    maze![rand1][rand2].type = cell_type.start;
    start = maze![rand1][rand2];
    isStartExist= true;
    rand1 = getRandom(size,random);
    rand2 = getRandom(size,random);
    goal = maze![rand1][rand2];
    maze![rand1][rand2].type = cell_type.goal;
    isGoalExist= true;
  }
  List<Cell> getNotVisitedNeighbors( Cell cell){
    var neighbors = List<Cell>.empty(growable: true);
    int i =cell.i!;
    int j =cell.j!;
    neighbors.addIf(!maze![i-1][j].isVisited && maze![i-1][j].type!=cell_type.block, maze![i-1][j]);
    neighbors.addIf(!maze![i][j+1].isVisited && maze![i][j+1].type!=cell_type.block, maze![i][j+1]);
    neighbors.addIf( !maze![i+1][j].isVisited && maze![i+1][j].type!=cell_type.block, maze![i+1][j]);
    neighbors.addIf(!maze![i][j-1].isVisited && maze![i][j-1].type!=cell_type.block, maze![i][j-1]);
    return neighbors;
  }

  List<Cell> bfs(){
    Stopwatch watch = Stopwatch();
    Queue<Cell> q = Queue<Cell>();
    watch.start();
    start.isVisited= true;
    visitedNodes++;
    q.add(start);
    Cell current;
    while(q.isNotEmpty){
      current = q.removeFirst();
      var neighbors = getNotVisitedNeighbors(current);
      for (var neighbor in neighbors) {
        neighbor.parent = current;
        neighbor.isVisited = true;
        visitedNodes++;
        q.add(neighbor);
        if(neighbor.type == cell_type.goal){
          watch.stop();
          time = watch.elapsedMicroseconds;

          return getPath(neighbor);
        }
      }
    }
    return List<Cell>.empty();
  }

  List<Cell> dfs(){
    Stopwatch watch = Stopwatch();
    MyStack s = MyStack();
    watch.start();
    start.isVisited= true;
    visitedNodes++;
    s.push(start);
    Cell current;
    while(s.isNotEmpty){
      current = s.pop();
      var neighbors = getNotVisitedNeighbors(current);
      for (var neighbor in neighbors) {
        neighbor.parent = current;
        neighbor.isVisited = true;
        visitedNodes++;
        s.push(neighbor);
        if(neighbor.type == cell_type.goal){
          watch.stop();
          time = watch.elapsedMicroseconds;
          return getPath(neighbor);
        }
      }
    }
    return List<Cell>.empty();
  }

  List<Cell> aStar(){
    Stopwatch watch = Stopwatch();
    MyStack s = MyStack();
    watch.start();
    start.isVisited= true;
    visitedNodes++;
    s.push(start);
    Cell current;
    while(s.isNotEmpty){
      current = s.pop();
      var neighbors = getNotVisitedNeighbors(current);
      for (var neighbor in neighbors) {
        neighbor.parent = current;
        neighbor.isVisited = true;
        visitedNodes++;
        neighbor.cost = getCost(neighbor);
        s.push(neighbor);
        if(neighbor.type == cell_type.goal){
          watch.stop();
          time = watch.elapsedMicroseconds;
          return getPath(neighbor);
        }
      }
      s.sort();
    }
    return List<Cell>.empty();
  }

  num getCost(neighbor){
    var distanceFromStart = pow(start.i! - neighbor.i!,2) + pow(start.j! - neighbor.j!,2);
    var distanceToGoal = pow(goal.i! - neighbor.i!,2) + pow(goal.j! - neighbor.j!,2);
    var totalCost = sqrt(distanceFromStart) + sqrt(distanceToGoal);
    return totalCost;
  }

  static List<Cell> getPath(Cell cell){
    var path = List<Cell>.empty(growable: true);
    while(cell.parent!=null){
      path.add(cell);
      cell = cell.parent!;
    }

    return path;
  }

  void setPathOrder(List<Cell> path){
    int count = path.length;
    for (var cell in path) {
      int i = cell.i!;
      int j = cell.j!;
      maze![i][j].pathOrder = count;
      count--;
    }
  }

  void clean(){
    visitedNodes = 0;
    for(int i = 0;i<size;i++){
      for(int j = 0;j<size;j++){
        maze![i][j].isVisited=false;
        maze![i][j].pathOrder =0;
        maze![i][j].parent =null;
      }
    }

  }
  void cleanAll(){
    for(int i = 0;i<size;i++){
      for(int j = 0;j<size;j++){
        maze![i][j].isVisited=false;
        maze![i][j].pathOrder =0;
        maze![i][j].parent =null;
        if((i != 0) && (i != size-1) && (j != 0) && (j != size-1)){
          maze![i][j].type = cell_type.empty;
        }
      }
    }
    time=0;
    visitedNodes = 0;
    isGoalExist= false;
    isStartExist= false;
  }
}
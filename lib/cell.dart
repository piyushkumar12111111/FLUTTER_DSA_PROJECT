import 'cell_type.dart';
import 'package:flutter/material.dart';
class Cell{
  cell_type? type;
  bool isVisited = false;
  int pathOrder=0;
  Cell? parent;
  int? i;
  int? j;
  num cost = 0;

  Color getColor(){
    if(type == cell_type.start) {
      return Colors.deepOrange;
    }
    else if(type == cell_type.goal) {
      return Colors.green;
    }
    else if(type == cell_type.block) {
      return Colors.black;
    }
    else if(pathOrder != 0){
      return Colors.cyan;
    }
    else if(isVisited == true) {
      return Colors.purpleAccent;
    }
    else { // cell_type.empty
      return Colors.white;
    }
  }
}
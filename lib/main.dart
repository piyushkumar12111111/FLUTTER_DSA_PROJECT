import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/cell_type.dart';
import 'maze.dart';

int size = 22;
Maze maze = Maze(size);

void main() {
  maze.generate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Maze',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final children = <Widget>[];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isManual = false;
  bool isManualBlockEnable = false;
  bool isManualEmptyEnable = false;
  bool isManualGoalEnable = false;
  bool isManualStartEnable = false;

  void makeAllUnable() {
    isManualStartEnable = false;
    isManualBlockEnable = false;
    isManualEmptyEnable = false;
    isManualGoalEnable = false;
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (int i = 0; i < size; i++) {
      var row = <Widget>[];
      for (int j = 0; j < size; j++) {
        row.add(Expanded(
          child: InkWell(
            onTap: isManual
                ? () {
                    if (isManualBlockEnable) {
                      maze.maze![i][j].type = cell_type.block;
                    } else if (isManualEmptyEnable) {
                      maze.maze![i][j].type = cell_type.empty;
                    } else if (isManualStartEnable && !maze.isStartExist) {
                      maze.maze![i][j].type = cell_type.start;
                      maze.start = maze.maze![i][j];
                      maze.isStartExist = true;
                    } else if (isManualGoalEnable && !maze.isGoalExist) {
                      maze.maze![i][j].type = cell_type.goal;
                      maze.goal = maze.maze![i][j];
                      maze.isGoalExist = true;
                    }
                    setState(() {});
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                  color: maze.maze![i][j].getColor(),
                  border: Border.all(color: Colors.deepOrange, width: 0.3)),
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Center(
                      child: Text(maze.maze![i][j].pathOrder != 0
                          ? maze.maze![i][j].pathOrder.toString()
                          : ''))),
            ),
          ),
        ));
      }
      children.add(Expanded(child: Row(children: row)));
    }
    children
        .add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
        flex: 2,
        child: ElevatedButton(
            onPressed: () {
              var path = maze.bfs();
              maze.setPathOrder(path);
              setState(() {
                errorChecking(path);
              });
            },
            child: const Text('bfs')),
      ),
      Expanded(
        flex: 2,
        child: ElevatedButton(
            onPressed: () {
              var path = maze.dfs();
              maze.setPathOrder(path);
              setState(() {
                errorChecking(path);
              });
            },
            child: const Text('dfs')),
      ),
      Expanded(
        flex: 2,
        child: ElevatedButton(
            onPressed: () {
              var path = maze.aStar();
              maze.setPathOrder(path);
              setState(() {
                errorChecking(path);
              });
            },
            child: const Text('A*')),
      ),
      Expanded(
        flex: 2,
        child: ElevatedButton(
            onPressed: () {
              maze.generate();
              setState(() {});
            },
            child: const Text('generate')),
      ),
      Expanded(
        flex: 2,
        child: ElevatedButton(
          child: const Text('clean'),
          onPressed: () {
            maze.clean();
            setState(() {});
          },
        ),
      ),
    ]));

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            child: const Text('clean all'),
            onPressed: () {
              maze.cleanAll();
              setState(() {});
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              isManual = !isManual;
              setState(() {});
            },
            //  style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'Manual Mode',
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              if (isManual) {
                makeAllUnable();
                isManualBlockEnable = true;
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.black),
            child: const Text('Black'),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              if (isManual) {
                makeAllUnable();
                isManualEmptyEnable = true;
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.white),
            child: const Text(
              'White',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              if (isManual) {
                makeAllUnable();
                if (!maze.isStartExist) {
                  isManualStartEnable = true;
                }
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const Text('Start'),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              if (isManual && !maze.isGoalExist) {
                makeAllUnable();
                if (!maze.isStartExist) {
                  isManualGoalEnable = true;
                }
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: const Text('Goal'),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            maze.time.toString() + ' MicroSeconds',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
              maze.visitedNodes.toString() + ' Nods Visited',
              textAlign: TextAlign.center,
            ))
      ],
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze'),
      ),
      body: Column(
        children: children,
      ),
    );
  }
}

void errorChecking(path) {
  if (path.isEmpty) {
    if (maze.goal.isVisited) {
      Get.defaultDialog(
          title: 'another path exist',
          content: const Text('Please clean maze and try again'));
    } else {
      Get.defaultDialog(
          title: 'no path found',
          content: const Text('Please generate a new maze'));
    }
  }
}

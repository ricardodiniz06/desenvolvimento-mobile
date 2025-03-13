import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const RockPaperScissorsApp());
}

class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialScreen(),
    );
  }
}

enum MoveOption { rock, paper, scissors }

class InitialScreen extends StatelessWidget {
  InitialScreen({super.key});

  final Map<MoveOption, String> moveImages = {
    MoveOption.rock: "assets/images/pedra.png",
    MoveOption.paper: "assets/images/papel.png",
    MoveOption.scissors: "assets/images/tesoura.png",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            "Pedra, Papel e Tesoura",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Escolha do APP (Aleatório):", style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, 
  ), ),

          SizedBox(height: 10),
          Image.asset("assets/images/padrao.png", height: 100, width: 100),
          SizedBox(height: 20),
          Text("Escolha a sua Jogada:", style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, 
  ),
),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: MoveOption.values.map((move) {
              return GestureDetector(
                onTap: () {
                  final appChoice = MoveOption.values[Random().nextInt(3)];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        playerChoice: move,
                        appChoice: appChoice,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    moveImages[move]!,
                    height: 80,
                    width: 80,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final MoveOption playerChoice;
  final MoveOption appChoice;

  ResultScreen({super.key, required this.playerChoice, required this.appChoice});

  final Map<MoveOption, String> moveImages = {
    MoveOption.rock: "assets/images/pedra.png",
    MoveOption.paper: "assets/images/papel.png",
    MoveOption.scissors: "assets/images/tesoura.png",
  };

  String determineResult(MoveOption playerChoice, MoveOption appChoice) {
    if (playerChoice == appChoice) {
      return "Empate!";
    } else if ((playerChoice == MoveOption.rock && appChoice == MoveOption.scissors) ||
        (playerChoice == MoveOption.paper && appChoice == MoveOption.rock) ||
        (playerChoice == MoveOption.scissors && appChoice == MoveOption.paper)) {
      return "Você venceu!";
    } else {
      return "Você perdeu!";
    }
  }

  String getResultImage(String result) {
    switch (result) {
      case "Você venceu!":
        return "assets/images/venceu.png";
      case "Você perdeu!":
        return "assets/images/perdeu.png";
      default:
        return "assets/images/empate.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = determineResult(playerChoice, appChoice);
    final resultImage = getResultImage(result);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            "Pedra, Papel, Tesoura",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Escolha do APP:", style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, 
  ),),
            Image.asset(moveImages[appChoice]!, height: 100, width: 100),
            SizedBox(height: 20),
            Text("Sua Escolha:", style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, 
  ),),
            Image.asset(moveImages[playerChoice]!, height: 100, width: 100),
            SizedBox(height: 30),
            Image.asset(
              resultImage,
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            Text(
              result,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Jogar Novamente", style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold, 
  ),)
              ,
            ),
          ],
        ),
      ),
    );
  }
}
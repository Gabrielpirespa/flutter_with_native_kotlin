import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 8,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              "Carregando",
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool state = false;
  final supabase =Supabase.instance.client;
  @override
  void initState() {
    listenState();
    super.initState();
  }

  void listenState(){
    supabase.from('devices')
        .stream(primaryKey: ['id'])
        .eq('id', 1).listen((List<Map<String,dynamic>> data)
    {
      if (data.isNotEmpty)
        {
          setState(() {
            state = data[0]['is_on'];
          });
        }
    });
  }

  toggleLed(bool value) async
  {
    setState(() {
      state = value;
    });
    await supabase.from('devices').update({'is_on':value}).eq('id', 1);
  }
  @override
  Widget build(BuildContext context) {
    print(state?'led on':'led off');
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Card(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 2,
                  blurRadius: 5
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                state?Lottie.asset('assets/light.json',height: 200):SizedBox(),
                Switch(
                  activeThumbColor: Colors.white,
                  activeTrackColor: Colors.green.shade700,
                  value: state,
                  onChanged: (value) {
                      toggleLed(value);
                },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text('Controller'),
        centerTitle: true,
        backgroundColor: state?Colors.green:Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: InkWell(
          onTap: (){
            setState(() {
              state = !state;

              toggleLed(state);
            });
          },
          child: Image.asset(
              height: 300,
              state?'assets/images/on.png':'assets/images/off.png'),
        ),
      ),
    );
  }
}

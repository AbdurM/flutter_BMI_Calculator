import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorWidget(),
    );
  }
}

class CalculatorWidget extends StatefulWidget {
  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  final TextEditingController txtHeight = TextEditingController();
  final TextEditingController txtWeight = TextEditingController();
  final double fontSize = 18;
  String result = '';
  bool isMetric = true;
  bool isImperial = false;
  double? height;
  double? weight;
  late List<bool> isSelected;
  String HeightMeasurementLabel = '';
  String WeightMeasurementLabel = '';

  //styles
  var userInputTextStyle = TextStyle(fontSize: 45, fontWeight: FontWeight.bold);

  @override
  void initState() {
    isSelected = [isMetric, isImperial];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HeightMeasurementLabel = (isMetric) ? 'm' : 'in';
    WeightMeasurementLabel = (isMetric) ? 'kg' : 'lb';

    final Shader linearGradient =
        LinearGradient(colors: [Colors.yellow, Colors.red])
            .createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;

    var container = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: [Colors.cyan, Colors.green])),
      child: ElevatedButton(
        onPressed: calculateBMI,
        child: Text(
          'CALCULATE',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 100, 30, 30),
            child: Container(
              width: sizeX,
              height: sizeY,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                GetLeftAlignedText("Abdur's", 15, Colors.grey),
                Row(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "BMI",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Tracker",
                          style: TextStyle(fontSize: 50, color: Colors.grey),
                        )),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 70)),
                GetLeftAlignedText('MEASURE', 18, Colors.grey),
                Align(
                  alignment: Alignment.topLeft,
                  child: ToggleButtons(
                    children: ToggleMeasureChildren,
                    isSelected: (isSelected),
                    onPressed: ToggleMeasure,
                    selectedBorderColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    fillColor: Colors.transparent,
                    selectedColor: Colors.black.withOpacity(0.6),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: GetLeftAlignedText('HEIGHT', 18, Colors.grey),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: txtHeight,
                        keyboardType: TextInputType.number,
                        decoration: GetInputTextFieldDecorationWithHint('00'),
                        style: userInputTextStyle,
                      ),
                    ),
                    GetLeftAlignedText(HeightMeasurementLabel, 45,
                        Colors.grey.withOpacity(0.5))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0),
                  child: GetLeftAlignedText('WEIGHT', 18, Colors.grey),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: txtWeight,
                        keyboardType: TextInputType.number,
                        decoration: GetInputTextFieldDecorationWithHint('00'),
                        style: userInputTextStyle,
                      ),
                    ),
                    GetLeftAlignedText(WeightMeasurementLabel, 45,
                        Colors.grey.withOpacity(0.5))
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: container,
                    ),
                  ),
                )
              ]),
            )));
  }

  InputDecoration GetInputTextFieldDecorationWithHint(String hintText) {
    return InputDecoration(
        fillColor: Colors.black,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: hintText);
  }

  Align GetLeftAlignedText(String headingText, double fontSize, Color? color) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          headingText,
          style: TextStyle(
              fontSize: fontSize, color: color, fontWeight: FontWeight.bold),
        ));
  }

  List<Widget> get ToggleMeasureChildren {
    return [
      Text('Metric', style: userInputTextStyle),
      Padding(
        padding: EdgeInsets.only(left: 16),
        child: Text('Imperial', style: userInputTextStyle),
      )
    ];
  }

  void ToggleMeasure(value) {
    if (value == 0) {
      isMetric = true;
      isImperial = false;
    } else {
      isMetric = false;
      isImperial = true;
    }
    setState(() {
      txtHeight.clear();
      txtWeight.clear();
      isSelected = [isMetric, isImperial];
    });
  }

  void calculateBMI() {
    double bmi = 0;
    double height = double.tryParse(txtHeight.text) ?? 0;
    double weight = double.tryParse(txtWeight.text) ?? 0;

    if (height > 0 && weight > 0) {
      if (isMetric) {
        bmi = weight / (height * height);
      } else {
        bmi = weight * 703 / (height * height);
      }
      result = 'Your BMI is ' + bmi.toStringAsFixed(2);
    } else {
      result = "Please enter valid values. :-)";
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                  child: Text(
                "Your BMI",
                style: TextStyle(color: Colors.orange),
              )),
              content: Text(result),
              actions: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [Colors.cyan, Colors.green]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            txtHeight.clear();
                            txtWeight.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent),
                          child: const Text("ok"),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }
}

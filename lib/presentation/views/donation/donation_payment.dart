import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsbriefapp/presentation/widgets/components/layout/custom_alert.dart';

class DonationPayment extends StatefulWidget {
  const DonationPayment({super.key});

  @override
  State<DonationPayment> createState() => _DonationPaymentState();
}

class _DonationPaymentState extends State<DonationPayment> {
  int _amount = 10;
  void handleAmount(value) {
    setState(() {
      _amount = value;
    });
  }

  void makePayment() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 32,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Donate to help us continue the chase for real news, and to build a platform for unheard voices',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Amount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => handleAmount(10),
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                      color: _amount == 10
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "\$10",
                                    style: TextStyle(
                                      color: _amount == 10
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () => handleAmount(20),
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                      color: _amount == 20
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "\$20",
                                    style: TextStyle(
                                      color: _amount == 20
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () => handleAmount(15),
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                      color: _amount == 15
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "\$15",
                                    style: TextStyle(
                                      color: _amount == 15
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              GestureDetector(
                                onTap: () => handleAmount(50),
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                      color: _amount == 50
                                          ? Colors.black
                                          : Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "\$50",
                                    style: TextStyle(
                                      color: _amount == 50
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text('or',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                    const SizedBox(
                      height: 18,
                    ),
                    TextField(
                      onChanged: (value) {
                        int? amount = int.tryParse(value);
                        if (amount != null) {
                          setState(() {
                            _amount = amount;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Enter manually'),
                      style: const TextStyle(
                          color: Color(0xFF212529),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    GestureDetector(
                      onTap: makePayment,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.handHoldingHeart,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Pay & Confirm',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ))));
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../amount.dart';
import 'amount_view.dart';

class AmountPage extends StatelessWidget {
  const AmountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AmountCubit(),
      child: AmountView(),
    );
  }
}

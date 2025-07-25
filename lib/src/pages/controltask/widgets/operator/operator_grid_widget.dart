import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vc_taskcontrol/src/models/operator.dart';
import 'package:vc_taskcontrol/src/providers/app/operators_provider.dart';
import 'package:vc_taskcontrol/src/providers/mock_data_provider.dart';
import 'package:vc_taskcontrol/src/providers/route_data_provider.dart';

class OperatorGridWidget extends StatelessWidget {
  final ValueChanged<Operator> onSelected;
  final Color selectedColor;
  final Color selectedTextColor;

  const OperatorGridWidget({
    super.key,
    required this.onSelected,
    this.selectedColor = Colors.orange,
    this.selectedTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // final operators = context.watch<MockDataProvider>().operators;
    final operators = context.watch<OperatorsProvider>().operators;
    final selectedOperatorId =
        context.watch<RouteDataProvider>().selectedOperatorId;

    return GridView.extent(
      maxCrossAxisExtent: 180,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children:
          operators.map((operator) {
            final isSelected = operator.id == selectedOperatorId;

            return GestureDetector(
              onTap: () => onSelected(operator),
              child: Card(
                color:
                    isSelected ? selectedColor.withOpacity(0.5) : Colors.white,
                elevation: isSelected ? 6 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isSelected ? selectedColor : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        operator.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              isSelected ? selectedTextColor : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        operator.shift,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        operator.documentNum,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

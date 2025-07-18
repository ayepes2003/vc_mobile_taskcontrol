import 'package:flutter/material.dart';

enum CalculatorButtonType {
  number,
  operator,
  clear,
  delete,
  memory,
  equal,
  ok,
  dot,
}

class CalculatorButton {
  final String label;
  final CalculatorButtonType type;
  final String? value;
  final String? tooltip;

  CalculatorButton({
    required this.label,
    required this.type,
    this.value,
    this.tooltip,
  });
}

class QuantityStepWidget extends StatefulWidget {
  final String supervisor;
  final String project;
  final String operatorName;
  final String section;
  final String subsection;

  const QuantityStepWidget({
    Key? key,
    required this.supervisor,
    required this.project,
    required this.operatorName,
    required this.section,
    required this.subsection,
  }) : super(key: key);

  @override
  State<QuantityStepWidget> createState() => _QuantityStepWidgetState();
}

class _QuantityStepWidgetState extends State<QuantityStepWidget> {
  String display = "0";
  String? operatorSymbol;
  double? firstOperand;
  double? memoryValue;
  bool shouldClearDisplay = false;

  final List<CalculatorButton> buttons = [
    CalculatorButton(label: '7', type: CalculatorButtonType.number, value: '7'),
    CalculatorButton(label: '8', type: CalculatorButtonType.number, value: '8'),
    CalculatorButton(label: '9', type: CalculatorButtonType.number, value: '9'),
    CalculatorButton(
      label: '÷',
      type: CalculatorButtonType.operator,
      value: '÷',
      tooltip: 'Dividir',
    ),
    CalculatorButton(
      label: 'MC',
      type: CalculatorButtonType.memory,
      tooltip: 'Guardar o recuperar memoria',
    ),
    CalculatorButton(label: '4', type: CalculatorButtonType.number, value: '4'),
    CalculatorButton(label: '5', type: CalculatorButtonType.number, value: '5'),
    CalculatorButton(label: '6', type: CalculatorButtonType.number, value: '6'),
    CalculatorButton(
      label: '×',
      type: CalculatorButtonType.operator,
      value: '×',
      tooltip: 'Multiplicar',
    ),
    CalculatorButton(
      label: 'DEL',
      type: CalculatorButtonType.delete,
      tooltip: 'Borrar último dígito',
    ),
    CalculatorButton(label: '1', type: CalculatorButtonType.number, value: '1'),
    CalculatorButton(label: '2', type: CalculatorButtonType.number, value: '2'),
    CalculatorButton(label: '3', type: CalculatorButtonType.number, value: '3'),
    CalculatorButton(
      label: '−',
      type: CalculatorButtonType.operator,
      value: '−',
      tooltip: 'Restar',
    ),
    CalculatorButton(
      label: 'C',
      type: CalculatorButtonType.clear,
      tooltip: 'Limpiar todo',
    ),
    CalculatorButton(label: '0', type: CalculatorButtonType.number, value: '0'),
    CalculatorButton(
      label: '.',
      type: CalculatorButtonType.dot,
      tooltip: 'Punto decimal',
    ),
    CalculatorButton(
      label: '=',
      type: CalculatorButtonType.equal,
      tooltip: 'Calcular resultado',
    ),
    CalculatorButton(
      label: '+',
      type: CalculatorButtonType.operator,
      value: '+',
      tooltip: 'Sumar',
    ),
    CalculatorButton(
      label: 'OK',
      type: CalculatorButtonType.ok,
      tooltip: 'Confirmar cantidad',
    ),
  ];

  void onButtonPressed(CalculatorButton button) {
    setState(() {
      switch (button.type) {
        case CalculatorButtonType.number:
          if (display == "0" || shouldClearDisplay) {
            display = button.value!;
            shouldClearDisplay = false;
          } else {
            display += button.value!;
          }
          break;
        case CalculatorButtonType.dot:
          if (!display.contains('.')) {
            display += '.';
          }
          break;
        case CalculatorButtonType.operator:
          operatorSymbol = button.value;
          firstOperand = double.tryParse(display);
          shouldClearDisplay = true;
          break;
        case CalculatorButtonType.equal:
          if (operatorSymbol != null && firstOperand != null) {
            double? secondOperand = double.tryParse(display);
            double? result;
            switch (operatorSymbol) {
              case '+':
                result = firstOperand! + (secondOperand ?? 0);
                break;
              case '−':
                result = firstOperand! - (secondOperand ?? 0);
                break;
              case '×':
                result = firstOperand! * (secondOperand ?? 0);
                break;
              case '÷':
                if (secondOperand != 0) {
                  result = firstOperand! / (secondOperand ?? 1);
                } else {
                  result = null;
                }
                break;
            }
            if (result != null) {
              display = result.toStringAsFixed(
                result.truncateToDouble() == result ? 0 : 2,
              );
            } else {
              display = "Error";
            }
            operatorSymbol = null;
            firstOperand = null;
            shouldClearDisplay = true;
          }
          break;
        case CalculatorButtonType.clear:
          display = "0";
          operatorSymbol = null;
          firstOperand = null;
          shouldClearDisplay = false;
          break;
        case CalculatorButtonType.delete:
          if (display.length > 1) {
            display = display.substring(0, display.length - 1);
          } else {
            display = "0";
          }
          break;
        case CalculatorButtonType.memory:
          if (memoryValue == null) {
            memoryValue = double.tryParse(display);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Memoria guardada')));
          } else {
            display = memoryValue!.toStringAsFixed(
              memoryValue!.truncateToDouble() == memoryValue! ? 0 : 2,
            );
            shouldClearDisplay = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Memoria recuperada: $display')),
            );
            memoryValue = null;
          }
          break;
        case CalculatorButtonType.ok:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cantidad confirmada: $display')),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Ajuste dinámico del ancho de la calculadora
          double horizontalMargin = constraints.maxWidth * 0.05;
          double usableWidth = constraints.maxWidth - (horizontalMargin * 2);
          double maxCalculatorWidth = 600;
          double calculatorWidth =
              usableWidth > maxCalculatorWidth
                  ? maxCalculatorWidth
                  : usableWidth;

          double totalSpacing = 12 * 4;
          double buttonSize = (calculatorWidth - totalSpacing) / 5;
          if (buttonSize < 50) buttonSize = 50;

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: calculatorWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display de la calculadora
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.primary, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botonera adaptable
                GridView.count(
                  crossAxisCount: 5,
                  shrinkWrap: true,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children:
                      buttons.map((button) {
                        final bool isControl =
                            button.type == CalculatorButtonType.memory ||
                            button.type == CalculatorButtonType.delete ||
                            button.type == CalculatorButtonType.clear;
                        final bool isOk =
                            button.type == CalculatorButtonType.ok;
                        return Tooltip(
                          message:
                              button.type == CalculatorButtonType.memory
                                  ? (memoryValue == null
                                      ? 'Guardar en memoria'
                                      : 'Recuperar memoria')
                                  : (button.tooltip ?? ''),
                          child: SizedBox(
                            width: buttonSize,
                            height: buttonSize,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isOk
                                        ? colorScheme.primary
                                        : colorScheme.surface,
                                foregroundColor:
                                    isOk
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                textStyle: TextStyle(
                                  fontSize: isControl ? 17 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => onButtonPressed(button),
                              child: Text(button.label),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

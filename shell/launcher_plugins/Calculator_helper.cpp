#include <libqalculate/Calculator.h>
#include <string>

static Calculator calc;

void n9_qalculate_load() {
	calc.loadExchangeRates();
	calc.loadGlobalDefinitions();
	calc.loadLocalDefinitions();
}

std::string n9_qalculate_do(std::string inp) {
	return calc.calculateAndPrint(calc.unlocalizeExpression(inp), 2000);
}

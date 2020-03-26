#include "lorenz.h"

void lorenz::operator()(const state_type& x, state_type& dxdt, double)
{
	dxdt[0] = _sigma * (x[1] - x[0]);
	dxdt[1] = x[0] * (_r - x[2]) - x[1];
	dxdt[2] = -_b * x[2] + x[0] * x[1];
}

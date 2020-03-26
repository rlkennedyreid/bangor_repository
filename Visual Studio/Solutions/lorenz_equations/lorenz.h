#pragma once

#include "lorenz_aliases.h"

class lorenz
{
private:

	double _sigma{ 0 };
	double _r{ 0 };
	double _b{ 0 };

public:

	lorenz(double sigma, double r, double b)
		: _sigma(sigma), _r(r), _b(b) {}

	void operator()(const state_type& x, state_type& dxdt, double /* t */);
};
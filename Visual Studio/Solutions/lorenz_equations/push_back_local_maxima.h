#pragma once

#include "lorenz_aliases.h"

#include <vector>

class push_back_local_maxima
{
private:

	std::vector<state_type>& m_states;
	std::vector<double>& m_times;

	double prev{ 0.0 };
	double now{ 0.0 };
	double next{ 0.0 };
	int call_count{ 0 };

	bool checkForLocalMaxima(double previous, double current, double next)
	{
		return (previous <= current && next <= current) ? true : false;
	}

public:

	push_back_local_maxima(std::vector<state_type>& states, std::vector<double>& times)
		: m_states(states), m_times(times) {}

	void operator()(const state_type& x, double t);
};
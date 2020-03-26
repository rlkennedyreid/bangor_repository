#include "push_back_local_maxima.h"

void push_back_local_maxima::operator()(const state_type& x, double t)
{
	prev = now; now = next; next = x[0];

	// Printing local maximas
	if (call_count > 2 && checkForLocalMaxima(prev, now, next))
	{
		m_states.push_back(x);
		m_times.push_back(t);
	}

	call_count++;
}

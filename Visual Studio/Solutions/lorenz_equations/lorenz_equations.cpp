#include "lorenz_equations.h"

std::array<double, 3> lorenz(std::array<double, 3> input)
{
	constexpr double sigma = 10.0;
	constexpr double gamma = 28.0;
	constexpr double beta = 8.0 / 3.0;

	std::array<double, 3> output{ {0.0, 0.0, 0.0} };

	output[0] = sigma * (input[1] - input[0]);
	output[1] = input[0] * (gamma - input[2]) - input[1];
	output[3] = input[0] * input[1] - beta * input[2];

	return output;
}

void rungeKutta(std::array<double, 3> input, double step_size)
{
	std::array<std::array<double, 3>, 4> k_vals{ { {0.0, 0.0, 0.0},{0.0, 0.0, 0.0},{0.0, 0.0, 0.0},{0.0, 0.0, 0.0} } };

	for (int i{ 0 }; i < 4; i++)
	{
		
	}
}

#include "lorenz_aliases.h"
#include "lorenz.h"
#include "lorenz_equations.h"
#include "push_back_local_maxima.h"

#include <fstream>
#include <vector>

#include <boost/array.hpp>
#include <boost/numeric/odeint.hpp>

void outputLorenzAttractorData(const std::string& output_directory)
{
	constexpr double sigma = 10.0;
	constexpr double r = 28.0;
	constexpr double b = 8.0 / 3.0;

	std::ofstream file_stream;

	file_stream.open(output_directory);

	state_type x = { 10.0 , 1.0 , 1.0 }; // initial conditions

	auto lambda_writer = [&file_stream](const state_type& x, const double t)
	{
		file_stream << t << ',' << x[0] << ',' << x[1] << ',' << x[2] << std::endl;
	};

	boost::numeric::odeint::integrate(lorenz(sigma, r, b), x, 0.0, 100.0, 0.01, lambda_writer);

	file_stream.close();
}

void outputLorenzBifurcationDiagramData(const std::string& output_file)
{

	// range for parameter change
	constexpr double r_min = 0.0;
	constexpr double r_max = 400.0;

	constexpr int r_num_divisions = 400;
	constexpr double r_division = (r_max - r_min) / (double)r_num_divisions;

	std::ofstream file_stream;

	file_stream.open(output_file);

	double r{ r_min };

	for (int i{ 0 }; i < r_num_divisions; i++)
	{
		r += r_division;
		constexpr double sigma{ 10.0 };
		constexpr double b{ 8.0 / 3.0 };

		state_type state = { 15.0, 20.0, 30.0 };

		constexpr double transient_time = 100.0;

		boost::numeric::odeint::integrate(lorenz(sigma, r, b), state, 0.0, transient_time, 0.1);

		std::vector<state_type> states;
		std::vector<double> times;

		boost::numeric::odeint::integrate(lorenz(sigma, r, b), state, 0.0, 100.0, 0.1, push_back_local_maxima(states, times));

		for (size_t i{ 0 }; i < states.size(); i++)
			file_stream << times[i] << ',' << r << ',' << states[i][0] << ',' << states[i][1] << ',' << states[i][2] << std::endl;
	}

	file_stream.close();

	return;
}

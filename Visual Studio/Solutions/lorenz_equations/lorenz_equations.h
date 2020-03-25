#pragma once

#include <iostream>
#include <fstream>
#include <boost/array.hpp>
#include <boost/numeric/odeint.hpp>

namespace lor
{
    using state_type = boost::array<double, 3>;

    double sigma = 10.0;
    double r = 28.0;
    double b = 8.0 / 3.0;
}

void lorenz(const lor::state_type& x, lor::state_type& dxdt, double t)
{
    dxdt[0] = lor::sigma * (x[1] - x[0]);
    dxdt[1] = x[0] * (lor::r - x[2]) - x[1];
    dxdt[2] = -lor::b * x[2] + x[0] * x[1];
}

void outputLorenzAttractorData(const std::string& output_directory)
{
    std::ofstream file_stream;

    file_stream.open(output_directory);

    lor::state_type x = { 10.0 , 1.0 , 1.0 }; // initial conditions

    auto lambda_writer = [&file_stream](const lor::state_type& x, const double t)
    {
        file_stream << t << ',' << x[0] << ',' << x[1] << ',' << x[2] << std::endl;
    };

    boost::numeric::odeint::integrate(lorenz, x, 0.0, 100.0, 0.01, lambda_writer);

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

    std::array<double, 100> times_range;

    for (size_t i{ 0 }; i < times_range.size(); i++)
    {
        times_range[i] = 0.5 * (double)i;
    }
    lor::r = r_min;
    for (int i{ 0 }; i < r_num_divisions; i++)
    {
        lor::r += r_division;

        lor::state_type state = { 15.0, 20.0, 30.0 };

        constexpr double transient_time = 100.0;

        boost::numeric::odeint::integrate(lorenz, state, 0.0, 100.0, 0.1);

        double prev, now, next;

        prev = now = next = 0.0;

        int count{ 0 };

        auto lambda_writer = [&file_stream, &prev, &now, &next, &count](const lor::state_type& x, const double t)
        {
            prev = now;
            now = x[2];

            double crossing_point{ lor::r - 1.0 };

            if ((prev <= crossing_point && now >= crossing_point && count > 2) || (prev >= crossing_point && now <= crossing_point && count > 2))
                file_stream << t << ',' << lor::r << ',' << x[0] << ',' << x[1] << ',' << x[2] << std::endl;

            count++;
        };


        typedef boost::numeric::odeint::runge_kutta_dopri5<lor::state_type> rk4;

        //boost::numeric::odeint::integrate_adaptive(rk4(), lorenz, state, 0.0, 100.0, 0.1, lambda_writer);
        boost::numeric::odeint::integrate_times(rk4(), lorenz, state, times_range.begin(), times_range.end(), 0.01, lambda_writer);

    }

    file_stream.close();

    return;
}
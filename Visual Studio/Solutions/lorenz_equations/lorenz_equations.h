#pragma once


#include <array>


constexpr int M{ 3 }; // num equations

/*!
	\brief Function to compute the lorenz equation from a given inpuit
	\details The lorenz equation gives the rate of change of each parameter, given the current value of the parameters
	\param[in] input An array of the current parameter values (i.e. x(t), y(t), z(t))
	\returns An array of the rate of change of each parameter (dx/dt, dy/dt, dz/dt)
*/
std::array<double, 3> lorenz(std::array<double, 3>  input);


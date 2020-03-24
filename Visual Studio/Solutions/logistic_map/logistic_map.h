#pragma once

#include <fstream>
#include <string>

/*!
	\brief Simple function to compute the next value of logistic map
	\param[in] r The r-value for the map
	\param[in] x The current value of the map
	\returns The next value
*/
double logistic(double r, double x);

/*!
	\brief Prints an integer and a double into a file stream, separated by a comma with a return character at the end
	\param[out] file_stream filestream to print to
	\param[in] integer_val Integer to print (printed first)
	\param[in] double_val Double to print
*/
void inline printIntoFilestream(std::ofstream& file_stream, double double_val1, int integer_val, double double_val2);

/*!
	\brief Function to print out a logistic map time series to a file
	\param[in] output_file The full file directory of the file to output to
	\param[in] num_iterations The number of map iterations to print
	\param[in] r r-value of the map
	\param[in] x_initial the initial x-value
*/
void outputLogisticSequence(const std::string& output_file, int num_iterations, double r, double x_initial);

/*!
	\brief Function to print out a logistic map bifurcation diagram data to a file
	\param[in] output_file The full file directory of the file to output to
*/
void outputLogisticBifurcationDiagramData(const std::string& output_file);
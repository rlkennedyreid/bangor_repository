#pragma once

#include <fstream>

double logistic(double r, double x);

void inline printIntoFilestream(std::ofstream& file_stream, int integer_val, double double_val);

void outputLogisticSequence(int num_iterations, double r, double x_initial);
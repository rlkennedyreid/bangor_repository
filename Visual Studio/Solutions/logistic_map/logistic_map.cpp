#include "logistic_map.h"

#include <fstream>

double logistic(double r, double x)
{
    return r * x * (1.0 - x);
}

inline void printIntoFilestream(std::ofstream& file_stream, int integer_val, double double_val)
{
    file_stream << integer_val << ',' << double_val << std::endl;
}

void outputLogisticSequence(int num_iterations, double r, double x_initial)
{
    std::ofstream file_stream;

    file_stream.open("C:\\Users\\rbk20xqk\\Documents\\google_backup\\data\\logistic_map\\output.csv");

    double x{ x_initial };

    for (int i{ 0 }; i < num_iterations; i++)
    {
        printIntoFilestream(file_stream, i, x);

        x = logistic(r, x);
    }

    printIntoFilestream(file_stream, num_iterations, x);

    file_stream.close();

}

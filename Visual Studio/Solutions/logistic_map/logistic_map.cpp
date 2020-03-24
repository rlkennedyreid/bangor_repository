#include "logistic_map.h"

#include <fstream>
#include <string>

double logistic(double r, double x)
{
    return r * x * (1.0 - x);
}

inline void printIntoFilestream(std::ofstream& file_stream, double double_val1, int integer_val, double double_val2)
{
    file_stream << double_val1 << ',' << integer_val << ',' << double_val2 << std::endl;
}

void outputLogisticSequence(const std::string& output_file, int num_iterations, double r, double x_initial)
{
    std::ofstream file_stream;

    file_stream.open(output_file, std::ios::app);

    double x{ x_initial };

    for (int i{ 0 }; i < num_iterations; i++)
    {
        printIntoFilestream(file_stream, r, i, x);

        x = logistic(r, x);
    }

    // Make sure we print out the final calculated value
    printIntoFilestream(file_stream, r, num_iterations, x);

    file_stream.close();

}

void outputLogisticBifurcationDiagramData(const std::string& output_file)
{

    constexpr double x_initial = 0.314;

    // range for parameter change
    constexpr double r_min = 0.0;
    constexpr double r_max = 4.0;

    constexpr int r_num_divisions = 400;
    constexpr double r_division = (r_max - r_min) / (double)r_num_divisions;

    double r{ r_min };
    for (int i{ 0 }; i < r_num_divisions; i++)
    {
        r += r_division;
        
        double x{ x_initial };

        constexpr int transient = 100;

        for (int j{ 0 }; j < transient; j++)
            x = logistic(r, x);

        constexpr int num_to_print = 50;
        outputLogisticSequence(output_file, num_to_print, r, x);
    }
}

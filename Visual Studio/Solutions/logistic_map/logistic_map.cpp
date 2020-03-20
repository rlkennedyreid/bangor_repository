// logistic_map.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>

double logistic(double r, double x)
{
    return r * x * (1.0 - x);
}


void inline printIntoFilestream(std::ofstream& file_stream, int integer_val, double double_val)
{
    file_stream << integer_val << ',' << double_val << std::endl;
}

void outputLogisticSequence(int num_iterations, double r, double x_initial)
{
    std::ofstream file_stream;

    file_stream.open("output.csv");

    double x{ x_initial };

    for (int i{ 0 }; i < num_iterations; i++)
    {
        printIntoFilestream(file_stream, i, x);

        x = logistic(r, x);
    }

    printIntoFilestream(file_stream, num_iterations, x);

    file_stream.close();

}

int main()
{
    int n = 50;
    double r = 4.0;
    double x = 0.314;
    
    outputLogisticSequence(n, r, x);

    return 0;
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file

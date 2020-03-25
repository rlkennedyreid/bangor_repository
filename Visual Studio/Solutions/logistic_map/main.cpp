// logistic_map.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "logistic_map.h"

int main()
{
    constexpr int n = 10000;
    constexpr double r = 4.0;
    constexpr double x = 0.314;

    const std::string output_directory{ "C:/Users/rbk20xqk/Documents/google_backup/data/logistic_map/" };
    
    outputLogisticBifurcationDiagramData(output_directory + "bifurcation.csv");
    outputLogisticLyapunovData(output_directory + "lyapunov.csv");

    return 0;
}

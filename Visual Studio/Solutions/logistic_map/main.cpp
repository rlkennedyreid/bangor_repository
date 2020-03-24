// logistic_map.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "logistic_map.h"

#include "boost/filesystem.hpp"

int main()
{
    constexpr int n = 10000;
    constexpr double r = 4.0;
    constexpr double x = 0.314;

    const std::string output_directory{ "C:/Users/rbk20xqk/Documents/google_backup/data/logistic_map/" };

    boost::filesystem::remove_all(output_directory);
    boost::filesystem::create_directory(output_directory);
      
    outputLogisticSequence(output_directory + "sequence.csv", n, r, x);

    outputLogisticBifurcationDiagramData(output_directory + "bifurcation.csv");

    return 0;
}

// logistic_map.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "logistic_map.h"

int main()
{
    constexpr int n = 10000;
    constexpr double r = 4.0;
    constexpr double x = 0.314;
    
    outputLogisticSequence(n, r, x);

    return 0;
}

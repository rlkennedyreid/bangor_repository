#include <string>

#include "lorenz_equations.h"

const std::string output_directory{ "C:/Users/rbk20xqk/Documents/google_backup/data/lorenz_equation/" };

int main()
{
	//outputLorenzAttractorData(output_directory + "lorenz_sequence.csv");
	outputLorenzBifurcationDiagramData(output_directory + "lorenz_bifurcation.csv");

}
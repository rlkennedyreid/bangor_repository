// file_splitter.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <fstream>
#include <string>

#include <boost/filesystem.hpp>


int assignHeaderAndDataNum(const std::string& events_file_directory, int& num_header_lines, int& num_data_rows)
{
	std::ifstream event_file{ events_file_directory };

	while (event_file.good())
	{
		std::string line;
		getline(event_file, line);

		if (line.size() != 0)
		{
			if (line.front() == '%') num_header_lines++;

			else num_data_rows++;
		}
	}

	event_file.close();

	return num_header_lines;
}

void outputHeaderFile(const std::string& events_file_directory, const std::string& output_directory, int num_header_lines)
{
	std::ifstream event_file{ events_file_directory };
	std::ofstream output_file{ output_directory + "header_file.txt" };

	for (int i{ 0 }; i < num_header_lines && event_file.good() && output_file.good(); i++)
	{
		std::string line;

		if (getline(event_file, line)) output_file << line << std::endl;

	}

	event_file.close();
	output_file.close();
}

void outputSplitEventFiles(
	const std::string& events_file_directory,
	const std::string& output_directory,
	int num_rows_per_section,
	int overlap_num,
	int num_header_lines)
{
	std::ifstream event_file{ events_file_directory };

	// skip header
	for (int i{ 0 }; i < num_header_lines && event_file.good(); i++)
	{
		std::string line;
		getline(event_file, line);
	}

	int current_file{ 0 };
	int sub_row_count{ 0 };

	std::string line;
	while (event_file.good() && getline(event_file, line))
	{
		std::ofstream output_file;
		output_file.open(output_directory + "sub" + std::to_string(current_file), std::ofstream::app);

		if (output_file.good())
		{
			output_file << line << std::endl;
			sub_row_count++;
		}
		if (sub_row_count >= num_rows_per_section - overlap_num)
		{
			std::ofstream next_file;
			next_file.open(output_directory + "sub" + std::to_string(current_file + 1), std::ofstream::app);
			next_file << line << std::endl;
			next_file.close();
		}
		if (sub_row_count == num_rows_per_section)
		{
			sub_row_count = overlap_num;
			current_file++;
		}

		output_file.close();
	}

	event_file.close();
}

int main()
{
	std::string events_file_directory{ "C:/Users/rbk20xqk/Documents/ugcs-emlid test001/OUTPUT/M_202004051759_events.pos" };
	std::string output_folder_directory{ "C:/Users/rbk20xqk/Documents/google_backup/data/file_system2/" };

	int num_rows_per_section = 10;
	int overlap_num = 1;

	std::cout << boost::filesystem::remove_all(boost::filesystem::path{ output_folder_directory });

	boost::filesystem::create_directories(boost::filesystem::path{ output_folder_directory });

	int num_header_lines{ 0 };
	int num_data_rows{ 0 };
		
	assignHeaderAndDataNum(events_file_directory, num_header_lines, num_data_rows);

	outputHeaderFile(events_file_directory, output_folder_directory, num_header_lines);

	outputSplitEventFiles(events_file_directory, output_folder_directory, num_rows_per_section, 1, num_header_lines);

}
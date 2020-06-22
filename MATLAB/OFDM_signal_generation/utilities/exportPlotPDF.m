function exportPlotPDF(PLOT,FILE_NAME)
%EXPORTPLOTPDF Simple function to save a pdf of a given plot with a given
%filenam
%   The plot saves to ./MATLAB/figures where '.' is the base directory of
%   the repository. This is found using the directory of this script, so do
%   not move this script file without amending the code!

    % Change the current folder to the folder of this m-file
    if(~isdeployed)

        % fullfile is a Cross-platform way to define directories. We store figures
        % in the figures folder at the same level as the folder this script is in

        exportgraphics(PLOT, fullfile(fileparts(which("exportPlotPDF.m")), '..', '..', 'figures', strcat(FILE_NAME, '.pdf')));

    end



end
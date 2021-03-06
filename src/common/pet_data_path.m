function p = pet_data_path
% Tries to find path to PET raw data.
% The user may like to set a Matlab variable SIRF_PET_DATA_PATH
% to the path to their raw PET data.
% If it is not set, the path to SIRF subfolder /data/examples/PET
% will be used.

SIRF_PET_DATA_PATH = getenv('SIRF_PET_DATA_PATH');
if ~isempty(SIRF_PET_DATA_PATH)
    p = SIRF_PET_DATA_PATH;
else
    SIRF_PATH = getenv('SIRF_PATH');
    if ~isempty(SIRF_PATH)
        p = [SIRF_PATH '/data/examples/PET'];
    else
        p = './';
    end
end
end
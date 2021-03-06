function load_problem_settings(obj, project_dir)
    % Reads the problem settings file

    % Opening file
    settingsFileName = [project_dir,'/problem_settings.txt'];
    settingsFile = fopen(settingsFileName);
    if(settingsFile < 1)
        error(['Failed to find file ',settingsFileName]);
    end

    while ~feof(settingsFile)
        line = fgetl(settingsFile);
        data = split(line);

        if(strcmp(data{1},'DoF_per_Node'))
            obj.DOF_per_node = str2double(data{3});
        elseif(strcmp(data{1},'integration_degree'))
            obj.integrationDegree = str2double(data{3});
        elseif(strcmp(data{1},'problem_type'))
            obj.problem_type = obtain_problem_type(data{3});
        elseif(strcmp(data{1},'source_term'))
            obj.source_term = read_source_term(data{3});
        end
        % More elseifs ?
    end
    
    
    
    function output = read_source_term(input)
        data_split = split(input,',');

        any_link = contains(input,'@');

        if any_link
            link = split(data_split,'@');
            path = [project_dir,'/', link{end}];
            addpath(path)
            output = @source_term;
        else
            lines = split(input,';');
            output = [];
            for i = size(lines,1):-1:1
                line = lines{i};
                cells = split(line,',');
                for j = size(cells,1):-1:1
                    output(i,j) = str2double(cells{j});
                end
            end
        end
    end
end

function problem_type = obtain_problem_type(text)
    problem_type = 0;
    
    % Add items to the list to add new problem types
    problem_types = {'Aeropotential',-2;
                    'Thermal'       ,-1;
                    'Plane_Stress'  , 1;
                    'Plane_Strain'  , 2};
    
    for row = problem_types'
        if(strcmp(text, row{1}))
            problem_type = row{2};
            break;
        end
    end
    
    if problem_type == 0
        error(['Failed to identify problem type ',text]);
    end
end
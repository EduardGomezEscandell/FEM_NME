function calc_gradients(obj, domain)
    % For now only implemented for 2D
         
    obj.grad_u = cell(domain.n_nodes);
    
    gauss_data = cell(domain.nodes_per_elem,1);

    switch domain.n_dimensions
        case 1
            error('Not yet implemented')
        case 2
            switch domain.elem_type
                case 'T'
                    % Triangle
                    error('Not yet implemented')
                    nodes_iso = [ 1  0;
                                  0  1;
                                  0  0;
                                 0.5 0.5;
                                  0  0.5;
                                 0.5 0]; 
                    for i=1:domain.nodes_per_elem
                        node = nodes_iso(i,:);
                        gauss_data{i} = Gauss_point(i, 0, node);
                        gauss_data{i}.triangle_shape_fun(node(1),node(2), domain.interpolationDegree);
                    end         
                    
                case 'Q'
                    % Quad
                    nodes_iso = [-1 -1;
                                  1 -1;
                                  1  1;
                                 -1  1;
                                  0 -1;
                                  1  0;
                                  0  1;
                                 -1  0;
                                  0  0];
                    for i=1:domain.nodes_per_elem
                        node = nodes_iso(i,:);
                        gauss_data{i} = Gauss_point(i, 0, node);
                        gauss_data{i}.quad_shape_fun(node(1),node(2), domain.interpolationDegree);
                    end         
            end
        case 3
            error('Not yet implemented')
    end
    
    for elem_cell = domain.elems
        elem = elem_cell{1}; % Thanks matlab
        
        for i = 1:domain.nodes_per_elem
            
            node_i = elem.nodes{i}.id;
            obj.grad_u{node_i} = zeros(domain.n_dimensions, domain.DOF_per_node);
            
            for j = 1:domain.nodes_per_elem
                node_j = elem.nodes{j}.id;
                
                obj.grad_u{node_i} = obj.grad_u{node_i} + ...
                         elem.invJ*gauss_data{i}.gradN{j} * obj.u_clean(node_j,:);
            end
        end
    end
    
end
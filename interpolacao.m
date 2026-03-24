function [output] = interpolacao(input,r,fs,metodo)

% metodo:
%   'interp'
%   'spline'

switch(metodo)
    case 'interp'
        output = interp(input,r);        
    otherwise
end

end
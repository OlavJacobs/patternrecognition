function [x_fisher,w_fisher] = apply_fisherm(x,N)
% This function implements a Fisher Mapping to transform input data.
% The input to this function should be a real-valued matrix x
% No pre-whitening variance preservation is used, thus ALF = []
w_fisher = fisherm(x,N);
x_fisher = x*w_fisher;
end


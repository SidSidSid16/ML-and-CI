clear; clc; close all;

t = tiledlayout(2,2,"Padding","tight");
ttl = title(t, "Response of LIF neuron model");
ttl.FontSize = 24;
ttl.FontWeight = "bold";


tc = 25;        % Time constant (25ms)
El = 0;         % Resting potential (0)
Vth = 1;        % Firing threshold (0)
R = 1;          % Input resistance (1 Ohm)

tl = 60000;     % Time limit (60 s)
dt = 1;         % Time step (1 ms)
% RmI = 0.8;      % Input condition

I_ext_mag = 0.5;    % External noise avg magnitude
I_ext_std = 7;      % External noise std deviation

% Forward Euler

[V, sp_count_fe, sp_times_fe] = forwardEulerLIF(dt, tc, tl, El, Vth, I_ext_mag, I_ext_std);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Forward Euler');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");

% Backwards Euler

[V, sp_count_be, sp_times_be] = backwardEulerLIF(dt, tc, tl, El, Vth, I_ext_mag, I_ext_std);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Backwards Euler');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");

ist_fe = sp_times_fe(2:sp_count_fe) - sp_times_fe(1:sp_count_fe-1);
ist_be = sp_times_be(2:sp_count_be) - sp_times_be(1:sp_count_be-1);


% t = tiledlayout(2,2,"Padding","tight");
% ttl = title(t, "Histogram of inter-spike intervals");
% ttl.FontSize = 24;
% ttl.FontWeight = "bold";

nexttile;
histogram(ist_fe);
title('Forward euler inter-spike intervals histogram');

nexttile;
histogram(ist_fe);
title('Forward euler inter-spike intervals histogram');

function [V, sp_count, sp_times] = forwardEulerLIF(dt, tc, tl, El, Vth, I_ext_mag, I_ext_std)
    V = zeros(1, tl);
    sp_count = 0;
    sp_times = zeros(3000, 1);
    for t = 2:tl
        I_ext = I_ext_mag + I_ext_std * randn;  % Generate rand noise
        V(t) = V(t-1) * (1 - (dt/tc)) + (dt * ((El + I_ext)/ tc));
        if (V(t) >= Vth)
            sp_count = sp_count + 1;
            sp_times(sp_count) = t;
            V(t) = El;
        end
    end
end

function [V, sp_count, sp_times] = backwardEulerLIF(dt, tc, tl, El, Vth, I_ext_mag, I_ext_std)
    V = zeros(1, tl);
    sp_count = 0;
    sp_times = zeros(3000, 1);
    for t = 2:tl
        I_ext = I_ext_mag + I_ext_std * randn;  % Generate rand noise
        V(t) = (V(t-1) + (dt * ( (El + I_ext)/ tc))) / (1 + (dt * (1/tc)));
        if (V(t) >= Vth)
            sp_count = sp_count + 1;
            sp_times(sp_count) = t;
            V(t) = El;
        end
    end
end

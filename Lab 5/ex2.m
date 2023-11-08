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
RmI = 0.8;      % Input condition

I_ext_mag = 0.5;    % External noise avg magnitude
I_ext_std = 7;      % External noise std deviation

% Forward Euler

[V, sp_count_fe_0_8, sp_times_fe_0_8] = forwardEulerLIF(dt, tc, tl, El, RmI, Vth, I_ext_mag, I_ext_std);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Forward Euler, RmI = 0.8');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");

% Changing RmI to 1.2

RmI = 1.2;
[V, sp_count_fe_1_2, sp_times_fe_1_2] = forwardEulerLIF(dt, tc, tl, El, RmI, Vth, I_ext_mag, I_ext_std);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Forward Euler, RmI = 1.2');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");



% Backwards Euler

% Reset RmI to 0.8
RmI = 0.8;
[V, sp_count_be_0_8, sp_times_be_0_8] = backwardEulerLIF(dt, tc, tl, El, RmI, Vth, I_ext_mag, I_ext_std);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Backwards Euler, RmI = 0.8');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");


% Change RmI to 1.2
RmI = 1.2;
[V, sp_count_be_1_2, sp_times_be_1_2] = backwardEulerLIF(dt, tc, tl, El, RmI, Vth, I_ext_mag, I_ext_std);

nexttile;
plot(V, 'LineWidth', 1)
xlim([0 tl])
ylim([0 1])
title('Backwards Euler, RmI = 0.8');
ylabel("Amplitude / (V)");
xlabel("Time / (ms)");

ist_fe_0_8 = sp_times_fe_0_8(2:sp_count_fe_0_8) - sp_times_fe_0_8(1:sp_count_fe_0_8-1);
ist_fe_1_2 = sp_times_fe_1_2(2:sp_count_fe_1_2) - sp_times_fe_1_2(1:sp_count_fe_1_2-1);
ist_be_0_8 = sp_times_be_0_8(2:sp_count_be_0_8) - sp_times_be_0_8(1:sp_count_be_0_8-1);
ist_be_1_2 = sp_times_be_1_2(2:sp_count_be_1_2) - sp_times_be_1_2(1:sp_count_be_1_2-1);


t = tiledlayout(2,2,"Padding","tight");
ttl = title(t, "Histogram of inter-spike intervals");
ttl.FontSize = 24;
ttl.FontWeight = "bold";

nexttile;
histogram(ist_fe_0_8);
title('Forward Euler, RmI = 0.8');

nexttile;
histogram(ist_fe_1_2);
title('Forward Euler, RmI = 1.2');

nexttile;
histogram(ist_be_0_8);
title('Backward Euler, RmI = 0.8');

nexttile;
histogram(ist_be_1_2);
title('Backward Euler, RmI = 1.2');


function [V, sp_count, sp_times] = forwardEulerLIF(dt, tc, tl, El, RmI, Vth, I_ext_mag, I_ext_std)
    V = zeros(1, tl);
    sp_count = 0;
    sp_times = zeros(3000, 1);
    for t = 2:tl
        I_ext = I_ext_mag + I_ext_std * randn;  % Generate rand noise
        V(t) = V(t-1) * (1 - (dt/tc)) + (dt * ((I_ext + RmI)/ tc));
        if (V(t) >= Vth)
            sp_count = sp_count + 1;
            sp_times(sp_count) = t;
            V(t) = El;
        end
    end
end

function [V, sp_count, sp_times] = backwardEulerLIF(dt, tc, tl, El, RmI, Vth, I_ext_mag, I_ext_std)
    V = zeros(1, tl);
    sp_count = 0;
    sp_times = zeros(3000, 1);
    for t = 2:tl
        I_ext = I_ext_mag + I_ext_std * randn;  % Generate rand noise
        V(t) = (V(t-1) + (dt * ( (I_ext + RmI)/ tc))) / (1 + (dt * (1/tc)));
        if (V(t) >= Vth)
            sp_count = sp_count + 1;
            sp_times(sp_count) = t;
            V(t) = El;
        end
    end
end

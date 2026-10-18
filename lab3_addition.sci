// ====================================================================
// DIGITAL SIGNAL PROCESSING - LAB 3 - ADDITIONAL EXERCISES 2.26-2.35
// Source: textbook reference, Chapter 2, pp. 136-137.
//
// Load once in the Scilab console:
//     exec("lab3_addition.sci", -1);
//
// This script ONLY DEFINES FUNCTIONS; it does not automatically execute
// test cases, open figures, or print PASS/FAIL messages.
// Call ex226 ... ex235 to obtain results and their graphical output.
//
// Exercise 2.26 and 2.30 have unspecified initial conditions. They are
// therefore accepted as function parameters, not silently assumed.
// ====================================================================

// Plot one discrete-time sequence clearly, using integer sample indices.
function lab3a_plot(n, v, caption)
    n = matrix(n, 1, -1);
    v = matrix(v, 1, -1);

    stems = plot2d3(n(:), v(:));
    stems.thickness = 2;
    stems.foreground = 2;
    stems.mark_mode = "on";
    stems.mark_style = 9;
    stems.mark_size_unit = "point";
    stems.mark_size = 6;
    stems.mark_foreground = 2;

    ax = gca();
    step = max(1, ceil((max(n) - min(n)) / 9));
    firstTick = ceil(min(n) / step) * step;
    lastTick = floor(max(n) / step) * step;
    ticks = firstTick:step:lastTick;
    if size(ticks, "*") == 0 then
        ticks = n(1);
    end
    ax.x_ticks = tlist(["ticks", "locations", "labels"], ..
                       ticks(:), string(ticks(:)));
    ax.font_size = 2;

    padding = max(0.5, 0.12 * max(abs(v)));
    ax.data_bounds = [min(n)-0.5, min([0 v])-padding; ..
                      max(n)+0.5, max([0 v])+padding];
    ax.tight_limits = ["on", "on", "off"];
    xgrid(5, 1, 7);
    xtitle(caption, "n", "Amplitude");
endfunction

function lab3a_check_nmax(nmax)
    if nmax < 0 | nmax <> floor(nmax) then
        error("nmax must be a nonnegative integer.");
    end
endfunction

// 2.26: Zero-input solution of y(n)-3y(n-1)-4y(n-2)=0.
// NOTE: The printed book equation starts with x(n), apparently a typo;
// y(n) is used here to match the intended zero-input system and 2.30.
// y_minus1 = y(-1), y_minus2 = y(-2), n >= 0.
function [n, y] = ex226(y_minus1, y_minus2, nmax)
    lab3a_check_nmax(nmax);
    n = 0:nmax;
    A = 16 * (y_minus1 + y_minus2) / 5;
    B = (-y_minus1 + 4 * y_minus2) / 5;
    y = A * (4 .^ n) + B * ((-1) .^ n);

    scf(226); clf();
    lab3a_plot(n, y, "2.26 - Zero-input response");
endfunction

// 2.27: Particular solution of y(n)=5/6 y(n-1)-1/6 y(n-2)+2^n.
// The particular exponential expression satisfies the equation for n>=2
// when the actual input is the one-sided signal 2^n*u(n).
function [n, xp, yp] = ex227(nmax)
    lab3a_check_nmax(nmax);
    n = 0:nmax;
    xp = 2 .^ n;
    yp = (8 / 5) * xp;

    scf(227); clf();
    subplot(2, 1, 1);
    lab3a_plot(n, xp, "2.27 - Input x(n) = 2^n");
    subplot(2, 1, 2);
    lab3a_plot(n, yp, "Particular solution yp(n) = (8/5)2^n");
endfunction

// 2.28: Equation (2.4.30), with the required a1 = -0.9.
// Separates total output into a decaying transient and a steady-state 10.
// Parameter y_minus1 explicitly sets the initial condition y(-1).
function [n, y, transient, steady] = ex228(nmax, y_minus1)
    lab3a_check_nmax(nmax);
    n = 0:nmax;
    a1 = -0.9;
    steady = 10 * ones(1, length(n));
    transient = (y_minus1 - 10) * (0.9 .^ (n + 1));
    y = transient + steady;

    scf(228); clf();
    subplot(3, 1, 1);
    lab3a_plot(n, transient, "2.28 - Transient component");
    subplot(3, 1, 2);
    lab3a_plot(n, steady, "Steady-state component");
    subplot(3, 1, 3);
    lab3a_plot(n, y, "Total step response, a1 = -0.9");
endfunction

// 2.29: Cascade h1(n)=a^n[u(n)-u(n-N)],
//       h2(n)=u(n)-u(n-M), for positive integers N and M.
function [n, h1, h2, h] = ex229(a, N, M)
    if N < 1 | M < 1 | N <> floor(N) | M <> floor(M) then
        error("N and M must be positive integers.");
    end
    h1 = a .^ (0:(N - 1));
    h2 = ones(1, M);
    h = zeros(1, N + M - 1);
    for i = 1:N
        for j = 1:M
            h(i + j - 1) = h(i + j - 1) + h1(i) * h2(j);
        end
    end
    n = 0:(N + M - 2);

    scf(229); clf();
    subplot(3, 1, 1);
    lab3a_plot(0:(N - 1), h1, "2.29 - h1(n)");
    subplot(3, 1, 2);
    lab3a_plot(0:(M - 1), h2, "h2(n)");
    subplot(3, 1, 3);
    lab3a_plot(n, h, "Cascade impulse response h1*h2");
endfunction

// 2.30: y(n)-3y(n-1)-4y(n-2)=x(n)+2x(n-1),
//       x(n)=4^n*u(n). Supply the two unspecified initial values.
// yzs: initially relaxed (zero-state) response;
// yzi: additional zero-input contribution from initial conditions.
function [n, y, yzs, yzi] = ex230(nmax, y_minus1, y_minus2)
    lab3a_check_nmax(nmax);
    n = 0:nmax;
    fourn = 4 .^ n;
    alt = (-1) .^ n;
    yzs = ((30 * n + 26) .* fourn - alt) / 25;
    yzi = (16 * (y_minus1 + y_minus2) / 5) * fourn + ((-y_minus1 + 4 * y_minus2) / 5) * alt;
    y = yzs + yzi;

    scf(230); clf();
    subplot(3, 1, 1);
    lab3a_plot(n, 4 .^ n, "2.30 - Input x(n) = 4^n");
    subplot(3, 1, 2);
    lab3a_plot(n, yzs, "Initially relaxed response");
    subplot(3, 1, 3);
    lab3a_plot(n, y, "Total response including initial conditions");
endfunction

// 2.31: Causal impulse response corresponding to Exercise 2.30.
function [n, h] = ex231(nmax)
    lab3a_check_nmax(nmax);
    n = 0:nmax;
    h = (6 / 5) * (4 .^ n) - (1 / 5) * ((-1) .^ n);

    scf(231); clf();
    lab3a_plot(n, h, "2.31 - Causal impulse response");
endfunction

// 2.32: x(n)=1 on [-2,4], h(n)=2 on [-1,2].
// The full convolution is supported on n in [-3,6].
function [n, y] = ex232()
    nx = -2:4;
    nh = -1:2;
    x = ones(1, length(nx));
    h = 2 * ones(1, length(nh));
    n = -3:6;
    y = zeros(1, length(n));
    for i = 1:length(x)
        for j = 1:length(h)
            y(i + j - 1) = y(i + j - 1) + x(i) * h(j);
        end
    end

    scf(232); clf();
    subplot(3, 1, 1);
    lab3a_plot(nx, x, "2.32 - x(n), -2 <= n <= 4");
    subplot(3, 1, 2);
    lab3a_plot(nh, h, "h(n), -1 <= n <= 2");
    subplot(3, 1, 3);
    lab3a_plot(n, y, "Convolution: partial/full/partial overlap");
endfunction

// 2.33: Impulse and step responses of both causal difference equations.
// (a) y=0.6y(n-1)-0.08y(n-2)+x(n)
// (b) y=0.7y(n-1)-0.1y(n-2)+2x(n)-x(n-2)
function [n, hA, sA, hB, sB] = ex233(nmax)
    lab3a_check_nmax(nmax);
    n = 0:nmax;
    d = zeros(1, length(n));
    d(1) = 1;
    hA = 2 * (0.4 .^ n) - (0.2 .^ n);
    hB = -10 * d - (10 / 3) * (0.5 .^ n) + (46 / 3) * (0.2 .^ n);
    sA = cumsum(hA);
    sB = cumsum(hB);

    scf(233); clf();
    subplot(2, 2, 1);
    lab3a_plot(n, hA, "2.33(a) - Impulse response");
    subplot(2, 2, 2);
    lab3a_plot(n, sA, "2.33(a) - Step response");
    subplot(2, 2, 3);
    lab3a_plot(n, hB, "2.33(b) - Impulse response");
    subplot(2, 2, 4);
    lab3a_plot(n, sB, "2.33(b) - Step response");
endfunction

// 2.34: Causal deconvolution using h(n)=(1/2)^n, 0<=n<=4.
// Recover x(0)...x(8) from the prescribed y(0)...y(8).
// IMPORTANT: The returned samples x(0)...x(8) are NOT a claim that
// x(n)=0 after n=8. Later input samples would be needed to enforce
// the stipulated zero output for all n>=8.
function [n, x, target, reconstructed] = ex234()
    n = 0:8;
    target = [1, 2, 2.5, 3, 3, 3, 2, 1, 0];
    h = 0.5 .^ (0:4);
    x = zeros(1, 9);
    for i = 1:9
        previous = 0;
        for k = 2:min(i, 5)
            previous = previous + h(k) * x(i - k + 1);
        end
        x(i) = target(i) - previous;
    end
    reconstructed = zeros(1, 9);
    for i = 1:9
        for k = 1:min(i, 5)
            reconstructed(i) = reconstructed(i) + h(k) * x(i-k+1);
        end
    end

    scf(234); clf();
    subplot(3, 1, 1);
    lab3a_plot(n, target, "2.34 - Required output y(n)");
    subplot(3, 1, 2);
    lab3a_plot(n, x, "Recovered input x(n), n = 0..8");
    subplot(3, 1, 3);
    lab3a_plot(n, reconstructed, "Reconstructed output, n = 0..8");
endfunction

// 2.35 helper: h = h1 * (h2 - h3*h4), with
// h1=[1/2,1/4,1/2], h2=h3=(n+1)u(n), h4=delta(n-2).
function v = lab3a_h235(n)
    n = matrix(n, 1, -1);
    v = zeros(1, length(n));
    for i = 1:length(n)
        t = n(i);
        if t == 0 then
            v(i) = 1 / 2;
        elseif t == 1 then
            v(i) = 5 / 4;
        elseif t == 2 then
            v(i) = 2;
        elseif t >= 3 then
            v(i) = 5 / 2;
        end
    end
endfunction

// 2.35: x(n)=delta(n+2)+3delta(n-1)-4delta(n-3).
// Output: y(n)=h(n+2)+3h(n-1)-4h(n-3).
function [n, h, y] = ex235(nmax)
    if nmax < 6 | nmax <> floor(nmax) then
        error("For Exercise 2.35, use integer nmax >= 6.");
    end
    n = -3:nmax;
    x = zeros(1, length(n));
    for i = 1:length(n)
        if n(i) == -2 then
            x(i) = 1;
        elseif n(i) == 1 then
            x(i) = 3;
        elseif n(i) == 3 then
            x(i) = -4;
        end
    end
    h = lab3a_h235(n);
    y = lab3a_h235(n + 2) + 3 * lab3a_h235(n - 1) - 4 * lab3a_h235(n - 3);

    scf(235); clf();
    subplot(3, 1, 1);
    lab3a_plot(n, x, "2.35 - Three-impulse input x(n)");
    subplot(3, 1, 2);
    lab3a_plot(n, h, "Overall LTI impulse response h(n)");
    subplot(3, 1, 3);
    lab3a_plot(n, y, "Interconnected system output y(n)");
endfunction

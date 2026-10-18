// Draw a readable discrete-time stem plot (integer indices, light grid).
function plot_signal(samples, origin, heading)
    samples = matrix(samples, 1, -1);
    n = (1:length(samples)) - origin;

    // Scilab 2026: plot2d3 returns the stem-plot handle.
    stems = plot2d3(n(:), samples(:));
    stems.thickness = 2;
    stems.foreground = 2;
    stems.mark_mode = "on";
    stems.mark_style = 9;              // Circle markers at each sample
    stems.mark_size_unit = "point";
    stems.mark_size = 6;
    stems.mark_foreground = 2;

    // Avoid Scilab's default 0.1-spaced ticks on an integer time axis.
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

    padding = max(0.5, 0.12 * max(abs(samples)));
    ax.data_bounds = [min(n)-0.5, min([0 samples])-padding; ..
                      max(n)+0.5, max([0 samples])+padding];
    ax.tight_limits = ["on", "on", "off"];
    xgrid(5, 1, 7);                    // Light, sparse dashed grid
    xtitle(heading, "Sample index n", "Amplitude");
endfunction

// Align two finite sequences on the union of their n-index ranges.
// Values beyond a sequence's support are treated as zeros.
function [a, b, commonOrigin] = align_signals(x1n, x1origin, x2n, x2origin)
    x1n = matrix(x1n, 1, -1);
    x2n = matrix(x2n, 1, -1);

    first1 = 1 - x1origin;
    last1  = length(x1n) - x1origin;
    first2 = 1 - x2origin;
    last2  = length(x2n) - x2origin;

    first = min(first1, first2);
    last  = max(last1, last2);
    L = last - first + 1;

    a = zeros(1, L);
    b = zeros(1, L);

    start1 = first1 - first + 1;
    start2 = first2 - first + 1;
    a(start1:(start1 + length(x1n) - 1)) = x1n;
    b(start2:(start2 + length(x2n) - 1)) = x2n;

    commonOrigin = 1 - first;
endfunction

// Exercise 1: y(n) = x(n-k), k > 0.
function [yn, yorigin] = delay(xn, xorigin, k)
    if k <= 0 | k <> floor(k) then
        error("delay: k must be a positive integer.");
    end
    yn = matrix(xn, 1, -1);
    yorigin = xorigin - k;

    scf(1); clf();
    subplot(2, 1, 1);
    plot_signal(xn, xorigin, "Exercise 1 - Original x(n)");
    subplot(2, 1, 2);
    plot_signal(yn, yorigin, "Delayed y(n) = x(n-k)");
endfunction

// Exercise 2: y(n) = x(n+k), k > 0.
function [yn, yorigin] = advance(xn, xorigin, k)
    if k <= 0 | k <> floor(k) then
        error("advance: k must be a positive integer.");
    end
    yn = matrix(xn, 1, -1);
    yorigin = xorigin + k;

    scf(2); clf();
    subplot(2, 1, 1);
    plot_signal(xn, xorigin, "Exercise 2 - Original x(n)");
    subplot(2, 1, 2);
    plot_signal(yn, yorigin, "Advanced y(n) = x(n+k)");
endfunction

// Exercise 3: y(n) = x(-n).
function [yn, yorigin] = fold(xn, xorigin)
    xn = matrix(xn, 1, -1);
    yn = xn($:-1:1);
    yorigin = length(xn) - xorigin + 1;

    scf(3); clf();
    subplot(2, 1, 1);
    plot_signal(xn, xorigin, "Exercise 3 - Original x(n)");
    subplot(2, 1, 2);
    plot_signal(yn, yorigin, "Folded y(n) = x(-n)");
endfunction

// Exercise 4: y(n) = x1(n) + x2(n).
function [yn, yorigin] = add(x1n, x1origin, x2n, x2origin)
    [a, b, yorigin] = align_signals(x1n, x1origin, x2n, x2origin);
    yn = a + b;

    scf(4); clf();
    subplot(3, 1, 1);
    plot_signal(x1n, x1origin, "Exercise 4 - First input x1(n)");
    subplot(3, 1, 2);
    plot_signal(x2n, x2origin, "Second input x2(n)");
    subplot(3, 1, 3);
    plot_signal(yn, yorigin, "Sum y(n) = x1(n) + x2(n)");
endfunction

// Exercise 5: y(n) = x1(n) * x2(n) (pointwise product).
function [yn, yorigin] = multi(x1n, x1origin, x2n, x2origin)
    [a, b, yorigin] = align_signals(x1n, x1origin, x2n, x2origin);
    yn = a .* b;

    scf(5); clf();
    subplot(3, 1, 1);
    plot_signal(x1n, x1origin, "Exercise 5 - First input x1(n)");
    subplot(3, 1, 2);
    plot_signal(x2n, x2origin, "Second input x2(n)");
    subplot(3, 1, 3);
    plot_signal(yn, yorigin, "Pointwise product y(n) = x1(n).*x2(n)");
endfunction

// Exercise 6: linear convolution y(n) = sum_k x(k)*h(n-k).
// Direct summation ensures full convolution, with no circular wrap.
function [yn, yorigin] = convolution(xn, xorigin, hn, horigin)
    xn = matrix(xn, 1, -1);
    hn = matrix(hn, 1, -1);
    Nx = length(xn);
    Nh = length(hn);

    yn = zeros(1, Nx + Nh - 1);
    for i = 1:Nx
        for j = 1:Nh
            yn(i + j - 1) = yn(i + j - 1) + xn(i) * hn(j);
        end
    end
    yorigin = xorigin + horigin - 1;

    scf(6); clf();
    subplot(3, 1, 1);
    plot_signal(xn, xorigin, "Exercise 6 - Input x(n)");
    subplot(3, 1, 2);
    plot_signal(hn, horigin, "Impulse response h(n)");
    subplot(3, 1, 3);
    plot_signal(yn, yorigin, "Linear convolution y(n) = x(n)*h(n)");
endfunction

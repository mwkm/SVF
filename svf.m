%{

    Sub-Window Variace Filter
    MATLAB reference implementation of our filter in my article titled:

    Multi-scale Image Decomposition Using a Local Statistical Edge Model
    https://ieeexplore.ieee.org/document/9483837

    copyright(c) 2021 Kin-Ming Wong (Mike Wong)


    Example use:
        [A, result] = svf(double(imread('cat.png'))/255.0, 3, 0.025);
        imshow(result);

    If you have used this reference code in your research or work; please
    consider citing my paper.

    @INPROCEEDINGS{9483837,
    author={Wong, Kin-Ming},
    booktitle={2021 IEEE 7th International Conference on Virtual Reality (ICVR)}, 
    title={Multi-scale Image Decomposition Using a Local Statistical Edge Model}, 
    year={2021},
    volume={},
    number={},
    pages={10-18},
    doi={10.1109/ICVR51878.2021.9483837}}

%}

%   Parameters
%       s = source image of 'double' type
%       r = filter radius (in pixels)
%       e = epsilon (threshold variance value of a clear edge to preserve)
%
%   Returns:
%       A   = An image of per-pixel preservation factor
%       SVF = filtered image

function [A, SVF] = svf( s, r, e )

    h  = size( s, 1 );
    w  = size( s, 2 );
    ch = size( s, 3 );
    
    %   Pad image borders to avoid conditionals in Kernel
    im = padarray( s, [r r], 'symmetric' );
    
    %   Prepare first round SAT
    satI  = integralImage(im);
    satI2 = integralImage(im .* im);

    %   Pre-allocate variance buffers
    vW = zeros(h,w,ch);
    uW = zeros(h,w,ch);
    vA = zeros(h,w,ch);
    uA = zeros(h,w,ch);
    vB = zeros(h,w,ch);
    uB = zeros(h,w,ch);
    vC = zeros(h,w,ch);
    uC = zeros(h,w,ch);
    vD = zeros(h,w,ch);
    uD = zeros(h,w,ch);
 
    %   Whole window and sub-window variance
    kWin = r + r + 1;
    kernW = integralKernel([1 1 kWin kWin], 1/(kWin * kWin));

    kw = r + 1;
    kernA = integralKernel([1 1 kw kw; kw+1 1 r kw; 1 r+2 r+kw r], [ 1/(kw * kw), 0, 0 ] );
    kernB = integralKernel([1 1 r r+1; kw 1 kw kw; 1 r+2 r+kw r], [ 0, 1/(kw * kw), 0 ] );
    kernC = integralKernel([ 1 1 r+kw r; 1 kw kw kw; kw+1 kw r kw ], [ 0, 1/(kw * kw), 0 ] );
    kernD = integralKernel([1 1 r+kw r; 1 kw r kw; kw kw kw kw], [ 0, 0, 1/(kw * kw) ] );

    for i = 1:ch
        vW(:,:,i) = integralFilter( satI2(:,:,i), kernW );    %   MEAN(I2)
        uW(:,:,i) = integralFilter(  satI(:,:,i), kernW );    %   MEAN(I)
        vA(:,:,i) = integralFilter( satI2(:,:,i), kernA );    %   MEAN(I2)
        uA(:,:,i) = integralFilter(  satI(:,:,i), kernA );    %   MEAN(I)
        vB(:,:,i) = integralFilter( satI2(:,:,i), kernB );    %   MEAN(I2)
        uB(:,:,i) = integralFilter(  satI(:,:,i), kernB );    %   MEAN(I)
        vC(:,:,i) = integralFilter( satI2(:,:,i), kernC );    %   MEAN(I2)
        uC(:,:,i) = integralFilter(  satI(:,:,i), kernC );    %   MEAN(I)
        vD(:,:,i) = integralFilter( satI2(:,:,i), kernD );    %   MEAN(I2)
        uD(:,:,i) = integralFilter(  satI(:,:,i), kernD );    %   MEAN(I)
    end    
    
    vW = vW - (uW .* uW);
    vA = vA - (uA .* uA);
    vB = vB - (uB .* uB);
    vC = vC - (uC .* uC);
    vD = vD - (uD .* uD);
    
    maxV = max( max(max(vA, vB), max(vC, vD)), vW);
    minV = min( min(vA, vB), min(vC, vD) );
    Ak = min( 1, maxV ./ (minV + e) );
    
    %   Per-patch Ak and Bk
    Ak = max( max(Ak(:,:,1), Ak(:,:,2)), Ak(:,:,3) );
    Bk = zeros(h,w,ch);
    for i = 1:ch
        Bk(:,:,i) = (1 - Ak) .* uW(:,:,i);
    end
    
    %   2nd stage SAT for per-pixel Ak and Bk
    Ak = padarray(Ak,[r r],'symmetric');
    Bk = padarray(Bk,[r r],'symmetric');
    satAk = integralImage(Ak);
    satBk = integralImage(Bk);
    
    %   Per-pixel Ak & Bk
    A  = integralFilter( satAk, kernW );
    B  = zeros(h,w,ch);
    for i = 1:ch
        B(:,:,i) = integralFilter( satBk(:,:,i), kernW );
    end
    
    %   Final filtering
    SVF   = zeros(h,w,ch);
    for i = 1:ch
        SVF(:,:,i) = A .* s(:,:,i) + B(:,:,i);
    end
        
end

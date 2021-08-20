%{

    Image Detail Enhancement using Sub-Window Variace Filter
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
%       inName  = Name of your PNG image sans extension
%       radius  = filter radius (in pixels)
%       epsilon = epsilon (threshold variance value of a clear edge to preserve)
%       mAmp    = Medium details enhancement factor
%       fAmp    = Fine details enhancement factor
%
%   Outputs:
%       The enhanced image
%

function svEnhance( inName, radius, epsilon, mAmp, fAmp )

    inFILE = sprintf( '%s.png' ,inName);
    inImage = double(imread(inFILE))/255.0; 
    [~, base0] = svFilter( inImage, radius, epsilon );
    detailF = inImage - base0;
    [~, base1] = svf( base0, radius * 4, epsilon * 2 );
    detailM = base0 - base1;
    
    figure;
    imshow(inImage);
    figure;
    result = base1 + mAmp * detailM + fAmp * detailF;
    imshow(result);
    
    detail = detailM + detailF;
    
%    out_DETAIL = sprintf( '%s_DETAIL.png' ,inName);
%    imwrite(detail + 0.5, out_DETAIL);
    
%    out_BASE = sprintf( '%s_BASE.png' ,inName);    
%    imwrite(base1, out_BASE);    
    
    out_RESULT = sprintf( '%s_RESULT.png' ,inName);    
    imwrite(result, out_RESULT);

end
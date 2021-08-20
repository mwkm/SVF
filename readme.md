## Sub-window Variance Filter

This is a reference MATLAB implementation of the _**Sub-window Variance filter**_ described in our article [_Multi-scale Image Decomposition Using a Local Statistical Edge Model_](https://ieeexplore.ieee.org/document/9483837).  Our filter uses **Summed Area Table** (integral image) as an acceleration means, and it is also gradient-preserving, i.e. has no gradient reversal problem. (paper preprint [here](https://arxiv.org/abs/2105.01951))

This code has been tested on MATLAB R2019b.

By using `svf.m`, you may quickly filter an image with the following command and have the result displayed in MATLAB.

    [A, result] = svf(double(imread('cat.png'))/255.0, 3, 0.025);
    imshow(result);

<img src="cat.png" alt="Input" width=256/> | <img src="cat_A.png" alt="Input" width=256/> | <img src="cat_SVF.png" alt="Input" width=256/> 
:---: | :---: | :---:  
*Input* | *Per-pixel preservation* (A) | *Filtered* (result)

Please see `svEnhance.m` for an example of how to enhance the image detail.

<img src="cat_Enhanced.png" alt="Input" width=256/> |
:---: |
*Both medium and fine details enhanced* |

If you have used this code in your research or work, please consider citing our paper:

    @INPROCEEDINGS{9483837,
        author={Wong, Kin-Ming},
        booktitle={2021 IEEE 7th International Conference on Virtual Reality (ICVR)},
        title={Multi-scale Image Decomposition Using a Local Statistical Edge Model},
        year={2021},
        volume={},
        number={},
        pages={10-18},
        doi={10.1109/ICVR51878.2021.9483837}
    }


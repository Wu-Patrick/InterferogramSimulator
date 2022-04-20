# Interferogram Simulator

This code provides a dataset simulation method that can provide training samples with strong generalization ability for model training. Deep learning, as a data-driven method, requires a large number of training samples to train network models. However, it is difficult or even impossible to obtain ground truth corresponding to InSAR data because it is difficult to collect high-resolution ground deformation information, which limits the application of deep learning in the field of InSAR. In this paper, we study the phase characteristics of a large number of real interferograms, analyze the statistical models of InSAR data and noise sources, and propose a strategy to construct training samples by simulating the phase components of terrain, buildings, deformation, atmosphere, water surface and noise separately, which is applicable to training networks for different tasks such as **interferogram denoising**, **deformation detection** and **phase unwrapping**. Experimental results show that this dataset simulation method can effectively train deep network models with good generalization ability on real data.

The code was tested on MATLAB R2021b.



## The code will be released soon！



## Citation

If you use this code, please cite the following:
~~~BibTeX
@ARTICLE{9583246,
  author={Wu, Zhipeng and Wang, Teng and Wang, Yingjie and Wang, Robert and Ge, Daqing},
  journal={IEEE Transactions on Geoscience and Remote Sensing}, 
  title={Deep-Learning-Based Phase Discontinuity Prediction for 2-D Phase Unwrapping of SAR Interferograms}, 
  year={2022},
  volume={60},
  number={},
  pages={1-16},
  doi={10.1109/TGRS.2021.3121906}}
  
@ARTICLE{9583229,
  author={Wu, Zhipeng and Wang, Teng and Wang, Yingjie and Wang, Robert and Ge, Daqing},
  journal={IEEE Transactions on Geoscience and Remote Sensing}, 
  title={Deep Learning for the Detection and Phase Unwrapping of Mining-Induced Deformation in Large-Scale Interferograms}, 
  year={2022},
  volume={60},
  number={},
  pages={1-18},
  doi={10.1109/TGRS.2021.3121907}}
~~~


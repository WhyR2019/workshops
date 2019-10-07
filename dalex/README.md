# auditor + DALEX: a powerful duet for validation and explanation of machine learning models

Workshop on `auditor` and `DALEX` ([WhyR2019](https://github.com/WhyR2019))

Authors: Alicja Gosiewska, Tomasz Mikołajczyk ([MI2 Data Lab](http://mi2.mini.pw.edu.pl))

## Description

The goal of the workshop is to familiarize participants with modern methods of model verification and exploration. This will be a hands-on tutorial, where we will demonstrate the use of `auditor` and `DALEX` packages for visual validation and explanation of machine learning algorithms. 

The `auditor` package facilitates assessing and comparing the goodness of fit and performance of models. In addition, it may be used for the analysis of the similarity of residuals and for identification of outliers and influential observations. The examination is carried out by diagnostic scores and visual verification. 

The `DALEX` helps to understand the way complex models work. It contains various explainers that are used to visualize a link between input variables and model output. `DALEX` offers a wide range of state-of-the-art techniques for model exploration. Some of these techniques are more useful for understanding model predictions; other techniques are more handy for understanding model structure.

The workshop is divided into two parts. 

**Part one**
We introduce the idea of DALEX explanations. We show how to use them to assess the performance of a model and explain the model's predictions.
Code is in file [`part_1_explain.R`](https://github.com/agosiewska/auditor-whyr2019/blob/master/part_1_explain.R).


**Part two**
We go into details of auditor's functionalities. We show how the analysis of residuals may be used to choose the best model or even improve models.
Code is in file [`part_2_improve.R`](https://github.com/agosiewska/auditor-whyr2019/blob/master/part_2_improve.R).

**The summary of workshop is in the [Slides](https://github.com/agosiewska/auditor-whyr2019/blob/master/Slides-auditor-WhyR2019.pdf).**

## More

The book [Predictive Models: Explore, Explain, and Debug](https://pbiecek.github.io/PM_VEE/preface.html) (Przemyslaw Biecek and Tomasz Burzykowski) - detailed review of machine learning models explanations with examples.

A blog post [auditor: a guided tour through residuals](https://feelml.com/post/2019-09-10-auditor/) with gentle introduction to residual plots.

Package's repos:
- [`auditor`](https://github.com/ModelOriented/auditor)
- [`DALEX`](https://github.com/ModelOriented/DALEX)
- [`DrWhy.AI`](https://github.com/ModelOriented/DrWhy/blob/master/README.md)
- [`ingredients`](https://github.com/ModelOriented/ingredients)
- [`iBreakDown`](https://github.com/ModelOriented/iBreakDown)




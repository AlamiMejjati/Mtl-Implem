# Mtl-Implem

This is a matlab implementation of the paper bellow:
http://pages.cs.wisc.edu/~ji-liu/paper/Jianhui-Ji-TKDD.pdf

The script to run is called main. All the dataset, but Ar face dataset are available 
in the folder 'datasets'. Ar face dataset is too big to put in the archive. And also it is not public.

However one could ask for the dataset in here
http://www2.ece.ohio-state.edu/~aleix/ARdatabase.html 

Im the main script, the variable dataname allows one to choose the dataset to use. There is 3 choices: 
'face' 'scene' 'school'

If 'face' is choosen, one should know that since we treat images, the algorithm is very time consuming.
To avoid spending a day on training,'max_iter' is restrained to 1000.

The results are quite similar to the paper. However the parameters were not crossvalidated like in the paper,
An heuristic choice of the parameters has been made.

The results for the feature extraction can be seen in the folder, feature extraction. 
Each picture shows the P (left) and Q (right) matrix learned. 
We can see that the sparse matrix captures details of the face. The low rank matrix on the other hand captures 
the general shape of the face. 

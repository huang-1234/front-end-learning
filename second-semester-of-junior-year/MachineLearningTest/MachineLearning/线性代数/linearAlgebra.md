# 线性代数

![img](linearAlgebra.assets/54419d5871cd4993b47b2548ad3a02f0~tplv-k3u1fbpfcp-watermark.image)

# 机器学习数学基础: [线性代数篇](https://juejin.cn/post/6916842728202600455#heading-0)

 

机器学习中涉及大量的矩阵运算，线性代数知识对学习机器学习非常关键，本文对机器学习中所涉及到的线性代数部分进行总结

### 一. 基本符号概念

#### 1.1 标量(scalar)

标量， 是只有大小、没有方向、可用实数表示的一个量

 

#### 1.2 向量(vector)

向量，是同时具有大小和方向的几何对象。向量可以表示为行向量或者列向量

$$
\vec{a} = \begin{bmatrix} a&b&c \end
{bmatrix}*a*=[*a**b**c*]
$$

*or*
$$
\vec{a} = \begin{bmatrix} a \\ b \\ c \end{bmatrix}*a*=⎣⎢⎡*a**b**c*⎦⎥⎤
$$

 

#### 1.3 矩阵(matrix)

一个的矩阵是一个由 m 行 n 列 元素排列成的矩形阵列。通常用大写字母表示，一个矩阵 A*A* 从左上角数起的第 i*i* 行第 j*j* 列上的元素称为第 i, j*i*,*j* 项，通常记为 A_{ij}*A**i**j* 。如下是一个3行4列的矩阵:

A= \begin{bmatrix} 1 & 4& 4 & 9 \\ -1 & 2& 4 & 8 \\ 0& 9 & -1 & 1 \end{bmatrix}*A*=⎣⎢⎡1−1042944−1981⎦⎥⎤

**方阵**：行数与列数相同的矩阵称为方阵

**对角矩阵**：如果一个方阵只有主对角线上的元素不是0，其它都是0，那么称其为对角矩阵

**单位矩阵**：如果一个对角矩阵的主对角线元素都是1， 那么该矩阵就是单位矩阵

 

#### 1.4 张量(tensor)

张量可以看作是多维数组，它们是标量，1维矢量和2维矩阵的多维推广。 参考TensorFlow文档，可认为：

- 标量可称为 "0 秩" 张量，包含单个值，没有轴
- 标量可称为 "1 秩" 张量， 包含一个值得列表，有一个轴
- 矩阵可称为 "2 秩" 张量，有 2 个轴

下图非常形象的阐述了上述内容:

![img](linearAlgebra.assets/6e9c839f06294061930f8c78785cf6d0~tplv-k3u1fbpfcp-watermark.image)

而张量的可视化，下图是同一个3轴张量的3种可视化方式:

![img](linearAlgebra.assets/e80c1c54c9d746169beac8fd056d43b6~tplv-k3u1fbpfcp-watermark.image)

 

### 二. 运算

#### 2.1 向量内积

内积 (dot product)，也称点积，数量积，其结果是一个标量 两个 向量

$$
{\displaystyle {\vec {a}}=[a_{1},a_{2},\cdots ,a_{n}]}*a*=[*a*1,*a*2,⋯,*a**n*] 和 {\displaystyle {\vec {b}}=[b_{1},b_{2},\cdots ,b_{n}]}*b*=[*b*1,*b*2,⋯,*b**n*]
$$
 的点积定义为：

{\displaystyle {\vec {a}}\cdot {\vec {b}}=\sum _{i=1}^{n}a_{i}b_{i}=a_{1}b_{1}+a_{2}b_{2}+\cdots +a_{n}b_{n}}*a*⋅*b*=*i*=1∑*n**a**i**b**i*=*a*1*b*1+*a*2*b*2+⋯+*a**n**b**n*

 

#### 2.2 向量外积

外积 (outer product），在线性代数中一般指两个向量的张量积，其结果为一矩阵，举例如下:

\begin{bmatrix}b_1 \\ b_2 \\ b_3 \\ b_4\end{bmatrix} \otimes \begin{bmatrix}a_1 & a_2 & a_3\end{bmatrix} = \begin{bmatrix}a_1b_1 & a_2b_1 & a_3b_1 \\ a_1b_2 & a_2b_2 & a_3b_2 \\ a_1b_3 & a_2b_3 & a_3b_3 \\ a_1b_4 & a_2b_4 & a_3b_4\end{bmatrix}⎣⎢⎢⎢⎡*b*1*b*2*b*3*b*4⎦⎥⎥⎥⎤⊗[*a*1*a*2*a*3]=⎣⎢⎢⎢⎡*a*1*b*1*a*1*b*2*a*1*b*3*a*1*b*4*a*2*b*1*a*2*b*2*a*2*b*3*a*2*b*4*a*3*b*1*a*3*b*2*a*3*b*3*a*3*b*4⎦⎥⎥⎥⎤

 

#### 2.3 矩阵乘法

若 {\displaystyle A}*A* 为 {\displaystyle m\times n}*m*×*n* 矩阵，{\displaystyle B}*B* 为 {\displaystyle n\times p}*n*×*p* 矩阵，则他们的乘积 {\displaystyle AB}*A**B* 会是一个 {\displaystyle m\times p}*m*×*p* 矩阵。其乘积矩阵的元素如下面式子得出：

{\displaystyle (AB)_{ij}=\sum _{r=1}^{n}a_{ir}b_{rj}=a_{i1}b_{1j}+a_{i2}b_{2j}+\cdots +a_{in}b_{nj}}(*A**B*)*i**j*=*r*=1∑*n**a**i**r**b**r**j*=*a**i*1*b*1*j*+*a**i*2*b*2*j*+⋯+*a**i**n**b**n**j*

用图示来表示即为：

![img](linearAlgebra.assets/395fb883b27f468d9384b73dcb93da90~tplv-k3u1fbpfcp-watermark.image)

可以认为，矩阵乘法是向量内积的一个拓展，对相对应的行和列向量进行内积(点积)，即可得到矩阵在相应位置的元素

 

#### 2.4 矩阵转置

转置(transpose)，表示为 A^T*A**T* ，即把矩阵 A*A* 的横行写为其纵列，把 A*A* 的纵列写为其横行。数学表示为:

A_{ij}^{\mathrm {T} }=A_{ji}*A**i**j*T=*A**j**i*

举例如下：

{\displaystyle {\begin{bmatrix}1&2\\3&4\\5&6\end{bmatrix}}^{\mathrm {T} }={\begin{bmatrix}1&3&5\\2&4&6\end{bmatrix}}}⎣⎢⎡135246⎦⎥⎤T=[123456]

 

#### 2.5 逆矩阵

逆矩阵 (inverse matrix)，给定一个n阶方阵 {{A} }*A* ，若存在一n阶方阵 {{B} }*B* ，使得 :

{{AB} = {BA} = {I} _{n}}*A**B*=*B**A*=*I**n* ，

其中 {\displaystyle {I} _{n}}*I**n*为 n*n* 阶单位矩阵，则称 {\displaystyle {A} }*A* 是可逆的，且 {\displaystyle {B} }*B* 是 {\displaystyle {A} }*A* 的逆矩阵，记作 {\displaystyle {A} ^{-1}}*A*−1 只有方阵（n×n*n*×*n* 的矩阵）才可能有逆矩阵。若方阵 {\displaystyle {A} }*A* 的逆矩阵存在，则称 {\displaystyle {A} }*A* 为非奇异方阵或可逆方阵

 

### 三. 矩阵分解

#### 3.1 特征值和特征向量

给定一个方阵 A*A*， \lambda*λ* 被称为 A*A* 的一个特征值(eigenvalue)，当存在一个向量 v*v* 满足 {\displaystyle Av=\lambda v}*A**v*=*λ**v*， 此时， v*v* 是 A*A* 的特征向量(eigenvector)

 

#### 3.2 奇异值分解

奇异值分解(singular value decomposition, SVD) 分解能够用于任意 {\displaystyle m\times n}*m*×*n* 矩阵，而特征分解只能适用于特定类型的方阵，故奇异值分解的适用范围更广

假设 A*A* 是一个 m×n*m*×*n* 阶矩阵，我们定义 A*A* 的奇异值分解为 {\displaystyle A=U\Sigma V^{*},\,}*A*=*U*Σ*V*∗, 其中 U*U* 是 m×m 阶矩阵；\SigmaΣ 是 m×n 阶； V^{*}*V*∗是 n×n 阶矩阵； U*U* 和 V^{*}*V*∗都是酋矩阵，即满足 U^TU=I*U**T**U*=*I* , V^{*T}V^{*}=I*V*∗*T**V*∗=*I* ， \SigmaΣ 是除了主对角线上的元素以外全为0，主对角线上的元素称为奇异值。

下图很形象的展示了SVD: ![img](linearAlgebra.assets/e66f6ef3c0fd4c7fb122d6445a443033~tplv-k3u1fbpfcp-watermark.image) 在机器学习中，用于降维的算法PCA非常常用，其在计算过程中可以转化为SVD，从而降低计算复杂度。除此之外，SVD在推荐系统中也几乎不可缺少

 

#### 3.3 奇异值分解的计算

给定一个 M*M* 的奇异值分解，根据上面的论述，两者的关系式如下 (其中 M^{*}*M*∗ 是 M*M* 的共轭转置矩阵(转置矩阵推广到复数))：

- {\displaystyle M^{*}M=V\Sigma ^{*}U^{*}\,U\Sigma V^{*}=V(\Sigma ^{*}\Sigma )V^{*}\,}*M*∗*M*=*V*Σ∗*U*∗*U*Σ*V*∗=*V*(Σ∗Σ)*V*∗
- {\displaystyle MM^{*}=U\Sigma V^{*}\,V\Sigma ^{*}U^{*}=U(\Sigma \Sigma ^{*})U^{*}\,}*M**M*∗=*U*Σ*V*∗*V*Σ∗*U*∗=*U*(ΣΣ∗)*U*∗

关系式的右边描述了关系式左边的特征值分解。于是：

- {\displaystyle V}*V* 的列向量（右奇异向量）是 {\displaystyle M^{*}M}*M*∗*M* 的特征向量。
- {\displaystyle U}*U* 的列向量（左奇异向量）是 {\displaystyle MM^{*}}*M**M*∗ 的特征向量。
- {\displaystyle \Sigma }Σ 的非零对角元（非零奇异值）是 {\displaystyle M^{*}M}*M*∗*M* 或者 {\displaystyle MM^{*}}*M**M*∗ 的非零特征值的平方根。

故通过计算出 M^{*}M*M*∗*M* 的特征向量和特征值， MM^{*}*M**M*∗ 的特征向量和特征值， 即完成了对 M*M* 的奇异值分解

 

### 四. 距离及相似度量

#### 4.1 曼哈顿距离

也即 L1 范数，定义为：

{\displaystyle \|{\boldsymbol {x}}\|=\sum_{i=1}^{n}|x_i|}∥**x**∥=*i*=1∑*n*∣*x**i*∣ ,

其在机器学习中最常见的应用即 L1*L*1 正则化，也称 Lasso

 

#### 4.2 欧氏距离

也称 L2 范数，定义为，各元素平方的和，表示为:

{\displaystyle \|{\boldsymbol {x}}\|_{2}= \sqrt{\sum_{i=1}^{n}{x_i}^2}= {\sqrt {x_{1}^{2}+\cdots +x_{n}^{2}}}}∥**x**∥2=*i*=1∑*n**x**i*2=*x*12+⋯+*x**n*2 ,

其应用为 L2*L*2 正则化，也称 Ridge L1*L*1 和 L2*L*2 正则化在机器学习模型中应用极为广泛，主要用于降低模型复杂度，减小过拟合

 

#### 4.3 Lp 范数

Lp*L**p* 范数定义为：

{\displaystyle \lVert {\vec {x}}\rVert _{\infty }=\lim _{p\to -\infty }{\Bigl (}\sum \limits _{i=1}^{n}|x_{i}|^{p}{\Bigr )}^{1/p}=\min _{i}|x_{i}|}∥*x*∥∞=*p*→−∞lim(*i*=1∑*n*∣*x**i*∣*p*)1/*p*=*i*min∣*x**i*∣ ， 当 p*p* 取不同值时，我们可以得到不同的范数

- {\displaystyle p=1}*p*=1 时：{\displaystyle \lVert {\vec {x}}\rVert _{1}=\sum \limits _{i=1}^{n}|x_{i}|}∥*x*∥1=*i*=1∑*n*∣*x**i*∣ ，即 {\displaystyle L_{1}}*L*1 ，范数是向量各分量绝对值之和，又称曼哈顿距离
- {\displaystyle p=2}*p*=2 时： {\displaystyle \lVert {\vec {x}}\rVert _{2}={\sqrt {\sum \limits _{i=1}^{n}|x_{i}|^{2}}}}∥*x*∥2=*i*=1∑*n*∣*x**i*∣2 , 即 L2*L*2 ，此时为欧式距离
- {\displaystyle p=+\infty }*p*=+∞ 时： {\displaystyle \lVert {\vec {x}}\rVert _{\infty }=\lim _{p\to +\infty }{\Bigl (}\sum \limits _{i=1}^{n}|x_{i}|^{p}{\Bigr )}^{1/p}=\max _{i}|x_{i}|}∥*x*∥∞=*p*→+∞lim(*i*=1∑*n*∣*x**i*∣*p*)1/*p*=*i*max∣*x**i*∣，此即最大范数，也称切比雪夫距离

 

#### 4.4 余弦相似性

给定两个向量 A*A* 和 B*B* ，其余弦相似性 \theta*θ* 由点积和向量长度给出，如下所示：

{\displaystyle {\text{similarity}}=\cos(\theta )={A\cdot B \over \|A\|\|B\|}={\frac {\sum \limits _{i=1}^{n}{A_{i}\times B_{i}}}{{\sqrt {\sum \limits _{i=1}^{n}{(A_{i})^{2}}}}\times {\sqrt {\sum \limits _{i=1}^{n}{(B_{i})^{2}}}}}}}similarity=cos(*θ*)=∥*A*∥∥*B*∥*A*⋅*B*=*i*=1∑*n*(*A**i*)2×*i*=1∑*n*(*B**i*)2*i*=1∑*n**A**i*×*B**i*，

余弦相似度取值范围为 [-1, 1][−1,1] ，-1−1 意味着两个向量指向的方向正好相反，11 表示它们的指向是完全相同的，00 通常表示它们之间是独立的，而在这之间的值则表示中间的相似性或相异性，值越大，相似度越大

 

#### 4.5 汉明距离

汉明距离(Hamming distance) 是指将一个字符串变换成另外一个等长字符串所需要替换的字符个数 例如 "touch" 和 "teach" 之间的汉明距离为 2

 

#### 4.6 Jaccard 相似系数

其定义为两个集合交集大小与并集大小之比:

{\displaystyle J(A,B)={{|A\cap B|} \over {|A\cup B|}}={{|A\cap B|} \over {|A|+|B|-|A\cap B|}}}*J*(*A*,*B*)=∣*A*∪*B*∣∣*A*∩*B*∣=∣*A*∣+∣*B*∣−∣*A*∩*B*∣∣*A*∩*B*∣

Jaccard 相似系数取值范围为：{\displaystyle 0\leq J(A,B)\leq 1}0≤*J*(*A*,*B*)≤1

Jaccard 距离 则用于量度样本集之间的不相似度，其定义为1减去雅卡尔系数，即:

{\displaystyle d_{J}(A,B)=1-J(A,B)={{|A\cup B|-|A\cap B|} \over |A\cup B|}}*d**J*(*A*,*B*)=1−*J*(*A*,*B*)=∣*A*∪*B*∣∣*A*∪*B*∣−∣*A*∩*B*∣

 

#### 4.7 皮尔逊相关系数

两个变量之间的皮尔逊相关系数定义为两个变量的协方差除以它们标准差的乘积：

{\displaystyle \rho _{X,Y}={\mathrm {cov} (X,Y) \over \sigma _{X}\sigma _{Y}}={E[(X-\mu _{X})(Y-\mu _{Y})] \over \sigma _{X}\sigma _{Y}}}*ρ**X*,*Y*=*σ**X**σ**Y*cov(*X*,*Y*)=*σ**X**σ**Y**E*[(*X*−*μ**X*)(*Y*−*μ**Y*)]

皮尔逊相关系数的变化范围为 [-1, 1][−1,1]。

系数的值为 11 意味着 X*X* 和 Y*Y* 可以很好的由直线方程来描述，所有的数据点都很好的落在一条直线上，且 Y*Y* 随着 X*X* 的增加而增加。

系数的值为 −1−1 意味着所有的数据点都落在直线上，且 Y*Y* 随着 X*X* 的增加而减少。

系数的值为 00 意味着两个变量之间没有线性关系

持续总结和分享机器学习，数据科学方面的知识，欢迎小伙伴们交流讨论...

文章分类
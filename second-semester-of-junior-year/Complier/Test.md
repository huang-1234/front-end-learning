# 实验一 词法分析

## 实验目的

### 编制一个读单词过程，从输入的源程序中，识别出各个具有独立意义的单词，即基本保留字、标识符、常数、运算符、分隔符五大类。并依次输出各个单词的内部编码及单词符号自身值。 

## 实验题目

如源程序为C语言。输入如下一段：

main()

{

int a=-5,b=4,j;

if(a\>=b)

j=a-b;

else j=b-a;

}

要求输出如下：

（"main"，1，1）

（"（"，5）

（"）"，5）

（"{"，5）

（"int"，1，2）

（"a"，2）

（"="，4）

（"-5"，3）

（","，5）

（"b"，2）

（"="，4）

（"4"，3）

（","，5）

（"j"，2）

（";"，5）

（"if"，1,3）

（"（"，5）

（"a"，2）

（"\>="，4）

（"b"，2）

（"）"，5）

（"j"，2）

（"="，4）

（"a"，2）

（"-"，4）

（"b"，2）

（";"，5）

（"else"，1,4）

（"j"，2）

（"="，4）

（"b"，2）

（"-"，4）

（"a"，2）

（";"，5）

（"}"，5）

## 实验理论依据

### (一)识别各种单词符号

1.  程序语言的单词符号一般分为五种：

2.  关键字（保留字/ 基本字）if 、while 、begin...

3.  标识符：常量名、变量名...

4.  常数：34 、56.78 、true 、'a' 、...

5.  运算符：+ 、- 、\* 、/ 、〈 、and 、or 、....

6.  界限符：， ； （ ） { } /\*...

7.  识别单词：掌握单词的构成规则很重要

8.  标识符的识别：字母\| 下划线+( 字母/ 数字/ 下划线)

9.  关键字的识别：与标识符相同，最后查表

10. 常数的识别

11. 界符和算符的识别

12. 大多数程序设计语言的单词符号都可以用转换图来识别，如图1-1

13. 

14. 图1-1

15. 

16. 词法分析器输出的单词符号常常表示为二元式：（单词种别，单词符号的属性值）

17. 单词种别通常用整数编码，如1 代表关键字，2 代表标识符等

18. 关键字可视其全体为一种，也可以一字一种。采用一字一种得分法实际处理起来较为方便。

19. 标识符一般统归为一种

20. 常数按类型（整、实、布尔等）分种

21. 运算符可采用一符一种的方法。

22. 界符一般一符一种的分法。

### (二)超前搜索方法

1.  词法分析时，常常会用到超前搜索方法。

2.  如当前待分析字符串为"a\>+" ，当前字符为"\>" ，此时，分析器倒底是将其分析为大于关系运算符还是大于等于关系运算符呢？

3.  显然，只有知道下一个字符是什么才能下结论。于是分析器读入下一个字符'+' ，这时可知应将'\>' 解释为大于运算符。但此时，超前读了一个字符'+' ，所以要回退一个字符，词法分析器才能正常运行。又比如：'+' 分析为正号还是加法符号

### (三)预处理

预处理工作包括对空白符、跳格符、回车符和换行符等编辑性字符的处理，及删除注解等。由一个预处理子程序来完成。

## 词法分析器的设计

1.  #### 设计方法：

    1.  写出该语言的词法规则。

    2.  把词法规则转换为相应的状态转换图。

    3.  把各转换图的初态连在一起，构成识别该语言的自动机

    4.  设计扫描器

2.  ####  把扫描器作为语法分析的一个过程，当语法分析需要一个单词时，就调用扫描器。 

扫描器从初态出发，当识别一个单词后便进入终态，送出二元式

图1-2 取单词程序框图

## 程序

1.  代码

\#include \<ctype.h\>

\#include \<stdio.h\>

\#include \<string.h\>

// 函数声明

char alphaprocess(char buffer);               // 26

int search(char searchchar\[\], int wordtype);  //

char digitprocess(char buffer);

char otherprocess(char buffer);

char processError(char buffer);

FILE\* fp;

// const KEYWORD = 1;           // 关键字

// const IDENTIFIER = 2;        // 标识符

// const CONSTANT = 3;          // 常量

// const OPERATIONAL_CHAR = 4;  // 运算符

// const BOUND_SYMBOL = 5;      // 界限符

FILE\* fp;

char cbuffer;

char\* key\[100\] = {\"auto\",     \"break\",   \"case\",   \"char\",     \"const\",

                 \"continue\", \"default\", \"do\",     \"double\",   \"else\",

                 \"enum\",     \"extern\",  \"float\",  \"for\",      \"goto\",

                 \"if\",       \"int\",     \"long\",   \"register\", \"return\",

                 \"short\",    \"signed\",  \"sizeof\", \"static\",   \"struct\",

                 \"switch\",   \"typedef\", \"union\",  \"unsigned\", \"void\",

                 \"volatile\", \"while\", 

                 \"typeof\"};

int atype, id = 4;

int dot_flag=0; // 表示一个符号为点的情况

int error_line = 0; // 错误处理函数调用时返回错误程序的行数

void main() {

  // 设置一个所有函数都可以共用的int id 表示当前字符的前一个字符的类型

  // 设置一个main函数全局标记变量

  if ((fp = fopen(\"example.c\", \"r\")) == NULL) /\*只读方式打开一个文件\*/

    printf(\"error\");

  else {

    char cbuffer = fgetc(fp); /\*fgetc( )函数：从磁盘文件读取一个字符\*/

    while (cbuffer != EOF) {

      if (cbuffer == \' \' \|\| cbuffer == \'\\n\' \|\| cbuffer == \'\\t\') /\*掠过空格和回车符以及增加的tab\*/

        cbuffer = fgetc(fp);

      else if (isalpha(cbuffer) \|\| \'\_\'==cbuffer)

        cbuffer = alphaprocess(cbuffer);

      else if (isdigit(cbuffer))

        cbuffer = digitprocess(cbuffer);

      else

        cbuffer = otherprocess(cbuffer);

    }

  }

}

char alphaprocess(char buffer) {

  // printf(\"alphaprocess\--：cbuffer=\'%c\'\\n\",buffer);

  int atype; /\*保留字数组中的位置\*/

  int i = -1;

  char alphatp\[20\];

  while ((isalpha(buffer)) \|\| (isdigit(buffer)) \|\| buffer == \'\_\') {

    alphatp\[++i\] = buffer;

    buffer = fgetc(fp);

  }

  /\*读一个完整的单词放入alphatp数组中\*/

  alphatp\[i + 1\] = \'\\0\';

  atype = search(alphatp, 1); /\*对此单词调用search函数判断类型\*/

  if (atype != 0) {

    printf(\"%s, (1,%d)\\n\", alphatp, atype - 1);

    id = 1;

  } else {

    printf(\"(%s ,2)\\n\", alphatp);

    id = 2;

  }

  // return 一个字符

  return buffer;

}

//

int search(char searchchar\[\], int wordtype){ /\*判断单词是保留字还是标识符\*/

  // printf(\"search\--：cbuffer=\'%s\'\\n\",searchchar);

  int i = 0;

  int p;

  switch (wordtype) {

    case 1:

      for (i = 0; i \<= 32; i++) {

        if (strcmp(key\[i\], searchchar) == 0) {

          p = i + 1;

          break;

        } /\*是保留字则p为非0且不重复的整数\*/

        else

          p = 0; /\*不是保留字则用于返回的p=0\*/

      }

      return (p);

  }

}

//

char digitprocess(char buffer) {

  // printf(\"digitprocess\--：cbuffer=\'%c\'\\n\",buffer);

  int i = -1;

  char digittp\[1000\];  // 一个可以表示数字的字符

  // int flag = 2;        // 判断一个数字只能有一个小数点

  // // dot处理部分

  //  if(dot_flag){

  //   digittp\[++i\]=\'0\';

  //   digittp\[++i\]=\'.\';

  // }

  // 把所有整数放进digittp去

  if (isdigit(buffer)) {

    while (isdigit(buffer)) {

      digittp\[++i\] = buffer;

      buffer = fgetc(fp);

    }

  }

  // 增加处理带百分号的数字，数字后面遇到百分号即可加上输出

  if (\'%\' == buffer) {

    digittp\[++i\] = buffer;

    digittp\[i + 1\] = \'\\0\';

    printf(\"(%s ,3)\\n\", digittp);

    return (buffer);

  }

   // 增加处理带小数点的数字，如果小数点后面有数字，则加进来，否则，还应该把之前加进来的小数点去掉，也就是变为\'\\0\'

  if (\'.\' == buffer) {

    digittp\[++i\] = buffer;

    buffer = fgetc(fp);

    // if(isdigit(buffer)){

    //   buffer = digitprocess(buffer);

    // }

    while (isdigit(buffer)) {

      digittp\[++i\] = buffer;

      buffer = fgetc(fp);

    }

  }

  // 增加处理科学计数法的数字

  if(\'e\'==buffer \|\| \'E\'==buffer){

    digittp\[++i\]=buffer;

    buffer=fgetc(fp);

    if(\'-\'==buffer \|\| \'+\'==buffer){

      digittp\[++i\]=buffer;

      buffer=fgetc(fp);

    }

    while(isdigit(buffer)){

      digittp\[++i\]=buffer;

      buffer=fgetc(fp);

    }

  }

  digittp\[i + 1\] = \'\\0\';

  printf(\"(%s ,3)\\n\", digittp);

  id = 3;

  return (buffer);

}

char otherprocess(char buffer) {

  // printf(\"otherprocess\--:cbuffer=\'%c\':\\n\",buffer);

  char ch\[20\];

  ch\[0\] = buffer;

  ch\[1\] = \'\\0\';

  // char\* boundSymbol\[8\] = {

  //     \'(\', \')\', \',\', \';\', \'{\', \'}\', \'\\\"\',

  // };

   // 新增加了几个界限符：第五类"，\',\#

  if (ch\[0\] == \',\' \|\| ch\[0\] == \';\' \|\| ch\[0\] == \'{\' \|\| ch\[0\] == \'}\' \|\| ch\[0\] == \'(\' \|\| ch\[0\] == \')\' \|\| 

   \'\#\'== ch\[0\] \|\| \'\\\"\'==ch\[0\] \|\| \'\\\'\'==ch\[0\]  \|\| \':\'==ch\[0\] \|\| \'\[\'==ch\[0\] \|\| \'\]\'==ch\[0\]) {

    printf(\"(%s ,5)\\n\", ch);

    buffer = fgetc(fp);

    id = 4;

    return (buffer);

  }

  // 运算符或者其他

  if (ch\[0\] == \'\*\' \|\| ch\[0\] == \'/\' \|\| \'%\'==ch\[0\]) {

    int chindx=1;

    

     // 下面为新增加的，当读到一个符号为\'/\',那么这个符号未必就是\'/\'号，可能是\'÷=\'符号，可能是单行注释，

     // 甚至还可能是多行注释，主要就是看第二个符号是\'=\',\'/\' huozhe \'\*\'

    if(\'/\'==ch\[0\]){

      buffer=fgetc(fp);

      // 注释状态和终止状态

       int commentsStatus=0;

       int commentsFinal = 3;

      if(\'/\' == buffer ){ // 第二个字符为\'/\';说明这里有连续的两个\'/\'

        // printf(\"there comments：\--\\n\");

        ch\[chindx++\]=buffer;

        char comment\[50\]; // 单行注释

        // memset(comment, 0, sizeof comment);    //清空数组,这里如果不清空数组，comment会缓存上一次注释

        buffer=fgetc(fp);

        for(int annoidx=0; \'\\n\'!=buffer ; buffer=fgetc(fp)){

          comment\[annoidx++\]=buffer;

        }

        printf(\"(%s ,5)\\n\", ch);  //我把注释连续两个\'/\'当作第五类

        buffer = fgetc(fp);

        id = 5;

        // 输出注释

        printf(\"this is a comment named: \\n%s\\n\",comment);

        return (buffer);

      }else if(\'\*\'==buffer){  // 多行注释

        char comments\[1000\]; //存储多行注释

        ch\[chindx++\]=buffer;

        commentsStatus = commentsStatus+1;

        buffer=fgetc(fp);

        for(int commentIdx=0; commentsStatus\<commentsFinal; buffer=fgetc(fp) ){

          if(\'\*\'==buffer){

            commentsStatus++;

            buffer=fgetc(fp);

            if(\'/\'==buffer){

              commentsStatus++;

            }else{

              commentsStatus\--;

            }

          }else{

            comments\[commentIdx++\]=buffer;

          }

        }

        printf(\"(%s ,5)\\n\", ch);

        id = 5;

        printf(\"(多行注释:%s ,5)\\n\", comments);  

        id = 5;

        buffer = fgetc(fp);

        return (buffer);

      }else{

        ch\[1\]=\'\\0\';

      }

    }

    // 新增加，算是运算符，放在第四类

    if(\'%\'==ch\[0\]){

      ch\[1\]=\'\\0\';

    }

    //新增加处理\*，有多种情况

    if(\'\*\'==ch\[0\]){

      buffer=fgetc(fp);

      if(\'\*\'==buffer){ //两个\*号代表求方运算

        ch\[1\]=buffer;

        ch\[2\]=\'\\0\';

      }else if(\'=\'==buffer){ // 如果是等于号，则判断为乘等于，归为第四类：运算符

        ch\[1\]=buffer;

        ch\[2\]=\'\\0\';

      }

    }

    printf(\"(%s ,4)\\n\", ch);  //乘除是第四类符号，

    buffer = fgetc(fp);

    id = 4;

    return (buffer);

  }

  

  // 新增加的，处理点运算符

  if(\'.\'==ch\[0\]){

    buffer=fgetc(fp);

    // 新增加

    int chindx=1;

    char dot_after = buffer;

    if(isdigit(dot_after)){

      ch\[chindx++\]=dot_after;

      buffer=fgetc(fp); 

      // 把dot_after修改为buffer,修改这个bug

      for(; isdigit(buffer); ){

        ch\[chindx++\]=buffer;

        buffer=fgetc(fp);

      }

      ch\[chindx++\]=\'\\0\';

    }else if(isalpha(dot_after) \|\| \'\_\'==dot_after){

      ch\[chindx++\]=\'\\0\';

      printf(\"dot:  (%s ,4)\\n\", ch); 

      id = 4;

      return (buffer);

    }

    

    printf(\"dot:  (0%s ,3)\\n\", ch); 

    id = 4;

    return (buffer);

  }

  // 等于，不等于，＜，＞

  // 新增加一些位运算\<\<\< 和 \>\>\>

  if (ch\[0\] == \'=\' \|\| ch\[0\] == \'!\' \|\| ch\[0\] == \'\<\' \|\| ch\[0\] == \'\>\' ) {

    // printf(\"遇到\<,\>就需要走的路\");

    buffer = fgetc(fp);

    int chindx=1;

    if (buffer == \'=\') {

      ch\[1\] = buffer;

      ch\[2\] = \'\\0\';

      printf(\"(%s ,4)\\n\", ch);

      return buffer;

    }else if(\'\<\'==ch\[0\] \|\| \'\>\'==ch\[0\]) {  // 表示在第一个字符是 \> \< 的情况下

      char LessGre_next = buffer; // 表示 \< 或者 \> 的下一个字符

      // buffer = fgetc(fp);

       //表示一定需要两个连续的\< 或者 \>

      if(\'\<\'==ch\[0\] && \'\<\'==LessGre_next){

        ch\[chindx++\]=LessGre_next;

      }else if(\'\>\'==ch\[0\] && \'\>\'==LessGre_next){

        ch\[chindx++\]=LessGre_next;

      }else if(isalpha(LessGre_next) \|\| \'\_\'==LessGre_next){

        ch\[chindx++\]=\'\\0\';

        printf(\"(%s ,5)\\n\", ch);

        id = 5;

        return (buffer);

      }

      ch\[chindx++\]=\'\\0\';

      printf(\"(%s ,4)\\n\", ch);

      id = 4;

      return (buffer);

    }

    printf(\"(%s ,4)\\n\", ch);

    id = 4;

    return (buffer);

  }

  // + 号 和 - 号

  if (ch\[0\] == \'+\' \|\| ch\[0\] == \'-\') {

    //新增加提前取出下一个字符

    buffer = fgetc(fp);

    int chidx=1; // for循环时表示ch字符串的下标

    /\*在当前符号以前是第四类，即为运算符，则此时 + - 为正负号\*/

    if (id == 4 && ( \'+\'==ch\[0\] \|\| \'-\'==ch\[0\] )  ) {

      if(isdigit(buffer) \|\| \'.\'==buffer){ // 新增加，允许符号后面接任意的整数类型，作为一整个数字,归为第三类，本if结束后应该单独return

        printf(\"输出正负数\\n\");

        if(isdigit(buffer)){

          for(; isdigit(buffer); ){

            ch\[chidx++\]=buffer;

            buffer=fgetc(fp);

          }

          if(\'.\'==buffer){

            ch\[chidx++\]=buffer;

            buffer=fgetc(fp);

          }

          for(; isdigit(buffer);  ){

            ch\[chidx++\]=buffer;

            buffer=fgetc(fp);

          }

          // ch\[1\] = buffer;

          ch\[chidx++\] = \'\\0\'; /\*这里只取了一位数字\*/

          printf(\"+ or - : (%s ,3)\\n\", ch);

          id = 3;

          // 就是因为这里多了个buffer = fgetc(fp);

          // buffer = fgetc(fp);

          // return (buffer);

        }else if(\'.\'==buffer){

          ch\[chidx++\] =buffer;

          buffer = fgetc(fp);

          for(; isdigit(buffer);  ){

            ch\[chidx++\]=buffer;

            buffer=fgetc(fp);

          }

          ch\[chidx++\] = \'\\0\'; 

          printf(\"+ or - : (%s ,3)\\n\", ch);

          id = 3;

        }

        return(buffer);

      }

      // buffer = digitprocess(buffer);

    }else{

      printf(\"there is + or - hao\\n\");

      if(\'-\'==ch\[0\]  ){ // // 新增加一个取属性的运算符

        if(\'\>\'==buffer){

          ch\[chidx++\]=buffer;

        }else if(\'-\'==buffer){

          ch\[chidx++\]=buffer;

        }

        ch\[chidx++\] = \'\\0\'; /\*这里只取了一位数字\*/

        printf(\"+ or - : (%s ,4)\\n\", ch);

        id = 4;

        buffer=fgetc(fp);

        return (buffer);

      }else if(\'+\'==ch\[0\]){

        printf(\"there + hao\\n\");

        if(\'+\'==buffer){

          ch\[chidx++\]=buffer;

          buffer=fgetc(fp);

        }else if(\'=\'==buffer){

          ch\[chidx++\]=buffer;

          buffer=fgetc(fp);

        }

        ch\[chidx++\]=\'\\0\';

        printf(\"+ or - : (%s ,4)\\n\", ch);

        id = 3;

        buffer=fgetc(fp);

        return (buffer);

      }

    }

    // ch\[1\] = \'\\0\'; //删除这条语句

    printf(\"(%s ,4)\\n\", ch);

    buffer = fgetc(fp);

    id = 4;

    return (buffer);

  }

  // 新增加位运算 & , \| , \^ , \~ , 还有两个位运算在上面的 \> , \< , 

  if(\'&\'==ch\[0\] \|\| \'\|\'==ch\[0\] \|\| \'\^\'==ch\[0\] \|\| \'\~\'==ch\[0\]){

    int chidx=1;

    buffer=fgetc(fp);

    if(\'&\'==ch\[0\]) { // 表示连续出现两个&&

      if(\'&\'==buffer){

        ch\[chidx++\]=buffer;

      } else if(\'=\'==buffer){

        ch\[chidx++\]=buffer;

      }

    }

    else if(\'\|\'==ch\[0\] ){

      if(\'\|\' ==buffer){

        ch\[chidx++\]=buffer;

      }else if(\'=\'==buffer){

        ch\[chidx++\]=buffer;

      }else{

        // ch\[chidx++\]=\'\\0\';

      }

    }

    else if(\'\^\'==ch\[0\]){

      if(\'=\'==buffer){

        ch\[chidx++\]=buffer;

      } else{

        // ch\[chidx++\]=\'\\0\';

      }

    }else if(\'\~\'==ch\[0\]){

      if(\'=\'== buffer){

        ch\[chidx++\]=buffer;

      }else{

        // ch\[chidx++\]=\'\\0\';

      }

    }

    ch\[chidx++\]=\'\\0\';

    printf(\"(%s ,4)\\n\", ch);

    id = 4;

    return (buffer);

  }

  if(\'\\\\\'==ch\[0\]){

    buffer=fgetc(fp);

    ch\[1\]=buffer;

    ch\[2\]=\'\\0\';

    

    printf(\"(%s ,2)\\n\", ch);

    id = 2;

    return (buffer);

  }

  if(\'?\'==ch\[0\]){ //问号属于运算符

    ch\[1\]=\'\\0\';

    printf(\"(%s ,4)\\n\", ch);

    id = 4;

    buffer=fgetc(fp);

    return (buffer);

  }

}

char processError(char buffer){

  // printf(\"otherprocess\--:\'%c\'\",buffer);

  return (buffer);

}

*// 程序加了一些flag用于判断负数和小数，以及符号的闭合。*

*// 保留字、头文件、常量*

*// 整数、小数、正负整数小数、科学计数法*

*// 结构体，指针及其运算符*

*// scanf、printf、() \[\] {} 、占位符、制表符等*

*// 所有运算符*

*// 注释符*

2.  测试

    （1）保留字、头文件、常量

*\#include* \<stdio.h\>

*\#define* MAX 100

*switch*(ch) {

  *case* 1: *break*;

  *default*: *break*; 

}

*return* 0;

![](media/image2.png){width="1.7916666666666667in" height="2.216666666666667in"} ![](media/image3.png){width="1.525in" height="2.216666666666667in"}

2.  整数、小数、正负整数小数、科学计数法

*float* a1*=-*.12, a2*=*34., a3*=*12.34, a4*=*123;

*double* b1*=*.12*E*2, b2*=*1.*e*2, b3*=*1.2*e*3,b4*=*12*e+*3;

*double* c1*=-*.12*E*2, c2*=-*1.*e*2, c3*=-*1.2*e*3, c4*=+*12*e-*2;

*[12.123.123.123.123]{.ul}*

*[.123.123.123.123 ]{.ul}*

![](media/image4.png){width="1.3756944444444446in" height="2.5590277777777777in"} ![](media/image5.png){width="1.367361111111111in" height="2.5680555555555555in"} ![](media/image6.png){width="1.525in" height="2.5680555555555555in"} ![](media/image7.png){width="1.35in" height="1.4083333333333334in"}

3.  结构体，指针及其运算符

*typedef* *struct* *type*

{

  *char* origin;     

} *type*;

\_type e, t;

e.origin *=* \'0\';

*int* *\**b *=* *&*c   

*\**a *-\>* *&*b; 

![](media/image8.png){width="1.875in" height="3.033333333333333in"} ![](media/image9.png){width="1.6in" height="3.025in"}

4.  scanf、printf、() \[\] {} 、占位符、制表符等

*int* a\[10\]

scanf(\"%c\", *&a*);

printf(\"a+b=c\");

printf(\"\\t \\n\");

printf(\"%d, %c, %f, %g, %s\", a,b,c);

*int* main(){}

![](media/image10.png){width="1.3923611111111112in" height="2.517361111111111in"} ![](media/image11.png){width="1.3583333333333334in" height="2.5166666666666666in"} ![](media/image12.png){width="1.4in" height="2.517361111111111in"} ![](media/image13.png){width="1.475in" height="2.509027777777778in"}

5.  所有运算符

*+* ; *-* ; *\** ; */* ; *+=* ; *-=* ; *\*=* ; */=* ;

*%* ; *=* ; *\^* ; *%=* ; *==* ; *\^=* ;

*\>* ; *\<* ; *\>=* ; *\<=* ; *\<\<* ; *\>\>* ;

*&* ; *\|* ; *!* ; *&=* ; *\|=* ; *!=* ; *&&* ; *\|\|* ;

![](media/image14.png){width="1.5833333333333333in" height="3.7083333333333335in"} ![](media/image15.png){width="1.3916666666666666in" height="3.6930555555555555in"}

c *=* a*++* *+* *++*b;

c *=* a*\--* *-* *++*b;

c *=* a*++* *-* *-*b;

c *=* a*\--* *-* *+*b;

e *=* a*\>*0 *?* c *:* d;

a*+-*

![](media/image16.png){width="1.65in" height="2.1951388888888888in"} ![](media/image17.png){width="1.5916666666666666in" height="2.175in"} ![](media/image18.png){width="1.6416666666666666in" height="2.1743055555555557in"}

![](media/image19.png){width="1.4583333333333333in" height="1.5333333333333334in"}（6）注释符

*// a+b*

*/\* a+b \*/*

#  实验二 LL（1）分析法

## 一、实验目的：

**根据某一文法编制调试LL(1)分析程序，以便对任意输入的符号串进行分析。本次实验的目的主要是加深对预测分析LL(1)分析法的理解。**

## 二、实验题目

> **实验规定对下列文法，用LL（1）分析法对任意输入的符号串进行分析：**
>
> **（1）E::=TG**
>
> **（2）G::=+TG**
>
> **（3）G::=ε**
>
> **（4）T::=FS**
>
> **（5）S::=\*FS**
>
> **（6）S::=ε**
>
> **（7）F::=(E)**
>
> **（8）F::=i**

**若输入串为i+i\*i\# ，则输出为：**

LL(1)的分析表为：

+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+
|       | **i**  | **+**  | **\*** | **(** | **)**  | **\#** | **说 明**                                         |
+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+
| **E** | **e**  |        |        | **e** |        |        | **Select(E→TG)=｛(,i｝**                          |
+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+
| **G** |        | **g**  |        |       | **g1** | **g1** | **Select (G→+TG)=｛+｝**                          |
|       |        |        |        |       |        |        |                                                   |
|       |        |        |        |       |        |        | **Select (G→є)=｛\#,)｝**                         |
+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+
| **T** | **t**  |        |        | **t** |        |        | **Select (T→FS)=｛(,i｝**                         |
+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+
| **S** |        | **s1** | **s**  |       | **s1** | **s1** | **Select (S→\*FS)=｛\*｝Select (S→є)=｛\#,) +｝** |
+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+
| **F** | **f1** |        |        | **f** |        |        | **Select (F→(E))=｛(｝**                          |
|       |        |        |        |       |        |        |                                                   |
|       |        |        |        |       |        |        | **Select (F→i)=｛i｝**                            |
+-------+--------+--------+--------+-------+--------+--------+---------------------------------------------------+

## 三、程序

1\. 代码

*\#include* \<stdio.h\>

*\#include* \<stdlib.h\>

*\#include* \<string.h\>

*// 分析栈*

*char* A\[20\];

*// 剩余字符串                               *

*char* B\[20\];  

*// 终结符                                 *

*char* v1\[20\] *=* {\'i\', \'+\', \'\*\', \'(\', \')\', \'\#\'};

*// 非终结符 *

*char* v2\[20\] *=* {\'E\', \'G\', \'T\', \'S\', \'F\'};

*// b 为剩余字符串的下标，top 为分析栈栈顶，l为输入串长度*

*int* b *=* 0, top *=* 0, l; 

*// 预测分析表中元素的所有属性*

*typedef* *struct* *type*

{

    *char* origin;        *// 产生式左边的非终结符*

    *char* array\[5\];      *// 产生式右边字符*

    *int* length;         *// 产生式右边字符长度*

} *type*;

*// Select 集对应元素*

*type* e, t, g, g1, s, s1, f, f1, cha;

*// 预测分析表 *

*type* C\[10\]\[10\];                     

*// 输出分析栈*

*void* print() {

    *int* a; */\*指针\*/*

    *for* (a *=* 0; a *\<=* top *+* 1; a*++*) {

        printf(\"%c\", A\[a\]);

    }

    printf(\"\\t\\t\");

}

*// 输出剩余串*

*void* prinT() {

    *int* j;

    *// 对齐处理*

    *for* (j *=* 0; j *\<* b; j*++*) {

        printf(\" \");

    }

    *for* (j *=* b; j *\<=* l; j*++*) {

        printf(\"%c\", B\[j\]);

    }    

    printf(\"\\t\\t\\t\");

}

*int* main() {

    *int* m, n, j *=* 0, step *=* 1;

    *int* flag *=* 0, finish *=* 0;

    *char* ch, x;

    *// 将 Select 集结果赋值给对应元素*

    e.origin *=* \'E\';

    strcpy(e.array, \"TG\");

    t.origin *=* \'T\';

    strcpy(t.array, \"FS\");

    g.origin *=* \'G\';

    strcpy(g.array, \"+TG\");

    g1.origin *=* \'G\';

    g1.array\[0\] *=* \'\^\';

    s.origin *=* \'S\';

    strcpy(s.array, \"\*FS\");

    s1.origin *=* \'S\';

    s1.array\[0\] *=* \'\^\';

    f.origin *=* \'F\';

    strcpy(f.array, \"(E)\");

    f1.origin *=* \'F\';

    f1.array\[0\] *=* \'i\';

    *// 初始化分析表，m表示行，n表示列*

    *for* (m *=* 0; m *\<=* 4; m*++*)

        *for* (n *=* 0; n *\<=* 5; n*++*)

            C\[m\]\[n\].origin *=* \'N\';

    *// 填充分析表，将元素填入预测分析表*

    C\[0\]\[0\] *=* C\[0\]\[3\] *=* e;

    C\[1\]\[1\] *=* g;

    C\[1\]\[4\] *=* C\[1\]\[5\] *=* g1;

    C\[2\]\[0\] *=* C\[2\]\[3\] *=* t;

    C\[3\]\[1\] *=* C\[3\]\[4\] *=* C\[3\]\[5\] *=* s1;

    C\[3\]\[2\] *=* s;

    C\[4\]\[0\] *=* f1;

    C\[4\]\[3\] *=* f;

    printf(\"请输入预分析串：\\n\");

    *// 读入分析串*

    *do* {

        scanf(\"%c\", *&*ch);

        *if* ((ch *!=* \'i\') *&&* (ch *!=* \'+\') *&&* (ch *!=* \'\*\') *&&* (ch *!=* \'(\') *&&*

            (ch *!=* \')\') *&&* (ch *!=* \'\#\')) {

            printf(\"输入串中有非法字符\\n\");

            exit(1);

        }

        B\[j\] *=* ch;

        j*++*;

    } *while* (ch *!=* \'\#\');

    l *=* j;           *// 分析串长度     *

    ch *=* B\[0\];  *// 当前分析字符*

    A\[top\] *=* \'\#\';

    A\[*++*top\] *=* \'E\';     *// \'\#\',\'E\'进栈*

    *// A\[++top\] = \'i\';  // 测试终结符不匹配用*

    printf(\"步骤\\t\\t分析栈\\t\\t剩余字符\\t\\t所用产生式\\n\");

    *do* {

        x *=* A\[top*\--*\];   *// x为当前栈顶字符*

        printf(\"%d\\t\\t\", step*++*);

        *// 判断是否为终结符，用 flag 标记*

        *for* (j *=* 0; j *\<=* 5; j*++*) { 

            *if* (x *==* v1\[j\]) {

                flag *=* 1;

                *break*;

            }

        }

        *// 为终结符*

        *if* (flag *==* 1) {

            *if* (x *==* \'\#\') {

                *if* (ch *!=* \'\#\') {

                    print();

                    prinT();

                    printf(\"err! 分析栈的\'\#\'不匹配!\\n\");

                    exit(1);

                }

                *// 结束标记，可能有其他用途*

                finish *=* 1;      

                print();

                prinT();

                printf(\"acc!\\n\");

                exit(1);

            }

            *if* (x *==* ch) {

                print();

                prinT();

                printf(\"%c匹配\\n\", ch);

                *// 分析下一个剩余字符串里的字符*

                ch *=* B\[*++*b\]; 

                flag *=* 0;   

            } *else* {    *// 程序一般不会跑到这里，终结符不匹配*

                print();

                prinT();

                printf(\"%c与%c不匹配\\n\", x, ch);

                exit(1);

            }

        } *else* {    *// 为非终结符*

            *for* (j *=* 0; j *\<=* 4; j*++*) {

                *if* (x *==* v2\[j\]) {

                    m *=* j;

                    *break*;

                }

            }

            *for* (j *=* 0; j *\<=* 5; j*++*) {

                *if* (ch *==* v1\[j\]) {

                    n *=* j;

                    *break*;

                }

            }

            cha *=* C\[m\]\[n\];

            cha.length *=* strlen(cha.array);

            *// 查表查得到*

            *if* (cha.origin *!=* \'N\') {

                print();

                prinT();

                *// 输出产生式*

                printf(\"%c-\>\", cha.origin);

                *for* (j *=* 0; j *\<* cha.length; j*++*) {

                    *if* (cha.array\[j\] *==* \'\^\') {

                        printf(\"空规则\");

                    } *else* {

                        printf(\"%c\", cha.array\[j\]);

                    }

                }

                printf(\"\\n\");

                *// 产生式逆序入栈，空规则不入栈*

                *for* (j *=* ((cha.length) *-* 1); j *\>=* 0; j*\--*) { 

                    A\[*++*top\] *=* cha.array\[j\];

                    *if* (A\[top\] *==* \'\^\') {

                        top*\--*;

                    }

                }

            } *else* *if* (ch *==* \'\#\'){ 

                print();

                prinT();

                printf(\"err! 剩余字符的\'\#\'不匹配!\\n\");

                exit(1);

            } *else* {

                print();

                prinT();

                printf(\"产生式不存在!\");

                exit(1);

            }

        }

    } *while* (1);

}

2\. 测试

（1）正常情况下：i+i\*i\#

![](media/image20.png){width="5.525in" height="3.075in"}

（2）产生式不存在：i+ii\#

![](media/image21.png){width="5.708333333333333in" height="2.0416666666666665in"}

（3）剩余字符串的'\#'不匹配：i+i+\#

![](media/image22.png){width="5.999305555555556in" height="2.3180555555555555in"}

（4）分析栈的'\#'不匹配：i\*i)\#

![](media/image23.png){width="6.0in" height="1.9944444444444445in"}

（5）两边终结符不匹配：)\#

# ![](media/image24.png){width="5.7in" height="0.4083333333333333in"} 实验三 逆波兰式的产生及计算

## 一、实验目的

**将用中缀式表示的算术表达式转换为用逆波兰式表示的算术表达式，并计算用逆波兰式来表示的算术表达式的值**

## 二、实验题目

如输入如下：**21+（（42-2）\*15+6 ）-18\#**

输出为：

**原来表达式： 21+（（42-2）\*15+6 ）- 18\#**

**后缀表达式：21&42&2&-15&\*6&++18&-**

**计算结果：609**

## 三、算法流程图

图3-1 生成逆波兰式的程序流程图

图3-2 计算逆波兰式的程序流程图

## 参考程序代码

1.  代码

*\#include* \<stdio.h\>

*\#include* \<stdlib.h\>

*\#include* \<ctype.h\>

*\#include* \<math.h\>

*\#define* MAX 100

*char* ex\[MAX\]; *// 存放逆波兰式*

*// 逆波兰式的生成*

*void* trans() {

*// 存放原输入串*

    *char* str\[MAX\];

    *char* stack\[MAX\];

    *char* ch;

    *int* num, i *=* 0, j, t *=* 0, top *=* 0;

    printf(\"\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\\n\");

    printf(\"请输入需要运算的式子，以'\#'键结束\\n\");

    printf(\"\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\\n\");

    *// 读入原表达式*

    *do* {

        scanf(\"%c\", *&*str\[i\]);

        i*++*;

    } *while* (str\[i *-* 1\] *!=* \'\#\' *&&* i *!=* MAX);

    num *=* i;

    i *=* t *=* 0;

    ch *=* str\[i\];

    i*++*;

    *while* (ch *!=* \'\#\') {

        *switch* (ch) {

        *case* \'(\':

            top*++*;

            stack\[top\] *=* ch;

            *break*;

        *case* \')\':

            *while* (stack\[top\] *!=* \'(\') {

                ex\[t\] *=* stack\[top\];

                top*\--*;

                t*++*;

            }

            top*\--*;

            *break*;

        *case* \'+\':

        *case* \'-\':

            *if* (stack\[top\] *==* \'(\' *\|\|* *!*isdigit(ex\[0\])) {

                ch *=* \'@\';

            }

            *while* (top *!=* 0 *&&* stack\[top\] *!=* \'(\') {

                ex\[t\] *=* stack\[top\];

                top*\--*;

                t*++*;

            }

            top*++*;

            stack\[top\] *=* ch;

            *break*;

        *case* \'\*\':

        *case* \'/\':

        *case* \'%\':

            *while* (stack\[top\] *==* \'\*\' *\|\|* stack\[top\] *==* \'/\' *\|\|*

                stack\[top\] *==* \'%\' *\|\|* stack\[top\] *==* \'\^\') {

                ex\[t\] *=* stack\[top\];

                top*\--*;

                t*++*;

            }

            top*++*;

            stack\[top\] *=* ch;

            *break*;

        *case* \'\^\':

            top*++*;

            stack\[top\] *=* ch;

            *break*;

        *case* \'.\':

            ex\[t\] *=* \'0\';

            t*++*;

            ex\[t\] *=* \'.\';

            t*++*;

            *break*;

        *default*:

            *while* (ch *\>=* \'0\' *&&* ch *\<=* \'9\') {

                ex\[t\] *=* ch;

                t*++*;

                ch *=* str\[i\];

                i*++*;

            }

            *if* (ch *==* \'.\') {

                ex\[t\] *=* ch;

                t*++*;

                ch *=* str\[i\];

                i*++*;

                *while* (ch *\>=* \'0\' *&&* ch *\<=* \'9\') {

                    ex\[t\] *=* ch;

                    t*++*;

                    ch *=* str\[i\];

                    i*++*;

                }

            }

            i*\--*;

            ex\[t\] *=* \' \';

            t*++*;

            *break*;

        }

        ch *=* str\[i\];

        i*++*;

    }

    *while* (top *!=* 0) {

        *if* (stack\[top\] *!=* \'(\') {

            ex\[t\] *=* stack\[top\];

            t*++*;

            top*\--*;

        } *else* {

            printf(\"error\");

            top*\--*;

            exit(0);

        }

        ex\[t\] *=* \'\#\';

    }

    printf(\"\\n原来的式子为：\\n\");

    *for* (j *=* 0; j *\<* num; j*++*) {

        printf(\"%c\", str\[j\]);

    }

    printf(\"\\n逆波兰式为：\\n\");

    *for* (j *=* 0; j *\<* t; j*++*) {

        printf(\"%c\", ex\[j\]);

    }

}

// 计算逆波兰式

*void* countvalue() {

    *float* stack\[MAX\], d1, d2, i *=* 0.1;

    *char* ch;

    *int* t *=* 0, top *=* 0;

    ch *=* ex\[t\];

    t*++*;

    *while* (ch *!=* \'\#\') {

        *switch* (ch) {

        *case* \'+\':

            stack\[top *-* 1\] *=* stack\[top *-* 1\] *+* stack\[top\];

            top*\--*;

            *break*;

        *case* \'-\':

            stack\[top *-* 1\] *=* stack\[top *-* 1\] *-* stack\[top\];

            top*\--*;

            *break*;

        *case* \'\*\':

            stack\[top *-* 1\] *=* stack\[top *-* 1\] *\** stack\[top\];

            top*\--*;

            *break*;

        *case* \'/\':

            *if* (stack\[top\] *!=* 0)

                stack\[top *-* 1\] *=* stack\[top *-* 1\] */* stack\[top\];

            *else* {

                printf(\"\\n\\t除零错误!\\n\");

                exit(1);

            }

            top*\--*;

            *break*;

        *case* \'%\':

            stack\[top *-* 1\] *=* (*int*)stack\[top *-* 1\] *%* (*int*)stack\[top\];

            top*\--*;

            *break*;

        *case* \'\^\':

            stack\[top *-* 1\] *=* pow(stack\[top *-* 1\], stack\[top\]);

            top*\--*;

            *break*;

        *case* \'@\':

            stack\[top\] *=* *-*stack\[top\];

            *break*;

        *default*:

            d1 *=* 0;

            d2 *=* 0;

            i *=* 0.1;

            *while* (ch *\>=* \'0\' *&&* ch *\<=* \'9\') {

                d1 *=* 10 *\** d1 *+* ch *-* \'0\';

                ch *=* ex\[t\];

                t*++*;

            }

            *if* (ch *==* \'.\') {

                ch *=* ex\[t\];

                t*++*;

                *while* (ch *\>=* \'0\' *&&* ch *\<=* \'9\') {

                    d2 *=* i *\** (ch *-* \'0\') *+* d2;

                    ch *=* ex\[t\];

                    t*++*;

                    i *=* 0.1 *\** i; 

                }

            }

            d1 *=* d1 *+* d2;

            top*++*;

            stack\[top\] *=* d1;

            *break*;

        }

        *// printf(\"\\n%g, %g, %g\", stack\[0\], stack\[1\], stack\[2\]);*

        ch *=* ex\[t\];

        t*++*;

    }

    printf(\"\\n计算结果为：%g\", stack\[top\]);

}

*int* main() {

    trans();

    countvalue();

    *return* 0;

}

2.  测试

```{=html}
<!-- -->
```
1.  (-(.32\*100+6)-2)/4%(-2)\^3\#

    ![](media/image25.png){width="3.325in" height="1.675in"}

2.  2\^2\^3\#

    ![](media/image26.png){width="3.5166666666666666in" height="1.6666666666666667in"}

3.  (2\^2)\^3\#

    ![](media/image27.png){width="3.433333333333333in" height="1.7833333333333334in"}

#  **实验四 LR(1)分析法**

## 一、实验目的

**构造LR(1)分析程序，利用它进行语法分析，判断给出的符号串是否为该文法识别的句子，了解LR（K）分析方法是严格的从左向右扫描，和自底向上的语法分析方法**

## 二、实验题目：

**1、对下列文法，用LR（1）分析法对任意输入的符号串进行分析：**

> **（0）E-\>S**
>
> **（1）S-\>BB**
>
> **（2）B-\>aB**
>
> **（3）B-\>b**

2、LR(1)分析表为：

---------- ------------ ---------- --------- ------- ------- ---
  **状态**   **ACTION**   **GOTO**                             
             **a**        **b**      **\#**    **S**   **B**    
  **S0**     **S3**       **S4**               **1**   **2**   
  **S1**                             **acc**                   
  **S2**     **S6**       **S7**                       **5**   
  **S3**     **S3**       **S4**                       **8**   
  **S4**     **r3**       **r3**                               
  **S5**                             **r1**                    
  **S6**     **S6**       **S7**                       **9**   
  **S7**                             **r3**                    
  **S8**     **r2**       **r2**                               
  **S9**                             **r2**                    
---------- ------------ ---------- --------- ------- ------- ---

(1)若输入baba\#，则输出为：

**步骤 状态栈 符号栈 输入串 ACTION GOTO**

**1 0 \# baba\# S4**

**2 04 \#b aba\# r3 2**

**3 02 \#B aba\# S6**

**4 026 \#Ba ba\# S7**

**5 0267 \#Bab a\# error**

(2)若输入bb\#，则输出为：

**步骤 状态栈 符号栈 输入串 ACTION GOTO**

**1 0 \# bb\# S4**

**2 04 \#b b\# r3 2**

**3 02 \#B b\# S7**

**4 027 \#Bb \# r3 5**

**5 025 \#BB \# r1 1**

**6 01 \#S \# acc**

## 三、算法流程图

## 四、参考程序代码

1\. 代码

\#include \<stdio.h\>

\#include \<string.h\>

\#include \<stdlib.h\>

//  ACTION 表

char \*action\[10\]\[3\] = {

    \"S3\#\", \"S4\#\", NULL,

    NULL, NULL, \"acc\",

    \"S6\#\", \"S7\#\", NULL,

    \"S3\#\", \"S4\#\", NULL,

    \"r3\#\", \"r3\#\", NULL,

    NULL, NULL, \"r1\#\",

    \"S6\#\", \"S7\#\", NULL,

    NULL, NULL, \"r3\#\",

    \"r2\#\", \"r2\#\", NULL,

    NULL, NULL, \"r2\#\"};

// GOTO 表

int goto1\[10\]\[2\] = {

    1, 2,

    0, 0,

    0, 5,

    0, 8,

    0, 0,

    0, 0,

    0, 9,

    0, 0,

    0, 0,

    0, 0};

/\*存放终结符\*/

char vt\[3\] = {\'a\', \'b\', \'\#\'};

/\*存放非终结符\*/

char vn\[2\] = {\'S\', \'B\'};

/\*存放产生式\*/;

char \*LR\[4\] = {\"E-\>S\#\", \"S-\>BB\#\", \"B-\>aB\#\", \"B-\>b\#\"};

int main() {

  int count = 0;     // count 步骤

  int a\[20\];         // a\[\] 状态栈数组

  char b\[20\], c\[20\]; // b\[\] 符号栈数组，c\[\] 输入串数组

  int top = 0, top1 = 0, top2 = 0, top3 = 0; // top c的栈顶，top1、top2、top3 分别指向 a、b、c的栈顶

  int y = 0, j = 0, k = 0; // 查表用的下标，y 状态栈栈顶，j ACTION的列号，k GOTO的列号

  // z ACTION表中移进状态的数值，h ACTION表中归约状态的数值，p GOTO表中状态的数值

  int z = 0, h = 0, p = 0;

  // m 输出状态栈的循环下标，n 输出符号栈的循环下标，g 输出剩余串的循环下标，i 输出ACTION的循环下标

  int m = 0, n = 0, g = 0, i = 0;

  // l 产生式右部的长度，不包括\'\#\'

  int l = 0;

  // x 当前剩余串栈顶字符

  char x;

  // copy\[\] 获取到的ACTION表中字符串，copy1\[\] 获取到的整个产生式

  char copy\[20\], copy1\[20\];

  a\[top1\] = 0; // 状态栈初始化

  b\[top2\] = \'\#\'; // 符号栈初始化

  // 输入串

  printf(\"请输入要分析的字符串，以\#结尾：\\n\");

  do{

    scanf(\"%c\", &c\[top3\]);

    top3++;

  } while (c\[top3 - 1\] != \'\#\');

  top3 = top3 - 1;

  printf(\"步骤\\t状态栈\\t\\t符号栈\\t\\t输入串\\t\\tACTION\\t\\tGOTO\\n\");

  do{

    y = z; m = 0; n = 0;  // y,x pointer the stackTop of statusStack

    g = top; j = 0; k = 0;

    x = c\[top\];

    count++;

    printf(\"%d\\t\", count);

    // 输出状态栈

    while (m \<= top1) {

      printf(\"%d\", a\[m\]);

      m = m + 1;

    }

    printf(\"\\t\\t\");

    // 输出符号栈

    while (n \<= top2) {

      printf(\"%c\", b\[n\]);

      n = n + 1;

    }

    printf(\"\\t\\t\");

    // 输出输入串

    while (g \<= top3) {

      printf(\"%c\", c\[g\]);

      g = g + 1;

    }

    printf(\"\\t\\t\");

    // 查动作表

    if (x == \'a\')

      j = 0;

    if (x == \'b\')

      j = 1;

    if (x == \'\#\')

      j = 2;

    if (action\[y\]\[j\] == NULL) { // 查找失败

      // 失败将提前退出程序

      printf(\"error\\n\");

      exit(0);

    } else

      // 将ACTION表取到的值存入copy

      strcpy(copy, action\[y\]\[j\]);

    // 处理移进

    if (copy\[0\] == \'S\') {  // 第一个是S肯定要移入

      z = copy\[1\] - \'0\';

      // top1 = top1 + 1;

      // top2 = top2 + 1;

      a\[++top1\] = z;

      b\[++top2\] = x;

      top = top + 1;

      // 输出ACTION

      i = 0;

      while (copy\[i\] != \'\#\') {

        printf(\"%c\", copy\[i\]);

        i++;

      }

      printf(\"\\n\");

    }

    // 处理归约

    if (copy\[0\] == \'r\') { // when copy\[0\]==\'r\' , it should been reduced

      // 输出ACTION

      i = 0;

      while (copy\[i\] != \'\#\') {

        printf(\"%c\", copy\[i\]);

        i++;

      }

      // 获取产生式

      h = copy\[1\] - \'0\'; // use h record the 产生式

      strcpy(copy1, LR\[h\]);

      // when copy\[0\] is \'S\' , that is the 0 coloum of GOTO table

      if (copy1\[0\] == \'S\') // the first coloum is \'S\'

        k = 0;

      if (copy1\[0\] == \'B\') // the second coloum is \'B\'

        k = 1;

      // 状态栈和符号栈退栈

      l = strlen(LR\[h\]) - 4; 

      top1 = top1 - l + 1;

      top2 = top2 - l + 1;

      y = a\[top1 - 1\];

      p = goto1\[y\]\[k\];

      a\[top1\] = p;

      b\[top2\] = copy1\[0\];

      z = p;

      printf(\"\\t\\t\");

      printf(\"%d\\n\", p);

    }

  } while (action\[y\]\[j\] != \"acc\");

  // 成功的输出

  printf(\"acc!\");

}

2\. 测试

\(1\) 结果为acc，有三种情况，其中(aa\...)表示任意个a(包括0)。

1\) aabbba\#

![](media/image28.png){width="5.997916666666667in" height="2.65625in"}

2)  (aa\...)bb\#

![](media/image29.png){width="5.995138888888889in" height="2.588888888888889in"}

3)  (aa..)(bb\...)a\#

    ![](media/image30.png){width="5.996527777777778in" height="2.0729166666666665in"}

```{=html}
<!-- -->
```
(2) 结果为error，除上面三种情况外的所有情况。

```{=html}
<!-- -->
```
1)  ababab\#

    ![](media/image31.png){width="5.996527777777778in" height="1.6770833333333333in"}

2)  aaaa\#

    ![](media/image32.png){width="5.996527777777778in" height="1.4534722222222223in"}

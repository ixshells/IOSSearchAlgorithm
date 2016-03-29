# IOSSearchAlgorithm
基于IOS开发的一个tag关键字搜索匹配算法
这是一个非常基本的搜索算法，但是对于一般的ios客户端来收还是挺实用的。

此搜索算法支持多关键字匹配的方式，会根据关键字所在顺序进行加权搜索

1.  首先匹配整条搜索信息，匹配权重最重

2.  如果未搜索到，那么进行分词，首先对关键字进行匹配个数进行加权，
    分词越靠前面 ， 权重就越高。

3. 最后将搜索到的匹配的tag通过二分插入法插入有序的序列中。



![](https://github.com/ixshells/IOSSearchAlgorithm/blob/master/resouce/g.jpg)  
![](https://github.com/ixshells/IOSSearchAlgorithm/blob/master/resouce/f.png)  

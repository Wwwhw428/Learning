# 踩坑

## Unity版本问题

* 使用版本为2020.2.6f1

### 顶点着色器输出结构

书中5.2.3末尾

``` c
v2f vert(a2v v):SV_POSITION
{
    v2f o;
    o.pos=UnityObjectToClipPos(v.vertex);

    o.color=v.normal * 0.5 + fixed3(0.5,0.5,0.5);
    return o;
}
//报错：invalid output semantic 'SV_POSITION': Legal indices are in [0,0]
```

新版本

``` c
v2f vert(a2v v)
{
    v2f o;
    o.pos=UnityObjectToClipPos(v.vertex);
    o.color=v.normal * 0.5 + fixed3(0.5,0.5,0.5);
    return o;
}
void vert(in a2v v,out v2f o)
{
    o.pos=UnityObjectToClipPos(v.vertex);
    o.color=v.normal * 0.5 + fixed3(0.5,0.5,0.5);
}
```

## Unity内置函数

* `mul (UNITY_MATRIX_MVP, v)`替换为`UnityObjectToClipPos(v)`

test

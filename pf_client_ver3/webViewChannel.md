### h5 与 flutter 交互协议文档

#### 页面跳转

> 协议名称 name: `Jump`, 参数 params: page [String]

| 页面           | 参数 (params) |
| -------------- | ------------- |
| VIP 页面       | vipPage       |
| 圣诞节专题页面 | ZT_christmas  |
| 返回上一页     | pre           |

#### 示例代码

```html
<body>
    <button onclick="postMsg()">测试</button>
</body>
<script>
    var postMsg = function() {
        CallFlutter.postMessage(
            JSON.stringify({
                name: "Jump",
                params: {
                    page: "ZT_christmas"
                }
            })
        );
    };
</script>
```
